package bookshop.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-----------------------------------------------------------------------------------------------------------
// 구매관련 DAO
//-----------------------------------------------------------------------------------------------------------
public class BuyDAO {

	//-----------------------------------------------------------------------------------------------------------
	// CartDAO 인스턴스를 생성한다.
	//-----------------------------------------------------------------------------------------------------------
	private static BuyDAO instance = new BuyDAO();

	//-----------------------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//-----------------------------------------------------------------------------------------------------------
	public static BuyDAO getInstance() {
		return instance;
	} // End - public static BuyDAO getInstance()

	//-----------------------------------------------------------------------------------------------------------
	// 기본 생성자
	//-----------------------------------------------------------------------------------------------------------
	private BuyDAO() {}

	//-----------------------------------------------------------------------------------------------------------
	// 커넥션 풀로부터 커넥션 객체를 얻어내는 메서드
	//-----------------------------------------------------------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context	initCtx	= new InitialContext();
		
		// initCtx의 lookup메서드를 이용해서 "java:comp/env"에 해당하는 객체를 찾아서 envCtx에 저장한다.
		Context	envCtx = (Context) initCtx.lookup("java:comp/env");
		
		// envCtx.lookup("jdbc/bookshopdb") => context.xml의 <ResourceLink>의 name에 적은 것과 동일하게 작성해야 한다.
		DataSource ds = (DataSource) envCtx.lookup("jdbc/bookshopdb");
		
