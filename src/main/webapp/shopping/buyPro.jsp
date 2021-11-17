<%@page import="org.apache.commons.collections4.bag.SynchronizedSortedBag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.shopping.CartDTO" %>
<%@ page import="bookshop.shopping.CartDAO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>

<%
request.setCharacterEncoding("UTF-8");

// 세션값이 없으면 메인화면으로 돌려보낸다.
if(session.getAttribute("userID") == null || session.getAttribute("userID").equals("") ) {
	response.sendRedirect("shopMain.jsp");
}

// buyForm.jsp에서 넘겨준 정보들을 변수에 저장한다.
String	account			= request.getParameter("account");
String	deliveryName	= request.getParameter("deliveryName");
String	deliveryTel		= request.getParameter("deliveryTel");
String	deliveryAddress	= request.getParameter("deliveryAddress");
String	buyer			= (String)session.getAttribute("userID");

System.out.println("buyPro => " + account);
System.out.println("buyPro => " + deliveryName);
System.out.println("buyPro => " + deliveryTel);
System.out.println("buyPro => " + deliveryAddress);
System.out.println("buyPro => " + buyer);

// 구매자가 가지고 있는 카트들의 모든 정보를 가져온다.
CartDAO			cartDAO		= CartDAO.getInstance();
List<CartDTO>	cartLists	= cartDAO.getCarts(buyer);

// 구매자가 가지고 있는 카트들에 담겨져 있는 책을 구매확정시킨다.
BuyDAO			buyDAO		= BuyDAO.getInstance();
buyDAO.insertBuy(cartLists, buyer, account, deliveryName, deliveryTel, deliveryAddress);

// 구매가 끝나면 구매목록 페이지로 이동시킨다.
response.sendRedirect("buyList.jsp");
%>





