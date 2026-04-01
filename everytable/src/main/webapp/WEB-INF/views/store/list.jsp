<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>원하는 매장을 찾아보세요 - 에브리테이블</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style type="text/css">
    body { background-color: #ffffff; }
    .container { max-width: 1100px; }
    
    /* 제목 스타일 */
    .search-title {
        font-weight: 800;
        font-size: 2rem;
        margin-top: 50px;
        margin-bottom: 30px;
        color: #212529;
    }

    /* 검색창 디자인 */
    .search-box {
        background: #ffffff;
        border: 1px solid #e9ecef;
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 50px;
    }
    .btn-search {
        background-color: #436551;
        color: white;
        border-radius: 10px;
        padding: 10px 25px;
        font-weight: bold;
    }
    .btn-search:hover { color: #fff; background-color: #355141; }
    
    /* 카드 디자인 */
    .dataRow { cursor: pointer; transition: transform 0.2s; }
    .dataRow:hover { transform: translateY(-5px); }
    
    .card {
        border: 1px solid #f1f3f5;
        border-radius: 20px;
        overflow: hidden;
        height: 100%;
        box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    }
    
    .store-img-wrapper {
        background-color: #f8f9fa;
        height: 250px;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
    }
    
    .store-img-wrapper i.fa-question {
        color: #adb5bd;
        font-size: 2rem;
    }
    
    .card-body { padding: 25px; }
    
    .cate-tag {
        color: #436551;
        font-weight: 700;
        font-size: 0.9rem;
        margin-bottom: 10px;
        display: block;
    }
    
    .store-name {
        font-weight: 800;
        font-size: 1.4rem;
        margin-bottom: 15px;
        color: #212529;
    }
    
    .store-addr {
        color: #868e96;
        font-size: 0.95rem;
        margin-bottom: 25px;
    }
    
    /* 카드 하단 (별점 & 화살표) */
    .card-footer-custom {
        border-top: 1px solid #f1f3f5;
        padding-top: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .rating-box {
        color: #fab005; /* 오렌지/옐로우 별색 */
        font-weight: 700;
        font-size: 1.1rem;
    }
    
    .rating-box span { color: #adb5bd; font-weight: 400; margin-left: 5px; }
    
    .arrow-icon { color: #dee2e6; font-size: 1.2rem; }
</style>

<script type="text/javascript">
$(function(){
    $(".dataRow").click(function(){
        let no = $(this).find(".no").val();
        location = "view.do?no=" + no + "&inc=1&${pageObject.pageQuery}";
    });
});
</script>
</head>
<body>

<div class="container">
    <h2 class="search-title">원하는 매장을 찾아보세요</h2>

    <div class="search-box">
        <form action="list.do">
            <input type="hidden" name="perPageNum" value="${pageObject.perPageNum}">
            <div class="row g-3">
                <div class="col-md-3">
                    <select name="key" class="form-select form-select-lg" style="border-radius: 10px;">
                        <option value="n" ${(pageObject.key == "n")?"selected":""}>지역</option>
                        <option value="c" ${(pageObject.key == "c")?"selected":""}>카테고리</option>
                        <option value="a" ${(pageObject.key == "a")?"selected":""}>전체</option>
                    </select>
                </div>
                <div class="col-md-7">
                    <input type="text" name="word" class="form-control form-control-lg" 
                           style="border-radius: 10px;" placeholder="검색어를 입력하세요" value="${pageObject.word}">
                </div>
                <div class="col-md-2 d-grid">
                    <button class="btn btn-search btn-lg">
                        <i class="fa fa-search"></i> 검색
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <c:forEach var="vo" items="${list}">
            <div class="col dataRow">
                <input type="hidden" class="no" value="${vo.no}">
                <div class="card">
                    <div class="store-img-wrapper">
                        <c:choose>
                            <c:when test="${empty vo.fileName}">
                                <i class="fa-regular fa-image fa-2xl" style="color: #dee2e6;"></i>
                                <span style="position:absolute; top:10px; left:10px; color:#adb5bd; font-size: 0.8rem;">매장이미지</span>
                            </c:when>
                            <c:otherwise>
                                <img src="/upload/store/${vo.fileName}" style="width:100%; height:100%; object-fit:cover;">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="card-body">
                        <span class="cate-tag">#${vo.category}</span>
                        <h5 class="store-name">${vo.name}</h5>
                        <p class="store-addr">${vo.address}</p>
                        
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