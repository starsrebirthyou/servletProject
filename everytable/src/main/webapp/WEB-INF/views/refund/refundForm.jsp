<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>환불 신청</h2>
	<hr>
	<form action="refund.do" method="post">
		<input type="hidden" name="order_id" value="${vo.order_id}">
		<input type="hidden" name="payment_id" value="${vo.order_id}">
		<input type="hidden" name="user_id" value="${vo.user_id}">
		<input type="hidden" name="refund_rate" value="${refund_rate}">
		<input type="hidden" name="refund_amount" value="${refund_amount}">
		<table class="table">
			<tr>
				<th>주문번호</th>
				<td>${vo.order_id }</td>
			</tr>
			<tr>
				<th>결제금액</th>
				<td><fmt:formatNumber value="${vo.amount}" pattern="#,###"/>원</td>
			</tr>
			<tr>
				<th>환불 비율</th>
				<td>${refund_rate}% 환불 가능 </td>
			</tr>
			<tr>
				<th>최종 환불 금액</th>
				<td> <fmt:formatNumber value="${refund_amount}" pattern="#,###"/>원</td>
			</tr>
			<tr>
				<th>환불 사유</th>
				<td> 
					<textarea name="reason" class="form-control" rows="3" placeholder="환불 사유 입력" required></textarea>
				</td>
			</tr>
		</table>
		
		<div class="text-center">
                <button type="submit" class="btn btn-danger">환불 신청하기</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
            </div>
	</form>
</body>
</html>