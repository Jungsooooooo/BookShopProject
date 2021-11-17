<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%
String	managerId	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

String	buy_id		= request.getParameter("buyId");
// 라디오버튼은 같은 이름이 여러개라도 선택된 값이 전송되기 때문에 getParameter로 받으면 된다.
String	sanction	= request.getParameter("sanction");

System.out.println("deliveryUpModalPro.jsp => " + buy_id + ":" + sanction);

BuyDAO	buyDAO = BuyDAO.getInstance();
buyDAO.updateSanction(buy_id, sanction);

// 작업이 정상적으로 완료되면 배송 목록 화면으로 이동시킨다.
response.sendRedirect("deliveryList.jsp");
%>
