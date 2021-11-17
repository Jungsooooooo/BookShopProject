package bookshop.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-------------------------------------------------------------------------------------------------
// public class CartDAO
//-------------------------------------------------------------------------------------------------
public class CartDAO {

	//-----------------------------------------------------------------------------------------------------------
	// CartDAO 인스턴스를 생성한다.
	//-----------------------------------------------------------------------------------------------------------
	private static CartDAO instance = new CartDAO();

	//-----------------------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//-----------------------------------------------------------------------------------------------------------
	public static CartDAO getInstance() {
		return instance;
	} // End - public static CartDAO getInstance()

	//-----------------------------------------------------------------------------------------------------------
	// 기본 생성자
	//-----------------------------------------------------------------------------------------------------------
	private CartDAO() {}

	//-----------------------------------------------------------------------------------------------------------
	// 커넥션 풀로부터 커넥션 객체를 얻어내는 메서드
	//-----------------------------------------------------------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context	initCtx	= new InitialContext();
		
		// initCtx의 lookup메서드를 이용해서 "java:comp/env"에 해당하는 객체를 찾아서 envCtx에 저장한다.
		Context	envCtx = (Context) initCtx.lookup("java:comp/env");
		
		// envCtx.lookup("jdbc/bookshopdb") => context.xml의 <ResourceLink>의 name에 적은 것과 동일하게 작성해야 한다.
		DataSource ds = (DataSource) envCtx.lookup("jdbc/bookshopdb");
		
		System.out.println("DataSource : " + ds);
		return ds.getConnection();
	}
	
	//-------------------------------------------------------------------------------------------------
	// 사용자와 책 아이디에 해당하는 책이 카트에 몇 권이 들어있는지 추출하는 메서드
	//-------------------------------------------------------------------------------------------------
	public byte getBookIdCount(String buyer, int bookID) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		byte				bookCount	= 0;
		
		try {
			sql		 = "SELECT SUM(buy_count) FROM cart ";
			sql		+= "WHERE buyer=? AND book_id=?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString	(1, buyer);
			pstmt.setInt	(2, bookID);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				bookCount = rs.getByte(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return bookCount;

	} // End - public byte getBookIdCount(String buyer, int bookID)
	
	//-------------------------------------------------------------------------------------------------
	// [장바구니에 담기] 버튼을 클릭하면 실행되는 메서드
	//-------------------------------------------------------------------------------------------------
	public void insertCart(CartDTO cartDTO) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";

		try {
			sql		 = "INSERT INTO cart ";
			sql		+= "(book_id, buyer, book_title, buy_price, buy_count, book_image) ";
			sql		+= "VALUES(?, ?, ?, ?, ?, ?)";
			
			System.out.println("insertCart sql ==> " + sql);
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			
			pstmt.setInt	(1, cartDTO.getBook_id());
			pstmt.setString	(2, cartDTO.getBuyer());
			pstmt.setString	(3, cartDTO.getBook_title());
			pstmt.setInt	(4, cartDTO.getBuy_price());
			pstmt.setInt	(5, cartDTO.getBuy_count());
			pstmt.setString	(6, cartDTO.getBook_image());
			
			System.out.println("insertCart pstmt ==> " + pstmt);
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void insertCart(CartDTO cartDTO)
	
	//-------------------------------------------------------------------------------------------------
	// buyer가 가지고 있는 카트의 갯수를 구하는 메서드
	//-------------------------------------------------------------------------------------------------
	public int getListCount(String buyer) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					returnCnt	= 0;
		
		try {
			sql		= "SELECT COUNT(*) FROM cart WHERE buyer = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString	(1, buyer);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				returnCnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
		return returnCnt;
		
	} // End - public int getListCount(String buyer)
	
	//-------------------------------------------------------------------------------------------------
	// 어떤 바이어가 가지고 있는 모든 카트의 정보를 추출하는 메서드
	//-------------------------------------------------------------------------------------------------
	public List<CartDTO> getCarts(String buyer) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		CartDTO				cartDTO		= null;
		List<CartDTO>		cartLists	= null;

		try {
			sql		= "SELECT * FROM cart WHERE buyer = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			rs		= pstmt.executeQuery();
			
			cartLists 	= new ArrayList<CartDTO>();
			
			// 찾아온 데이터를 읽어들일 수 있을때까지 반복 작업한다.
			while(rs.next()) {
				cartDTO	= new CartDTO();
				
				cartDTO.setCart_id		(rs.getInt("cart_id"));
				cartDTO.setBuyer		(rs.getString("buyer"));
				cartDTO.setBook_id		(rs.getInt("book_id"));
				cartDTO.setBook_title	(rs.getString("book_title"));
				cartDTO.setBuy_price	(rs.getInt("buy_price"));
				cartDTO.setBuy_count	(rs.getByte("buy_count"));
				cartDTO.setBook_image	(rs.getString("book_image"));
				
				cartLists.add(cartDTO);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
		return cartLists;
		
	} // End - public List<CartDTO> getCarts(String buyer)
		
	//-------------------------------------------------------------------------------------------------
	// 카트 아이디에 해당하는 장바구니 비우기
	//-------------------------------------------------------------------------------------------------
	public void deleteCart(int cart_id) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";

		try {
			sql		= "DELETE FROM cart WHERE cart_id = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, cart_id);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void deleteCart(int cart_id)
	
	//-------------------------------------------------------------------------------------------------
	// 구매자 아이디에 해당하는 모든 장바구니를 비우기(삭제하기)
	//-------------------------------------------------------------------------------------------------
	public void deleteAllCart(String buyer) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";

		try {
			sql		= "DELETE FROM cart WHERE buyer = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			int deleteCount = pstmt.executeUpdate();
			
			if(deleteCount > 0) {
				System.out. println(deleteCount + "개의 바구니를 비웠습니다.");
			} else {
				System.out.println("바구니를 비우는데 장애가 발생하였습니다.");
				System.out.println("바구니를 비우지 못했습니다.");
			}
		} catch (NullPointerException ex) {
			ex.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void deleteAllCart(String buyer)
	
	//-------------------------------------------------------------------------------------------------
	// 장바구니의 수량을 변경하는 메서드
	//-------------------------------------------------------------------------------------------------
	public void updateBuyCount(int cart_id, byte count) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";

		try {
			sql		= "UPDATE cart SET buy_count = ? WHERE cart_id = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setByte	(1, count);
			pstmt.setInt	(2, cart_id);
			pstmt.executeUpdate();
			
		} catch (NullPointerException ex) {
			ex.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void updateBuyCount(int cart_id, byte count)

	//-------------------------------------------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------

} // End - public class CartDAO













