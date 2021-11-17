<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>

<%
request.setCharacterEncoding("UTF-8");

int		book_id		= Integer.parseInt(request.getParameter("book_id"));
String	book_kind	= request.getParameter("book_kind");

BookDAO	bookDAO	= BookDAO.getInstance();
bookDAO.deleteBook(book_id);

response.sendRedirect("bookList.jsp?book_kind=all");
%>
