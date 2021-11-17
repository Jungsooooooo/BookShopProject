package db;


import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-----------------------------------------------------------------------------------------------------------
// public class BookDAO
//-----------------------------------------------------------------------------------------------------------
public class DBConnection {

	//-----------------------------------------------------------------------------------------------------------
	// 커넥션 풀로부터 커넥션 객체를 얻어내는 메서드
	//-----------------------------------------------------------------------------------------------------------
	public Connection getConnection() throws Exception {
		Context	initCtx	= new InitialContext();
		
		// initCtx의 lookup메서드를 이용해서 "java:comp/env"에 해당하는 객체를 찾아서 envCtx에 저장한다.
		Context	envCtx = (Context) initCtx.lookup("java:comp/env");
		
		// envCtx.lookup("jdbc/bookshopdb") => context.xml의 <ResourceLink>의 name에 적은 것과 동일하게 작성해야 한다.
		DataSource ds = (DataSource) envCtx.lookup("jdbc/bookshopdb");
		
		Connection conn = ds.getConnection();
		
		return conn;
	}
	

	
} // End - public class BookDAO















