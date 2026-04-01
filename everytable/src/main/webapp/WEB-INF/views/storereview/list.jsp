<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
{
	"list":[
		<c:if test="${!empty list }">
			<c:forEach items="${list }" var="vo" varStatus="vs">
				{
					 "reviewId": ${vo.reviewId},
					 "content": "${vo.content}",
					 "userId": "${vo.userId}",
					 "userName": "${vo.userName}",
					 "storeId": ${vo.storeId},
					 "rating": ${vo.rating},
					 "isDeleted": ${vo.isDeleted},
					 "createdAt": "${vo.createdAt}",
					 "sameId": ${vo.sameId}
				}<c:if test="${!vs.last }">,</c:if>
			</c:forEach>		
		</c:if>
	],
	"pageObject":{
		"page": ${pageObject.page},
		"perPageNum": ${pageObject.perPageNum},
		"startPage": ${pageObject.startPage},
		"endPage": ${pageObject.endPage},
		"totalPage": ${pageObject.totalPage},
		"totalRow": ${pageObject.totalRow}
	}
}
