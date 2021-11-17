<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
System.out.println("cartListDel list => " + request.getParameter("list"));

String	list		= request.getParameter("list");
String	buyer		= (String)session.getAttribute("userID");
String	book_kind	= request.getParameter("book_kind");

if(session.getAttribute("userID") == null || session.getAttribute("userID").equals("")) {
	PrintWriter pw	= response.getWriter();
	pw.println("<script>");
	pw.println("alert('로그인을 하셔야 합니다.')");
	pw.println("location.href='shopMain.jsp'");
	pw.println("</script>");
} else {
	CartDAO	cartDAO	= CartDAO.getInstance();
	
	if(list.equals("all")) { // 어떤 바이어가 가지고 있는 모든 장바구니 비우기
		cartDAO.deleteAllCart(buyer);
	} else { // 하나의 바구니만 비우기
		cartDAO.deleteCart(Integer.parseInt(list));
	}
	response.sendRedirect("cartList.jsp?book_kind=" + book_kind);
}
%>
