<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기간별 매출 조회</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card p-4">
        <h3 class="mb-4">기간별 매출 상세 조회</h3>
        
        <form class="row g-3 mb-4">
            <div class="col-auto">
                <label for="startDate" class="form-label">시작일</label>
                <input type="date" class="form-control" id="startDate" name="startDate">
            </div>
            <div class="col-auto">
                <label for="endDate" class="form-label">종료일</label>
                <input type="date" class="form-control" id="endDate" name="endDate">
            </div>
            <div class="col-auto d-flex align-items-end">
                <button type="submit" class="btn btn-primary">조회하기</button>
            </div>
        </form>

        <hr>

        <table class="table table-hover mt-3">
            <thead class="table-dark">
                <tr>
                    <th>일자</th>
                    <th>주문건수</th>
                    <th>결제금액</th>
                    <th>취소금액</th>
                    <th>순매출</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>2026-03-30</td>
                    <td>45건</td>
                    <td>₩1,200,000</td>
                    <td>₩50,000</td>
                    <td class="fw-bold text-primary">₩1,150,000</td>
                </tr>
                <tr>
                    <td>2026-03-29</td>
                    <td>38건</td>
                    <td>₩980,000</td>
                    <td>₩0</td>
                    <td class="fw-bold text-primary">₩980,000</td>
                </tr>
            </tbody>
            <tfoot class="table-light">
                <tr class="fw-bold">
                    <td colspan="4 text-center">합계</td>
                    <td class="text-danger">₩2,130,000</td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div class="mt-3 text-end">
        <a href="dashboard.jsp" class="btn btn-secondary">메인으로 돌아가기</a>
    </div>
</div>

</body>
</html>