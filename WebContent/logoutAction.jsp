<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout</title>
</head>
<body>
	<%
		session.invalidate();
		// 세션 정보를 제거
	%>
	<script>
		location.href = 'login.jsp';
	</script>
</body>
</html>
