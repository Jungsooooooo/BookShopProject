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
// public class MemberDAO (Data Access Object)
//-------------------------------------------------------------------------------------------------
public class MemberDAO {
	
	//-------------------------------------------------------------------------------------------------
	// MemberDAO Instance를 생성한다.
	//-------------------------------------------------------------------------------------------------
	private static MemberDAO instance = new MemberDAO();

	//-------------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//-------------------------------------------------------------------------------------------------
	public static MemberDAO getInstance() {
		return instance;
	} // End - public static MemberDAO getInstance()
	
	//-------------------------------------------------------------------------------------------------
	// 기본 생성자
	//-------------------------------------------------------------------------------------------------
	private MemberDAO() {}
	
	//-------------------------------------------------------------------------------------------------
	// 커넥션 풀로부터 커넥션 객체를 얻어내는 메서드
	//-------------------------------------------------------------------------------------------------
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
	// 아이디의 값이 회원테이블에 존재하는지 검사하는 메서드
	//-------------------------------------------------------------------------------------------------
	public int confirmId(String id) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					returnVal	= -1;
		
		try {
			sql		= "SELECT id FROM member WHERE id=?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) { // id에 해당하는 데이터가 있으면 1을 돌려주고,
				returnVal = 1;
			} else {		// 아니면 -1을 돌려준다.
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
	} // End - public int confirmId(String id)

	//-------------------------------------------------------------------------------------------------
	// 회원 가입 메서드
	//-------------------------------------------------------------------------------------------------
	public int insertMember(MemberDTO member) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		int					returnVal	= -1;
		
		try {
			sql		= "INSERT INTO member VALUES (?, ?, ?, ?, ?, ?)";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString		(1, member.getId());
			pstmt.setString		(2, member.getPasswd());
			pstmt.setString		(3, member.getName());
			pstmt.setTimestamp	(4, member.getReg_date());
			pstmt.setString		(5, member.getTel());
			pstmt.setString		(6, member.getAddress());
			
			returnVal = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnVal;

	} // End - public int insertMember(MemberDTO member)

	//-------------------------------------------------------------------------------------------------
	// 회원 인증 검사
	//-------------------------------------------------------------------------------------------------
	public int memberCheck(String id, String passwd) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				dbPasswd	= "";
		int					returnVal	= -1;
		
