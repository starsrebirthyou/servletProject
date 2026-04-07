<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 리스트 - EveryTable</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    body { background-color: #fff; font-family: 'Pretendard', sans-serif; margin: 0; }
    .store-container { max-width: 1200px; margin: 0 auto; padding: 0 15px; }
    .main-title { font-weight: 800; font-size: 2.2rem; margin: 60px 0 35px; color: #212529; }

    /* 검색창 */
    .search-area { background: #fff; border: 1px solid #eee; border-radius: 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); margin-bottom: 50px; }
    .btn-search { background-color: #436551; color: white; border-radius: 12px; padding: 10px 25px; font-weight: bold; border: none; }
    .form-select, .form-control { border-radius: 12px; border: 1px solid #E9ECEF; padding: 12px 15px; }

    /* 카드 디자인 */
    .dataRow { cursor: pointer; transition: 0.3s; }
    .dataRow:hover { transform: translateY(-5px); }
    .card { border: none; border-radius: 20px; overflow: hidden; height: 100%; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    
    /* 이미지 영역: 텍스트를 모두 제거하고 이미지만 꽉 차게 설정 */
    .img-wrapper { position: relative; height: 260px; background: #f8f9fa; overflow: hidden; display: flex; align-items: center; justify-content: center; }
    .img-wrapper img { width: 100%; height: 100%; object-fit: cover; }
    .no-img-icon { font-size: 3rem; color: #dee2e6; }

    /* 카드 바디 (정보 영역) */
    .card-body { padding: 25px; background: #fff; }
    /* 카테고리는 이름 위로 작게 배치 */
    .cate-text { color: #436551; font-weight: 700; font-size: 0.85rem; margin-bottom: 5px; display: block; }
    .store-name { font-weight: 800; font-size: 1.4rem; margin-bottom: 8px; color: #212529; }
    .store-addr { color: #868e96; font-size: 0.9rem; margin-bottom: 20px; height: 1.2rem; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    
    .card-footer-custom { border-top: 1px solid #f8f9fa; padding-top: 15px; display: flex; justify-content: space-between; align-items: center; }
    .rating-box { color: #FFB800; font-weight: 700; font-size: 1.1rem; }
    .rating-box span { color: #ADB5BD; font-weight: 400; margin-left: 5px; font-size: 0.9rem;}
    .arrow-icon { color: #dee2e6; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
    $(".dataRow").click(function(){
        let store_id = $(this).find(".store_id").val();
        location = "view.do?store_id=" + store_id + "&inc=1&${pageObject.pageQuery}";
    });
});
</script>
</head>
<body>

<div class="store-container">
    <h2 class="main-title">원하는 매장을 찾아보세요</h2>
    
    <div class="search-area">
        <form action="list.do">
            <div class="row g-3">
                <div class="col-md-3">
                    <select name="key" class="form-select form-select-lg">
                        <option value="n" ${(pageObject.key == "n")?"selected":""}>매장명</option>
                        <option value="c" ${(pageObject.key == "c")?"selected":""}>카테고리</option>
                    </select>
                </div>
                <div class="col-md-7">
                    <input type="text" name="word" class="form-control form-control-lg" placeholder="검색어를 입력하세요" value="${pageObject.word}">
                </div>
                <div class="col-md-2 d-grid">
                    <button class="btn btn-search btn-lg">검색</button>
                </div>
            </div>
        </form>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <c:forEach var="vo" items="${list}">
            <div class="col dataRow">
                <input type="hidden" class="store_id" value="${vo.store_id}">
                
                <div class="card h-100">
                    <div class="img-wrapper">
                        <c:choose>
                            <c:when test="${!empty vo.filename}">
                                <img src="/upload/store/${vo.filename}" alt="${vo.store_name}">
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-image no-img-icon"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="card-body">
                        <span class="cate-text">#${vo.store_cate}</span>
                        <h5 class="store-name">${vo.store_name}</h5>
                        <p class="store-addr">${vo.store_addr}</p>
                        
                        <div class="card-footer-custom">
                            <div class="rating-box">
                                <i class="fa-solid fa-star"></i> ${vo.avg_rating} 
                                <span>(${vo.review_count})</span>
                            </div>
                            <div class="arrow-icon">
                                <i class="fa-solid fa-chevron-right"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="d-flex justify-content-center mb-5">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
    </div>
</div>

</body>
</html>