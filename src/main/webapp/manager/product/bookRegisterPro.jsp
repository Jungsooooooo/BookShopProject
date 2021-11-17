<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.manager.BookDTO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
request.setCharacterEncoding("utf-8");

MultipartRequest	imageUp	= null;

String	realFolder	= "";			// 웹 어플리케이션 상의 절대경로
String	fileName	= "";			// 파일이름을 저장할 변수
String	saveFolder	= "/imageFile";	// 파일이 업로드 되는 폴더
String	encType		= "utf-8";		// 인코딩 타입
int		maxSize		= 10*1024*1024;	// 업로드할 파일의 최대 크기 => 10MB

// 현재 jsp페이지의 웹 어플리케이션 상의 절대경로를 구한다.
ServletContext	context = getServletContext();
realFolder	= context.getRealPath(saveFolder);

try {
	// 전송을 담당할 컴포넌트를 생성하고 파일을 전송한다.
	// 전송할 파일명을 가지고 있는 객체, 서버상의 절대경로, 업로드될 파일의 최대크기, 문자코드, 기본 보안 적용
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	imageUp = new MultipartRequest(request, realFolder, maxSize, encType, policy);
	
	// 전송할 파일의 정보를 가져온다.
	Enumeration<?> files = imageUp.getFileNames();
	
	// 파일의 정보가 있다면
	while(files.hasMoreElements()) {
		// input 태그의 속성이 file인 태그의 name속성 값 : 파라미터 이름
		String name = (String)files.nextElement();
		
		// 서버에 저장된 파일이름
		fileName = imageUp.getFilesystemName(name);
		System.out.println("서버에 저장된 파일 이름 : " + fileName);
	}
	
} catch (Exception e) {
	e.printStackTrace();
}

// BookDTO book = new BookDTO(); <= 이부분을 표준액션으로 사용하면 아래와 같다.
%>
<jsp:useBean id="book" scope="page" class="bookshop.manager.BookDTO"></jsp:useBean>
<%
// 이미지 명의 값이 null인 경우를 처리하기 위해서 추가
// DAO에서 Insert하는 개수가 틀려지기 때문에
int imageStatus = 0;
if(fileName == null || fileName.equals("")) {
	imageStatus = 0; // 이미지명의 값이 null로 넘어온 경우(이미지를 선택하지 않은 경우)
} else {
	imageStatus = 1; // 이미지명의 값이 들어온 경우(이미지를 선택한 경우)
}

System.out.println(imageUp.getParameter("book_kind"));
System.out.println(imageUp.getParameter("book_title"));
System.out.println(imageUp.getParameter("book_price"));
System.out.println(imageUp.getParameter("book_count"));
System.out.println(imageUp.getParameter("author"));

System.out.println(imageUp.getParameter("publishing_com"));
System.out.println(imageUp.getParameter("book_content"));
System.out.println(imageUp.getParameter("discount_rate"));
System.out.println(imageUp.getParameter("publishing_year"));
System.out.println(imageUp.getParameter("publishing_month"));
System.out.println(imageUp.getParameter("publishing_day"));

String	book_kind		= imageUp.getParameter("book_kind");
String	book_title		= imageUp.getParameter("book_title");
String	book_price		= imageUp.getParameter("book_price");
String	book_count		= imageUp.getParameter("book_count");
String	author			= imageUp.getParameter("author");

String	publishing_com	= imageUp.getParameter("publishing_com");
String	book_content	= imageUp.getParameter("book_content");
String	discount_rate	= imageUp.getParameter("discount_rate");

String	year			= imageUp.getParameter("publishing_year");

// 월과 일이 한자리이면 앞에 0을 붙여서 2자리로 만든다.
String	month			= (imageUp.getParameter("publishing_month").length() == 1)
						? "0" + imageUp.getParameter("publishing_month")
						: imageUp.getParameter("publishing_month");

String	day				= (imageUp.getParameter("publishing_day").length() == 1)
						? "0" + imageUp.getParameter("publishing_day")
						: imageUp.getParameter("publishing_day");

book.setBook_kind(book_kind);
book.setBook_title(book_title);
book.setBook_price(Integer.parseInt(book_price));
book.setBook_count(Short.parseShort(book_count));
book.setAuthor(author);

book.setPublishing_com(publishing_com);
book.setPublishing_date(year + "-" + month + "-" + day); // 2021-09-08
book.setBook_image(fileName);
book.setBook_content(book_content);


book.setDiscount_rate(Byte.parseByte(discount_rate));
book.setReg_date(new Timestamp(System.currentTimeMillis()));

// DAO와 연결한 후에 데이터를 넘겨주어서 처리하도록 한다.
BookDAO bookDAO = BookDAO.getInstance();

// 이미지 값이 있는지 없는지를 알려주기 위해서 imageStatus값을 같이 넘겨준다.
int result = bookDAO.insertBook(book, imageStatus);

PrintWriter pw = response.getWriter();

if(result == 1) { // 책의 정보가 등록이 완료되었으면
	pw.println("<script>");
	pw.println("alert('책의 등록을 완료하였습니다.')");
	pw.println("location.href='bookList.jsp?book_kind=" + book_kind + "'");
	pw.println("</script>");
} else { // 책의 정보를 등록하는 중에 문제가 생겼으면
	pw.println("<script>");
	pw.println("alert('책의 등록을 완료하지 못하였습니다.\\n잠시 후에 다시 시도해 주십시오.')");
	pw.println("history.back()");
	pw.println("</script>");
}


%>