		System.out.println("memberCheck String id, String passwd ==> " + id + passwd);
		try {
			sql		= "SELECT passwd FROM member WHERE id=?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs		= pstmt.executeQuery();
			System.out.println("memberCheck pstmt ==> " + pstmt);
			
			if(rs.next()) { // id에 해당하는 회원이 존재하면
				// 찾아온 비밀번호와 전페이지에서 넘겨준 비밀번호를 비교한다.
				dbPasswd = rs.getString("passwd"); // rs.getString(1);
				
				if(dbPasswd.equals(passwd)) { // 비밀번호가 맞으면
					returnVal = 1; // 인증성공, 아이디와 비밀번호가 모두 맞은 경우
				} else { // 비밀번호가 틀리면
					returnVal = 0; // 아이디는 맞으나 비밀번호가 틀린 경우
				}
			} else { // id에 해당하는 회원이 존재하지 않으면
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
	} // End - public int memberCheck(String id, String passwd)

	//-------------------------------------------------------------------------------------------------
	// 회원 아이디에 해당하는 모든 정보를 추출하는 메서드
	//-------------------------------------------------------------------------------------------------
	public MemberDTO getMember(String userID) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		MemberDTO			memberDTO	= null;
		
		try {
			sql		= "SELECT * FROM member WHERE id  = ?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs		= pstmt.executeQuery();
			
			System.out.println("getMember ==> " + pstmt);
			
			if(rs.next()) {
				// 검색한 결과를 getMember() 메서드를 호출한 곳에 넘겨줄 준비를 한다.
				memberDTO	= new MemberDTO();
				
				memberDTO.setId			(rs.getString("id"));
				memberDTO.setPasswd		(rs.getString(2));
				memberDTO.setName		(rs.getString("name"));
				memberDTO.setReg_date	(rs.getTimestamp("reg_date"));
				memberDTO.setTel		(rs.getString(5));
				memberDTO.setAddress	(rs.getString("address"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return memberDTO;
		
	} // End - public MemberDTO getMember(String userID)

	//-------------------------------------------------------------------------------------------------
	// 조건(1:이름, 2:가입일자, 3:주소)에 따른 회원 수를 추출한다. 
	//-------------------------------------------------------------------------------------------------
	public int getMemberCount(String mode, String modeVal) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					returnCount	= 0;
		
		try {
			//------------------------------------------------------------------------------------------
			// 비교에 if(mode == "1")를 사용하지 말 것. 비교가 되지 않는다.
			// LIKE 이후 부분이 mode 1,2,3에 공통으로 해당되지만 별도로 묶지 않은 것은
			// mode가 1,2,3 이외의 값이 넘어올 때 문법적으로 문제가 생기므로 공통으로 묶지 않은 것이다.
			// 문법오류가 발생하기 때문에 => "SELECT COUNT(*) FROM member LIKE '%" + modeVal + "%'"; 문법오류가 발생하기 때문에.
			//------------------------------------------------------------------------------------------
			sql		= "SELECT COUNT(*) as totalCount FROM member ";
				 if(mode.equals("1"))	sql += "WHERE name		LIKE '%" + modeVal + "%'";
			else if(mode.equals("2"))	sql += "WHERE reg_date	LIKE '%" + modeVal + "%'";
			else if(mode.equals("3"))	sql += "WHERE address	LIKE '%" + modeVal + "%'";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			// 찾은 데이터(건수)를 리턴할 변수에 저장한다.
			if(rs.next()) {
				// returnCount = rs.getInt("totalCount"); // <= COUNT(*)
				returnCount = rs.getInt(1); // <= COUNT(*)
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return returnCount;
		
	} // End - public int getMemberCount(String mode, String modeVal)
	
	//-------------------------------------------------------------------------------------------------
	// 조건에 따라 회원정보들을 추출한다.
	// 보여줄 데이터가 있으면 조건에 맞는 데이터만 찾아오는데 현재 페이지에 보여줄 만큼만 가져온다.
	//-------------------------------------------------------------------------------------------------
	public List<MemberDTO> getMembers(String mode, String modeVal, int start, int pageSize) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<MemberDTO>		memberList	= null;

		System.out.println("getMembers => " + mode + ":" + modeVal + ":" + start + ":" + pageSize);
		try {
			sql		= "SELECT * FROM member ";
				 if(mode.equals("1"))	sql += "WHERE name		LIKE '%" + modeVal + "%' ORDER BY name		LIMIT ?,?";
			else if(mode.equals("2"))	sql += "WHERE reg_date	LIKE '%" + modeVal + "%' ORDER BY reg_date	LIMIT ?,?";
			else if(mode.equals("3"))	sql += "WHERE address	LIKE '%" + modeVal + "%' ORDER BY address	LIMIT ?,?";
			else						sql += "ORDER BY name LIMIT ?,?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			// LIMIT 2, 5 : row 2번 부터 5개 => LIMIT의 시작은 0부터 시작되므로 1을 빼서 추출한다.(페이지는 1부터 시작하므로)
			pstmt.setInt(1,	start-1);
			pstmt.setInt(2, pageSize);
			System.out.println("getMembers() ==> " + pstmt);

			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				memberList	= new ArrayList<MemberDTO>(pageSize);
				do {
					MemberDTO	memberDTO	= new MemberDTO();
					//-----------------------------------------------------------------------------
					// rs에서 번호를 사용하는 순서는 SELECT 에서 나오는 column의 순서와 같다.
					//-----------------------------------------------------------------------------
					memberDTO.setId			(rs.getString("id"));
					memberDTO.setPasswd		(rs.getString(2));	// rs.getString("passwd")와 같다.
					memberDTO.setName		(rs.getString("name"));
					memberDTO.setReg_date	(rs.getTimestamp("reg_date"));
					memberDTO.setTel		(rs.getString(5));	// rs.getString("tel")과 같다. 
					memberDTO.setAddress	(rs.getString("address"));
					
					memberList.add(memberDTO);
				} while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs   	!= null)	try { rs.close();		} catch (SQLException se) {}
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
		return memberList;
		
	} // End - public List<MemberDTO> getMembers(String mode, String modeVal, int start, int pageSize)
	
	//-------------------------------------------------------------------------------------------------
	// 회원 정보 수정
	//-------------------------------------------------------------------------------------------------
	public void updateMember(MemberDTO member) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";

		try {
			sql		 = "UPDATE member ";
			sql		+= "SET passwd=?, name=?, tel=?, address=? ";
			sql		+= "WHERE id=?";
			
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, member.getPasswd());
			pstmt.setString(2, member.getName());
			pstmt.setString(3, member.getTel());
			pstmt.setString(4, member.getAddress());
			pstmt.setString(5, member.getId());
			
			System.out.println("updateMember => " + pstmt);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt	!= null)	try { pstmt.close();	} catch (SQLException se) {}
			if(conn	  	!= null)	try { conn.close();		} catch (SQLException se) {}
		}
	} // End - public void updateMember(MemberDTO member)
	
	//-------------------------------------------------------------------------------------------------
	// 회원 정보 삭제
	//-------------------------------------------------------------------------------------------------
	public int deleteMember(String id,  String passwd) throws Exception {
		
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				dbPasswd	= "";
		int					returnVal 	= -1;
		
		try {
			// id에 해당하는 비밀번호를 가져와서 값을 비교한 후 처리를 다르게 한다.
			sql		= "SELECT passwd FROM member WHERE id = ?";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs		= pstmt.executeQuery();
			
			if(rs.next() ) {
				dbPasswd	= rs.getString("passwd");
				if(dbPasswd.equals(passwd)) { // 데이터의 비밀번호와 넘겨받은 비밀번호 값이 같으면
					sql		= "";
					sql		= "DELETE FROM member WHERE id = ?";
					pstmt.close();
					pstmt	= conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.executeUpdate();
					returnVal = 1;
				} else { // 데이터의 비밀번호와 넘겨받은 비밀번호 값이 같지 않으면
					returnVal = 0;
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
		
	} // End - public void updateMember(MemberDTO member)
	

} // End - public class MemberDAO














