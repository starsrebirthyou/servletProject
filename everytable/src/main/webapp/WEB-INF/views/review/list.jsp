<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 목록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    // 1. 리뷰 작성하기 버튼 클릭 이벤트
    $("#writeBtn").click(function() {
        // 현재 로그인 세션 체크 (JSP에서 세션 아이디가 있는지 확인)
        let loginId = "${login.id}"; 
        
        if(!loginId) {
            if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
                location.href = "/member/loginForm.do";
            }
        } else {
            // 로그인 되어 있다면 작성 페이지로 이동 (매장번호 1번 가정)
            location.href = "writeForm.do?storeId=1";
        }
    });

    // 2. 서버에서 리뷰 목록 가져오기
    function loadReviewList() {
        $.getJSON("/review/list.do", function(data) {
            let list = data.list;
            let html = "";
            
            $("#totalReviewCount").text(data.pageObject.totalRow);

            if(!list || list.length == 0) {
                html = "<div class='text-center py-5'>등록된 리뷰가 없습니다.</div>";
            } else {
                $(list).each(function(i, vo) {
                    // 별점 그리기 로직
                    let stars = "";
                    for(let i=1; i<=5; i++) {
                        if(i <= vo.rating) stars += "★";
                        else stars += "<span class='star-empty'>★</span>";
                    }

                    // 백틱(`)을 사용한 템플릿 리터럴
                    html += `
                        <div class="review-card shadow-sm">
                            <div class="d-flex align-items-center">
                                <div class="user-avatar">\${vo.userName.substring(0,1)}</div>
                                <div class="ml-3">
                                    <div class="d-flex align-items-center">
                                        <span class="font-weight-bold mr-2">\${vo.userName}님</span>
                                        <span class="star-rating">\${stars}</span>
                                    </div>
                                    <div class="small text-muted">\${vo.createdAt}</div>
                                </div>
                            </div>
                            <div class="review-content">\${vo.content}</div>
                            <div class="menu-tag">매장 번호: \${vo.storeId}</div>
                        </div>
                    `; // <- 끝에 백틱(`)과 세미콜론 확인!
                });
            }
            $("#reviewList").html(html);
        });
    }

    // 페이지 로드 시 리스트 불러오기 실행
    loadReviewList();
});
</script>


<style>
.review-card {
	border: 1px solid #e9ecef;
	border-radius: 15px;
	padding: 25px;
	margin-bottom: 20px;
	background: #fff;
}

.user-avatar {
	width: 45px;
	height: 45px;
	background-color: #f0f8f7;
	color: #1a9c82;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	font-size: 1.1rem;
}

.star-rating {
	color: #ffc107;
	font-size: 1.1rem;
}

.star-empty {
	color: #dee2e6;
}

.review-content {
	font-size: 1.05rem;
	line-height: 1.6;
	margin: 15px 0;
	color: #333;
}

.menu-tag {
	display: inline-block;
	padding: 4px 12px;
	background: #f8f9fa;
	border-radius: 6px;
	color: #6c757d;
	font-size: 0.9rem;
	border: 1px solid #eee;
}

.btn-outline-success {
	border-color: #1a9c82;
	color: #1a9c82;
}

.btn-outline-success:hover {
	background-color: #1a9c82;
	border-color: #1a9c82;
}
</style>
</head>
<body>
	<div class="container mt-5">
		<div
			class="review-header d-flex justify-content-between align-items-center mb-4">
			<h4 class="font-weight-bold">
				총 <span id="totalReviewCount">0</span>개의 리뷰
			</h4>
			<select class="form-control col-md-2" id="sortOrder">
				<option value="latest">최신순</option>
				<option value="latest">오래된순</option>
				<option value="latest">인기순</option>
			</select>
		</div>

		<div id="reviewList"></div>

		<div class="text-center mt-5">
			<button
				class="btn btn-outline-success btn-lg px-5 py-3 font-weight-bold"
				id="writeBtn">리뷰 작성하기</button>
			<p class="text-muted mt-2 small">로그인 후 리뷰를 작성할 수 있습니다</p>

		</div>
	</div>
</body>
</html>