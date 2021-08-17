<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "User.UserDAO" %>

<%@ page import = "java.io.PrintWriter" %> <!-- 자바스크립트문을 작성하기 위해사용 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 모든 데이터를 UTF-8로 받음 -->

<jsp:useBean id="user" class="User.User" scope = "page" />
<!-- id : JSP페이지에서 자바빈 객체에 접근할 때 쓰는 이름 class : 패키지 이름을 포함한 자바빈 클래스 이름 scope: 자바빈 객체가 저장될 영역-->
<!-- JSP에서 기능과 화면출력을 구분하기 위해서 JavaBean이라는 클래스에 데이터를 담아서 데이터를 보여줌 -->

<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<!-- name : property 값을 변경할 자바빈 객체의 이름(useBean에서의 id값) property: 값을 지정할 property이름-->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BBS-로그인</title>
</head>
<body>
	<%
		//세션 관리
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		//로그인 성공
		if(result == 1){
			session.setAttribute("userID",user.getUserID());
			// 세션 속성명이 'userID'인 속성에 속상값으로 user.getUserID() 할당
			
			PrintWriter script = response.getWriter();
			//response라는 서버가 클라이언트에게 응답할 때 쓰는 객체 생성
			//객체를 통해 getWriter() -> '쓰기'를 통해 응답
			
			script.println("<script>");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		//비밀번호가 틀린 경우
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다!')");
			script.println("history.back()");
			script.println("</script>");
		}
		//아이디 없는 경우
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다!')");
			script.println("history.back()");
			script.println("</script>");
		}
		//데이터베이스에 오류가 생긴 경우
		else if(result == -2){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스에 오류가 생겼습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>
