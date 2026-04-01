<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리별 통계</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card p-4">
        <h3 class="mb-4">카테고리별 인기 순위</h3>

        <ul class="nav nav-tabs mb-4" id="categoryTab" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#korean">한식</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#western">양식</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#japanese">일식</button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="korean">
                <h5>인기 메뉴 TOP 5</h5>
                <div class="list-group">
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        1. 전주 비빔밥
                        <span class="badge bg-primary rounded-pill">152개 판매</span>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        2. 김치찌개 정식
                        <span class="badge bg-primary rounded-pill">120개 판매</span>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        3. 제육 볶음
                        <span class="badge bg-primary rounded-pill">98개 판매</span>
                    </div>
                </div>

                <h5 class="mt-4">인기 매장 순위</h5>
                <table class="table table-sm">
                    <thead>
                        <tr>
                            <th>순위</th>
                            <th>매장명</th>
                            <th>평점</th>
                            <th>총 주문수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>남산 한옥식당</td>
                            <td>⭐ 4.9</td>
                            <td>1,240</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            </div>
    </div>
    <div class="mt-3 text-end">
        <a href="dashboard.jsp" class="btn btn-secondary">메인으로 돌아가기</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>