		// System.out.println("DataSource : " + ds);
		return ds.getConnection();
	} // End - private Connection getConnection()
	
	//-----------------------------------------------------------------------------------------------------------
	// 판매처에 입금할 수 있는 모든 계좌정보를 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public List<BankDTO> getAccount() throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BankDTO>		accountList	= null;
		
		try {
			sql		= "SELECT * FROM bank";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			// 처음으로 데이터 커서가 이동할 수 있다면 데이터가 한 건이라도 있다는 것이다.
			if(rs.next()) {
				accountList = new ArrayList<BankDTO>();
				
				do {
					BankDTO	account	= new BankDTO();
					
					account.setAccount	(rs.getString("account"));
					account.setBank		(rs.getString("bank"));
					account.setName		(rs.getString("name"));
					
					accountList.add(account);
				} while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return accountList;
		
	} // End - public List<BankDTO> getAccount()

	//-----------------------------------------------------------------------------------------------------------
	// 구매확정을 하면 발생화는 트랜젝션
	// Book Table(update : 재고 감소), Buy Table(insert : 구매이력 생성), Cart Table(delete : 장바구니 비우기)
	//-----------------------------------------------------------------------------------------------------------
	public void insertBuy(List<CartDTO> lists, String userID, String account, String deliveryName, String deliveryTel,
							String deliveryAddress) throws Exception 
	{
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		Timestamp			reg_date	= null;
		String				sql			= "";
		String				maxDate		= "";
		String				number		= "";
		String				todayDate	= "";
		String				compareDate	= "";
		long				buyID		= 0L;
		short				nowCount;
				
		try 
		{
			conn	= getConnection();
			
			// 구매번호 : yyyymmdd + 일련번호(5)
			reg_date 	= new Timestamp(System.currentTimeMillis());
			System.out.println("reg_date : " + reg_date);
			todayDate	= reg_date.toString();
			
			// reg_date : 2021-09-27 12:37:59.237
			// 시스템 일자에서 yyyymmdd만 잘라내어 compareDate에 저장한다.
			compareDate	= todayDate.substring(0, 4) + todayDate.substring(5, 7) + todayDate.substring(8, 10);
			
			// 구매테이블에서 가장 큰 구매번호를 가져온다.
			sql		= "SELECT MAX(buy_id) FROM buy";
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			rs.next();
			//구매 내역이 한 건이라도 있는 경우
			if(rs.getLong(1) > 0) 
			{
				Long	maxNum	= new Long(rs.getLong(1));
				maxDate			= maxNum.toString().substring(0, 8); // yyyymmdd만 잘라낸다.
				number			= maxNum.toString().substring(8);	 // 년월일(8) 뒤의 일련번호를 잘라낸다.
				
				// 오늘날짜로 구매한 이력이 한 건이라도 있다면
				if(compareDate.equals(maxDate)) 
				{ 
					// maxDate 뒤에 number+1을 붙여서 buyID를 만든다.
					// buyID = Long.parseLong(maxDate + Integer.parseInt(number)+1));
					
					// String.format("%5d", 표현될 대상);
					// %(명령의 시작을 의미), 0(채워질 문자), 5(총 자리수), d(십진수로 된 정수)
					buyID = Long.parseLong(maxDate + (String.format("%05d", Integer.parseInt(number)+1)));
				} else { //오늘날짜로 구매한 이력이 한 건도 없다는 것은
					// 오늘날짜로 처음 구매가 생겼다는 것이다.
					// 오늘날짜와 구매테이블에 있는 제일 큰 날짜와 비교해서 날짜가 틀리면
					// 오늘날짜 뒤에 00001을 붙여서  buyID를 만든다.
					buyID = Long.parseLong(compareDate + (String.format("%05d", 1))); 
				}
				
			} else { // 구매 테이블에 데이터가 한 건도 없는 경우
				// 구매 테이블에 처음으로 데이터가 기록되는 경우
				// compareDate += "00001"; => 2021092700001
				// buyID = Long.parseLong(compareDate);
				buyID = Long.parseLong(compareDate + (String.format("%05d", 1)));
			}
			
			//-----------------------------------------------------------------------------------------------------------
			// Transaction 시작
			// MySQL은 AutoCommit이 기본ㅁ이므로, Transaction을 사용하기 위해서는 AutoCommit을 수동으로 설정한다.
			// Book Table(update : 재고 감소), Buy Table(insert : 구매이력 생성), Cart Table(delete : 장바구니 비우기)
			//-----------------------------------------------------------------------------------------------------------
			conn.setAutoCommit(false);
			
			sql	= "";
			
			// 장바구니의 수량만큼 buy 테이블에 입력작업을 반복한다.
			for(int i = 0; i < lists.size(); i++)
			{
				// 장바구니에서 한 건씩 추출하여 작업한다.
				CartDTO	cartDTO	= lists.get(i);
				System.out.println("cartDTO => " + cartDTO);
				
				
				System.out.println("buyId  => " 					+ buyID);
				System.out.println("id  => " 						+ userID);
				System.out.println("cartDTO.getBook_id()  => " 		+ cartDTO.getBook_id());
				System.out.println("cartDTO.getBook_title()  => " 	+ cartDTO.getBook_title());
				System.out.println("cartDTO.getBuy_price()  => " 	+ cartDTO.getBuy_price());
				
				System.out.println("cartDTO.getBuy_count()  => " 	+ cartDTO.getBuy_count());
				System.out.println("cartDTO.getBook_image()  => " 	+ cartDTO.getBook_image());
				System.out.println("reg_date  => " 					+ reg_date);
				System.out.println("account  => " 					+ account);
				System.out.println("deliveryName  => " 				+ deliveryName);
				
				System.out.println("deliveryTel  => " 				+ deliveryTel);
				System.out.println("deliveryAddress  => " 			+ deliveryAddress);

				
				// 추출한 장바구니에 담겨있는 자료만큼  buy테이블에 데이터를 추가한다.
				sql		 = "INSERT INTO buy ";
				sql		+= "(buy_id, buyer, book_id, book_title, buy_price, buy_count, book_image, ";
				sql		+= "buy_date, account, deliveryName, deliveryTel, deliveryAddress) ";
				sql		+=	"VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?)";
				
				System.out.println("Buy Table Insert : " + sql);
				pstmt	= conn.prepareStatement(sql);
				
				pstmt.setLong		( 1, buyID);
				pstmt.setString		( 2, userID);
				pstmt.setInt		( 3, cartDTO.getBook_id());
				pstmt.setString		( 4, cartDTO.getBook_title());
				pstmt.setInt		( 5, cartDTO.getBuy_price());
				
				pstmt.setInt		( 6, cartDTO.getBuy_count());
				pstmt.setString		( 7, cartDTO.getBook_image());
				pstmt.setTimestamp	( 8, reg_date);
				pstmt.setString		( 9, account);
				pstmt.setString		(10, deliveryName);
				
				pstmt.setString		(11, deliveryTel);
				pstmt.setString		(12, deliveryAddress);
				pstmt.executeUpdate();
				
				System.out.println("Buy Table Insert : " + pstmt);
				
				pstmt.clearParameters();
				pstmt.close();
				
				// 장바구니에 있는 상품을 구매하였으므로
				// book 테이블에 있는 상품의 수량을 감소시킨다.
				
				// 먼저 book 테이블에서 장바구니에 담겨있는 책의 아이디와 같은 책의 재고수량을 추출한다.
				sql		 = "";
				sql		+= "SELECT book_count FROM book WHERE book_id = ?";
				pstmt	= conn.prepareStatement(sql);
				pstmt.setInt(1, cartDTO.getBook_id());

				System.out.println("Book Table Select : " + pstmt);
				
				rs		= pstmt.executeQuery();
				rs.next();
				
				// 재고수량 - 구매수량으로 책의 재고수량을  변경시키기 위해서 사용한다.
				nowCount	= (short)(rs.getShort(1) - cartDTO.getBuy_count());
				
				sql		= "";
				sql		= "UPDATE book SET book_count = ? WHERE  book_id = ?";
				pstmt	= conn.prepareStatement(sql);
				pstmt.setShort	(1, nowCount);
				pstmt.setInt	(2, cartDTO.getBook_id());
				
				System.out.println("Book Table Update : " + pstmt);
				
				pstmt.executeUpdate();
				pstmt.clearParameters();
				
			} // End - 장바구니의 수량만큼 buy 테이블에 입력작업을 반복한다.
			
			// 장바구니에 있는 책들에 대한 계산이 모두 끝났으므로 구매자가 가지고 있는 바구니를 반납한다.
			sql		= "";
			sql		= "DELETE From cart WHERE buyer = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, userID);

			System.out.println("Cart Table Delete : " + pstmt);
			
			pstmt.executeUpdate();
			pstmt.clearParameters();
			
			//-----------------------------------------------------------------------------------------------------------
			// 모든 테이블에 대한 작업이 끝나면 commit()을 실행한다.
			//-----------------------------------------------------------------------------------------------------------
			conn.commit();
			conn.setAutoCommit(true); // 모든 작업이 끝났으므로 AutoCommit을 활성화 시킨다.
			//-----------------------------------------------------------------------------------------------------------
			// Transaction 종료
			//-----------------------------------------------------------------------------------------------------------

		} catch (SQLException sqle) {
			// Transaction에 문제가 생기면 rollback한다.
			if(conn != null) {
				try {
					sqle.printStackTrace();
					System.out.println("insertBuy SQLException 발생.....");
					conn.rollback(); // 터이블의 데이터를 트랜잭션 이전으로 돌려놓는다. 
				} catch (SQLException sqle2) {
					sqle2.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}

	} // End - public void insertBuy(.......)
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매자 아이디에 해당하는 구매데이터의 건수를 알아내는 메서드 
	//-----------------------------------------------------------------------------------------------------------
	public int getListCount(String buyID) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					returnCount	= 0;
		
		try {
			sql		= "SELECT COUNT(*)w FROM buy WHERE buyer = ?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyID);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				returnCount	= rs.getInt(1);
			} else {
				returnCount	= 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnCount;
		
	} // End - public int getListCount(String buyID)
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매자 아이디에 해당하는 구매정보를 모두 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public List<BuyDTO> getBuyLists(String buyer) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BuyDTO>		lists		= null;
		BuyDTO				buyDTO		= null;

		try {
			sql		= "SELECT * FROM buy WHERE buyer = ? ORDER BY buy_id";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			
			System.out.println("getBuyLists(String buyer) => " + pstmt);
			rs		= pstmt.executeQuery();
			
			lists	= new ArrayList<BuyDTO>();
			
			while(rs.next()) {
				buyDTO	= new BuyDTO();
				/*
				System.out.println(rs.getLong		("buy_id"));
				System.out.println(rs.getInt		("book_id"));
				System.out.println(rs.getString		("book_title"));
				System.out.println(rs.getInt		("buy_price"));
				System.out.println(rs.getByte		("buy_count"));
				System.out.println(rs.getString		("book_image"));
				System.out.println(rs.getString		("sanction"));
				*/
				buyDTO.setBuy_id		(rs.getLong		("buy_id"));
				buyDTO.setBook_id		(rs.getInt		("book_id"));
				buyDTO.setBook_title	(rs.getString	("book_title"));
				buyDTO.setBuy_price		(rs.getInt		("buy_price"));
				buyDTO.setBuy_count		(rs.getByte		("buy_count"));
				buyDTO.setBook_image	(rs.getString	("book_image"));
				buyDTO.setSanction		(rs.getString	("sanction"));
				System.out.println("getBuyLists(String buyer) buyDTO => " + buyDTO);
				
				lists.add(buyDTO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return lists;
	}
	
	//-----------------------------------------------------------------------------------------------------------
	// 입력받은 년도에 해당하는 월별판매수량(12건)과 총수량(1건)을 추출하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public BuyMonthDTO buyMonth(String year) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		BuyMonthDTO			buyMonthDTO	= null;
		
		System.out.println("buyMonth(String year) Start....");
		
		try {
			sql	 = "SELECT ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '01' THEN buy_count END), 0) AS 'm01', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '02' THEN buy_count END), 0) AS 'm02', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '03' THEN buy_count END), 0) AS 'm03', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '04' THEN buy_count END), 0) AS 'm04', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '05' THEN buy_count END), 0) AS 'm05', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '06' THEN buy_count END), 0) AS 'm06', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '07' THEN buy_count END), 0) AS 'm07', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '08' THEN buy_count END), 0) AS 'm08', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '09' THEN buy_count END), 0) AS 'm09', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '10' THEN buy_count END), 0) AS 'm10', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '11' THEN buy_count END), 0) AS 'm11', ";
			sql	+= "IFNULL(SUM(case  DATE_FORMAT(buy_date, '%m') WHEN '12' THEN buy_count END), 0) AS 'm12', ";
			sql	+= "IFNULL(SUM(buy_count), 0) AS  'tot' ";
			sql	+= "FROM buy ";
			sql	+= "WHERE DATE_FORMAT(buy_date, '%Y') = ?";
			
			System.out.println("buyMonth(String year) ==> " + sql);
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, year);
			
			System.out.println("buyMonth(String year) ==> " + pstmt);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				buyMonthDTO	= new BuyMonthDTO();
				
				// buyMonthDTO 에 select한 값들을 저장한다.
				buyMonthDTO.setMonth01	(rs.getInt("m01"));
				buyMonthDTO.setMonth02	(rs.getInt("m02"));
				buyMonthDTO.setMonth03	(rs.getInt("m03"));
				buyMonthDTO.setMonth04	(rs.getInt("m04"));
				buyMonthDTO.setMonth05	(rs.getInt("m05"));

				buyMonthDTO.setMonth06	(rs.getInt("m06"));
				buyMonthDTO.setMonth07	(rs.getInt("m07"));
				buyMonthDTO.setMonth08	(rs.getInt("m08"));
				buyMonthDTO.setMonth09	(rs.getInt("m09"));
				buyMonthDTO.setMonth10	(rs.getInt("m10"));

				buyMonthDTO.setMonth11	(rs.getInt("m11"));
				buyMonthDTO.setMonth12	(rs.getInt("m12"));
				buyMonthDTO.setTotal	(rs.getInt("tot"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return buyMonthDTO;
		
	} // End - public BuyMonthDTO buyMonth(String year)
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매(판매) 테이블의 전체 레코드 건수를 추출하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int getListCount() throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					returnCount	= 0;

		try {
			sql		= "SELECT COUNT(*) FROM buy";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				returnCount	= rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnCount;
		
	} // End - public int getListCount()
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매 (판매체이블에 있는 모든 자료를 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public List<BuyDTO> getBuyList() throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BuyDTO>		lists		= null;
		BuyDTO				buyDTO		= null;		

		try {
			sql		= "SELECT * FROM buy";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			lists	= new ArrayList<BuyDTO>();
			
			while(rs.next()) {
				buyDTO = new BuyDTO();
				
				buyDTO.setBuy_id			(rs.getLong		("buy_id"));
				buyDTO.setBuyer				(rs.getString	("buyer"));
				buyDTO.setBook_id			(rs.getInt		("book_id"));
				buyDTO.setBook_title		(rs.getString	("book_title"));
				buyDTO.setBuy_price			(rs.getInt		("buy_price"));
				
				buyDTO.setBuy_count			(rs.getByte		("buy_count"));
				buyDTO.setBook_image		(rs.getString	("book_image"));
				buyDTO.setBuy_date			(rs.getTimestamp("buy_date"));
				buyDTO.setAccount			(rs.getString	("account"));
				
				buyDTO.setDeliveryName		(rs.getString	("deliveryName"));
				buyDTO.setDeliveryTel		(rs.getString	("deliveryTel"));
				buyDTO.setDeliveryAddress	(rs.getString	("deliveryAddress"));
				buyDTO.setSanction			(rs.getString	("sanction"));
				
				lists.add(buyDTO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return lists;
		
	} // End - public List<BuyDTO> getBuyList()
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매 아이디에 해당하는 배송상태 값을 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public int getDeliveryStatus(String buyId) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				status		= ""; 	// 찾아온 상태 값을 저장할 변수
		int					returnVal	= 0;	// 찾아온 상태 값을 숫자로 표현할 변수
		
		try {
			// buy_id에 해당하는 sanction값을 찾아낸다.
			sql		= "SELECT sanction FROM buy WHERE buy_id = ?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(buyId));
			rs		= pstmt.executeQuery();
			
			// sanction 값에 따라 returnVal값을 다르게 저장한다.
			if(rs.next()) {
				// 상품준비중 => 1,  배송중=> 2, 배송완료 => 3
				status = rs.getString("sanction");
				if(status.equals("상품준비중")) {
					returnVal = 1;
				} else if(status.equals("배송중")) {
					returnVal = 2;
				} else if(status.equals("배송완료")) {
					returnVal = 3;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnVal;
		
	} // End - public int getDeliveryStatus(String buyId)
	
	//-----------------------------------------------------------------------------------------------------------
	// 구매 아이디에 해당하는 배송상태를 변경하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public void updateSanction(String buyId, String status) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		String				sanction	= "";
		
		if(Integer.parseInt(status) == 1) {
			sanction = "상품준비중";
		} else if(Integer.parseInt(status) == 2) {
			sanction = "배송중";
		} else if(Integer.parseInt(status) == 3) {
			sanction = "배송완료";
		}
		
		try {
			sql		= "UPDATE buy SET sanction = ? WHERE buy_id = ?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString	(1, sanction);
			pstmt.setLong	(2, Long.parseLong(buyId));
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void updateSanction(String buyId, String status)
	
	
	
} // End - public class BuyDAO










