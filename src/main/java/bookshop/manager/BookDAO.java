package bookshop.manager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-----------------------------------------------------------------------------------------------------------
// public class BookDAO
// executeQuery()	: SELECT 문장을 실행하라.
// executeUpdate()	: INSERT, UPDATE, DELETE 문장을 실행하라.
//-----------------------------------------------------------------------------------------------------------
public class BookDAO {

	//-----------------------------------------------------------------------------------------------------------
	// BookDAO 인스턴스를 생성한다.
	//-----------------------------------------------------------------------------------------------------------
	private static BookDAO instance = new BookDAO();

	//-----------------------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//-----------------------------------------------------------------------------------------------------------
	public static BookDAO getInstance() {
		return instance;
	} // End - public static BookDAO getInstance()

	//-----------------------------------------------------------------------------------------------------------
	// 기본 생성자
	//-----------------------------------------------------------------------------------------------------------
	private BookDAO() {}

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
	
	//-----------------------------------------------------------------------------------------------------------
	// 관리자 인증 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int managerCheck(String id, String passwd) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				dbPasswd	= "";
		int					returnVal	= -1;
		
		try {
			// 커넥션 풀로부터 접속 정보를 가져온다.
			conn = getConnection();
			
			sql 	= "SELECT managerPasswd FROM manager WHERE managerId = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, id); 		// 쿼리 문장에서 빠진부분(?)에 해당되는 것을 준비한다.
			rs		= pstmt.executeQuery();	// select를 실행하라고 한다.
			
			// select한 결과에 대해서 처리를 한다.
			if(rs.next()) {	// id에 해당하는 자료가 있다면
				// 찾은 비밀번호를 가지고, 입력한 비밀번호와 비교한다.
				dbPasswd = rs.getString("managerPasswd");
				
				if(dbPasswd.equals(passwd)) { // 비밀번호가 일치한다면
					returnVal = 1; // 인증성공
				} else { // 비밀번화가 같지 않다면
					returnVal = 0; // 인증실패
				}
			} else { // id에 해당하는 자료가 없다면
				returnVal = -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnVal;
	} // End - public int managerCheck(String id, String passwd) throws Exception
	
	//-----------------------------------------------------------------------------------------------------------
	// 책의 종류 데이터를 모두 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public List<BookTypeDTO> getBookTypes() throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BookTypeDTO>	bookTypes	= null;

		try {
			conn	= getConnection();
			
			sql		= "SELECT * FROM booktype ORDER BY id";
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			System.out.println("getBookTypes() 실행 ===> ");
			System.out.println("sql : " + sql);
			System.out.println("pstmt : " + pstmt);
			
			// 찾아온 책의 타입에 대한 모든 정보를 넘겨줄 변수에 저장한다.
			if(rs.next()) { // 검색결과 찾아온 데이터가 한건이라도 있다면
				bookTypes = new ArrayList<BookTypeDTO>();
				do {
					BookTypeDTO bookType = new BookTypeDTO();
					
					bookType.setId	(rs.getString("id"));
					bookType.setName(rs.getString("name"));
					
					bookTypes.add(bookType);
				} while(rs.next());
			}
			/* 위의 if문과 같은 내용이다.
			bookTypes = new ArrayList<BookTypeDTO>();
			while(rs.next()) {
				BookTypeDTO bookType = new BookTypeDTO();
				bookType.setId	(rs.getString("id"));
				bookType.setName(rs.getString("name"));
				bookTypes.add(bookType);
			}
			*/
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return bookTypes;
	} // End - public List<BookTypeDTO> getBookTypes()
	
	//-----------------------------------------------------------------------------------------------------------
	// 책을 등록하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int insertBook(BookDTO book, int imageStatus) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		
		try {
			System.out.println("== 입력할 데이터 ===========================================");
			System.out.println(book.getBook_id());
			System.out.println(book.getBook_kind());
			System.out.println(book.getBook_title());
			System.out.println(book.getBook_price());
			System.out.println(book.getBook_count());

			System.out.println(book.getAuthor());
			System.out.println(book.getPublishing_com());
			System.out.println(book.getPublishing_date());
			System.out.println(book.getBook_content());
			System.out.println(book.getDiscount_rate());

			System.out.println(book.getReg_date());
			System.out.println(book.getBook_image());


			sql	 = "INSERT INTO book ";
			sql	+= "(book_id, book_kind, book_title, book_price, book_count, ";
			sql	+= "author, publishing_com, publishing_date, book_content, ";
			sql	+= "discount_rate, reg_date ";
			
			if(imageStatus == 1) { // 책의 이미지명이 있는 경우
				sql += ", book_image) ";
				sql += "VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)";
			} else { // 책의 이미지명이 없는 경우
				sql += ") ";
				sql += "VALUES(?,?,?,?,?, ?,?,?,?,?, ?)";
			}
			
			System.out.println("Insert SQL : " + sql);
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			
			pstmt.setInt		( 1, book.getBook_id());
			pstmt.setString		( 2, book.getBook_kind());
			pstmt.setString		( 3, book.getBook_title());
			pstmt.setInt		( 4, book.getBook_price());
			pstmt.setShort		( 5, book.getBook_count());
			
			pstmt.setString		( 6, book.getAuthor());
			pstmt.setString		( 7, book.getPublishing_com());
			pstmt.setString		( 8, book.getPublishing_date());
			pstmt.setString		( 9, book.getBook_content());
			pstmt.setByte		(10, book.getDiscount_rate());
			
			pstmt.setTimestamp	(11, book.getReg_date());
			if(imageStatus == 1) {
				pstmt.setString	(12, book.getBook_image());
			}
			
			System.out.println("pstmt : " + pstmt);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return -1;
		
	} // End - public int insertBook(BookDTO book, int imageStatus)
	
	//-----------------------------------------------------------------------------------------------------------
	// 책의 종류에 따른 데이터 건수를 구하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int getBookCount(String book_kind) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql1		= "";
		String				sql2		= "";
		int					returnCount	= 0;
		
		try {
			sql1	= "SELECT COUNT(*) FROM book ";
			sql2	= "WHERE book_kind = ?";
			
			conn	= getConnection();
			
			if(book_kind.equals("all")) {
				pstmt	= conn.prepareStatement(sql1);
			} else {
				pstmt	= conn.prepareStatement(sql1 + sql2);
				pstmt.setString(1, book_kind);
			}
			
			System.out.println("질문 getBookCount() : " + pstmt);
			
			rs = pstmt.executeQuery();
			if(rs.next() ) {
				returnCount = rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnCount;
		
	} // End - public int getBookCount(String book_kind)

	//-----------------------------------------------------------------------------------------------------------
	// 책 종류에 해당하는 책들의 정보들 중에서 시작위치부터 의뢰한 건수만큼만 추출하여 돌려준다.
	//-----------------------------------------------------------------------------------------------------------
	public List<BookDTO> getBooks(String book_kind, int start, int count) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql1		= "";
		String				sql2		= "";
		String				sql3		= "";
		List<BookDTO>		bookList	= null;

		try {
			sql1	 = "SELECT ";
			sql1	+= "bk.book_id, bt.name, bk.book_title, bk.book_price, bk.book_count, ";
			sql1	+= "bk.author, bk.publishing_com, bk.publishing_date, bk.book_content, ";
			sql1	+= "bk.book_image, bk.discount_rate, bk.reg_date ";
			sql1	+= "FROM book bk, bookType bt ";
			sql1	+= "WHERE bk.book_kind = bt.id ";
			sql2	+= "AND bk.book_kind = ? ";
			sql3	+= "ORDER BY bk.reg_date DESC limit ?, ?"; // limit 인덱스번호, 건수
			
			conn	= getConnection();
			if(book_kind.equals("all")) { // 책의 종류에 상관없이 모든 책들을 대상으로 검색한다.
				pstmt	= conn.prepareStatement(sql1 + sql3);
				pstmt.setInt(1,	start-1);	// 인덱스번호는 0부터 시작하므로 start에서 1을 뺀다.
				pstmt.setInt(2, count);
			} else { // 책의 종류에 맞는 책들만 검색을 한다.
				pstmt	= conn.prepareStatement(sql1 + sql2 + sql3);
				pstmt.setString	(1, book_kind);
				pstmt.setInt	(2, start-1);
				pstmt.setInt	(3, count);
			}
			
			System.out.println("getBooks 쿼리1 : " + sql1);
			System.out.println("getBooks 쿼리2 : " + sql2);
			System.out.println("getBooks 쿼리3 : " + sql3);
			
			System.out.println("getBooks pstmt : " + pstmt);
			// 쿼리를 실행하고 추출한 결과를 가져온다.
			rs = pstmt.executeQuery();
			
			// 추출한 책들의 정보를 저장할 방을 만든다.
			bookList = new ArrayList<BookDTO>();
			
			// 추출한 책들의 정보들을 담는다.
			while(rs.next()) {
				BookDTO	bookDTO	= new BookDTO();
				System.out.println("### BOOK : Start....");

				bookDTO.setBook_id			(rs.getInt		("bk.book_id"));
				bookDTO.setBook_kind		(rs.getString	("bt.name"));
				bookDTO.setBook_title		(rs.getString	("bk.book_title"));
				bookDTO.setBook_price		(rs.getInt		("bk.book_price"));
				bookDTO.setBook_count		(rs.getShort	("bk.book_count"));
				
				bookDTO.setAuthor			(rs.getString	("bk.author"));
				bookDTO.setPublishing_com	(rs.getString	("bk.publishing_com"));
				bookDTO.setPublishing_date	(rs.getString	("bk.publishing_date"));
				bookDTO.setBook_image		(rs.getString	("bk.book_image"));
				bookDTO.setDiscount_rate	(rs.getByte		("bk.discount_rate"));
				bookDTO.setReg_date			(rs.getTimestamp("bk.reg_date"));
				
				bookList.add(bookDTO);
				System.out.println("### BOOK : " + bookDTO);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return bookList;
		
	} // End - public List<BookDTO> getBooks(String book_kind, int start, int count)

	//-----------------------------------------------------------------------------------------------------------
	// 책 아이디에 해당하는 책의 정보를 추출한다.
	//-----------------------------------------------------------------------------------------------------------
	public BookDTO getBook(int bookID) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		BookDTO				bookDTO		= null;
		
		try {
			conn	= getConnection();
			sql		= "SELECT * FROM book WHERE book_id = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, bookID);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				bookDTO	= new BookDTO();
				
				bookDTO.setBook_id			(rs.getInt		("book_id"));
				bookDTO.setBook_kind		(rs.getString	("book_kind"));
				bookDTO.setBook_title		(rs.getString	("book_title"));
				bookDTO.setBook_price		(rs.getInt		("book_price"));
				bookDTO.setBook_count		(rs.getShort	("book_count"));
				
				bookDTO.setAuthor			(rs.getString	("author"));
				bookDTO.setPublishing_com	(rs.getString	("publishing_com"));
				bookDTO.setPublishing_date	(rs.getString	("publishing_date"));
				bookDTO.setBook_image		(rs.getString	("book_image"));
				bookDTO.setBook_content		(rs.getString	("book_content"));
				bookDTO.setDiscount_rate	(rs.getByte		("discount_rate"));
				bookDTO.setReg_date			(rs.getTimestamp("reg_date"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return bookDTO;
	} // End - public BookDTO getBook(int bookID)
	
	//-----------------------------------------------------------------------------------------------------------
	// 책의 아이디에 해당하는 정보를 수정하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int updateBook(BookDTO book, int bookID, int imageStatus) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		
		try {
			// 책의 아이디에 해당하는 정보를 수정한다.
			// 이미지 파일의 값이 null로 넘어오면 이미지파일은 빼고 업데이트한다.
			sql	 = "UPDATE book SET ";
			sql	+= "book_kind=?,	book_title=?,		book_price=?,	book_count=?,	";
			sql	+= "author=?,		publishing_com=?,	publishing_date=?,	";
			sql	+= "book_content=?,	discount_rate=?	";
			if(imageStatus == 1) {	// 업데이트할 이미지 파일이 있으면
				sql += ", book_image=?	";
			}
			sql	+= "WHERE book_id=?";
			
			conn	= getConnection();				// 커넥션 풀의 연결정보를 가져온다.
			pstmt	= conn.prepareStatement(sql);	// DB에 질문할 준비를 한다.
			
			pstmt.setString		( 1, book.getBook_kind());
			pstmt.setString		( 2, book.getBook_title());
			pstmt.setInt		( 3, book.getBook_price());
			pstmt.setShort		( 4, book.getBook_count());
			pstmt.setString		( 5, book.getAuthor());
			
			pstmt.setString		( 6, book.getPublishing_com());
			pstmt.setString		( 7, book.getPublishing_date());
			pstmt.setString		( 8, book.getBook_content());
			pstmt.setByte		( 9, book.getDiscount_rate());
			
			if(imageStatus == 0) { // 업데이트할 이미지 파일이 없으면
				pstmt.setInt	(10, bookID);
			} else { // 업데이트할 이미지 파일이 있으면
				pstmt.setString	(10, book.getBook_image());
				pstmt.setInt	(11, bookID);
			}
			
			System.out.println("책 정보 업데이트 : " + pstmt);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return -1;
		
	} // End - public int updateBook(BookDTO book, int bookID, int imageStatus)

	//-----------------------------------------------------------------------------------------------------------
	// 책의 아이디에 해당하는 정보를 삭제한다.
	//-----------------------------------------------------------------------------------------------------------
	public void deleteBook(int bookID) throws Exception {
				
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		
		try {
			sql		= "DELETE FROM book WHERE book_id=?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, bookID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		
	} // End - public void deleteBook(int bookID)

	//-----------------------------------------------------------------------------------------------------------
	// 책의 아이디에 해당하는 재고수량을 추출하는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public int getBookIdCount(int bookID) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					bookCount	= 0;
		
		try {
			sql		= "SELECT book_count FROM book WHERE book_id=?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, bookID);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				bookCount = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return bookCount;
	} // End - public int getBookIdCount(int bookID)
	
	
} // End - public class BookDAO















