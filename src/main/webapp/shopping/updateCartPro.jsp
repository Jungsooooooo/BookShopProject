<%@page import="org.apache.commons.collections4.bag.SynchronizedSortedBag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDAO" %>
<%@ page import="bookshop.manager.BookDAO" %>
<%
// 세션 없이 들어오면 메인화면으로 돌려보낸다.
if(session.getAttribute("userID") == null || session.getAttribute("userID").equals("")) {
	response.sendRedirect("shopMain.jsp");
} 
String buyer = (String)session.getAttribute("userID");

String	cart_id			= request.getParameter("cart_id");
String	buy_count		= request.getParameter("buy_count");
String	buy_countOld	= request.getParameter("buy_countOld");
String	book_kind		= request.getParameter("book_kind");
String	book_id			= request.getParameter("book_id");

System.out.println("cart_id 	 : " + cart_id);
System.out.println("buy_count 	 : " + buy_count);
System.out.println("buy_countOld : " + buy_countOld);
System.out.println("book_kind 	 : " + book_kind);
System.out.println("book_id		 : " + book_id);


//[수정] 버튼을 누른 시점에 재고수량의 변동이 있을 수 있으므로 
//장바구니 테이블에 담기기전에 최종적으로 수량을 비교한다.
//book_id에 해당하는 책이 책방에 몇 권 남아있는 지를 알아야 비교할 수 있다.

//book_id에 해당하는 책이 책방에 몇 권 남아있는 지를 알아낸다.
int 	inventoryBookCount 	= 0;
BookDAO	bookDAO				= BookDAO.getInstance();
inventoryBookCount			= bookDAO.getBookIdCount(Integer.parseInt(book_id));

//사용자와 book_id에 해당하는 책이 cart 테이블에 있는지 조사한다.
int 	
cartTableCount		= 0;
CartDAO	cartDAO		= CartDAO.getInstance();
cartTableCount		= cartDAO.getBookIdCount(buyer, Integer.parseInt(book_id));

int		buyCount	= Integer.parseInt(buy_count);	// 비교하는데 사용하기 위해서 

//book_id에 해당하는 책의 책방재고와 (카트에 담겨있는 수량 + 현재 담으려는 수량)을 비교한다.
if(inventoryBookCount < 1) {
	%><script>alert('현재 재고가 없습니다.'); history.go(-1);</script><%	
} else if(buyCount < 1) {
	%><script>alert('주문은 최소 1권이상 하셔야 합니다.'); history.go(-1);</script><%	
} else if(buyCount > inventoryBookCount) {
	%><script>alert('주문하시려는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%	
} else if(cartTableCount > inventoryBookCount) {
	%><script>alert('장바구니에 담겨있는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%	
} else if(buyCount + cartTableCount > inventoryBookCount) {
	%><script>alert('장바구니에 담겨있는 수량 + 구매하고자하는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%	
} else {
	// 재고가 주문할 수 있을 만큼의 수량이 있다면 빈에다가 정보를 담는다.
	cartDAO.updateBuyCount(Integer.parseInt(cart_id), Byte.parseByte(buy_count));
	response.sendRedirect("cartList.jsp?book_kind=" + book_kind);
}	


%>







