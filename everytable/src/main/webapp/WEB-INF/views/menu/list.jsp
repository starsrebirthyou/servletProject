<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    body { background-color: #fdfdfd; font-family: 'Pretendard', sans-serif; }
    .menu-card { border-radius: 25px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.05); height: 100%; transition: 0.3s; background:#fff; border:none;}
    .img-box { position: relative; height: 240px; }
    .sold-out-overlay {
        position: absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.25);
        display:none; align-items:center; justify-content:center; color:#fff; font-size:1.8rem; font-weight:800; backdrop-filter:blur(5px);
    }
    .is-sold-out .sold-out-overlay { display: flex; }
    .btn-add { background-color: #1a6d42; color: white; border-radius: 12px; padding: 12px 24px; font-weight:bold; border:none; }
</style>
</head>
<body>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-end mb-5">
        <div><p class="text-muted mb-1">${vo.store_name}</p><h2 class="fw-bold">메뉴 관리</h2></div>
        <button class="btn-add" onclick="location='write.do?store_id=${vo.store_id}'"><i class="fa fa-plus me-2"></i> 메뉴 추가</button>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:forEach var="menu" items="${menuList}">
            <div class="col">
                <div class="menu-card ${menu.is_active == 0 ? 'is-sold-out' : ''}">
                    <div class="img-box">
                        <img src="${menu.image_url}" class="w-100 h-100" style="object-fit:cover;">
                        <div class="sold-out-overlay">품절</div>
                    </div>
                    <div class="card-body p-4">
                        <h5 class="fw-bold">${menu.menu_name}</h5>
                        <p class="text-muted small" style="height:45px;">${menu.description}</p>
                        <p class="fw-bold fs-4" style="color:#1a6d42;"><fmt:formatNumber value="${menu.price}"/>원</p>
                        <div class="d-flex gap-2">
                            <button class="btn flex-grow-1 fw-bold ${menu.is_active == 1 ? 'btn-light text-success' : 'btn-secondary'}"
                                    onclick="location='changeStatus.do?menu_no=${menu.menu_no}&is_active=${menu.is_active == 1 ? 0 : 1}&store_id=${vo.store_id}'">
                                <i class="fa-regular fa-eye"></i> ${menu.is_active == 1 ? '판매중' : '품절'}
                            </button>
                            <%-- ✅ store_id 추가 --%>
                            <button class="btn btn-light" onclick="location='update.do?menu_no=${menu.menu_no}&store_id=${vo.store_id}'">
                                <i class="fa-regular fa-pen-to-square"></i>
                            </button>
                            <%-- ✅ store_id 파라미터 추가 --%>
                            <button class="btn btn-light text-danger" onclick="deleteMenu(${menu.menu_no}, ${vo.store_id})">
                                <i class="fa-regular fa-trash-can"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    function deleteMenu(menu_no, store_id) {
        if(confirm("삭제하시겠습니까?")) {
            location.href = "delete.do?menu_no=" + menu_no + "&store_id=" + store_id;
        }
    }
</script>
</body>
</html>