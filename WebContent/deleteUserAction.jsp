<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "User.UserDAO" %>

<%@ page import = "java.io.PrintWriter" %> 
<% request.setCharacterEncoding("UTF-8"); %> 

<jsp:useBean id="user" class="User.User" scope = "page" />

<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BBS-탈퇴</title>
</head>
<Body>
	<%
		//세션
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		if(user.getUserPassword() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('채워지지 않은 항목이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}else{
			if(userID != user.getUserID()){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인한 회원정보가 다릅니다.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>");
			}else{
				UserDAO userDAO = new UserDAO();
				int result = userDAO.delete(user.getUserID(),user.getUserPassword());
				
				if(result == 1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('탈퇴되었습니다.')");
					script.println("location.href = 'logoutAction.jsp'");
					script.println("</script>");
				}
				//비밀번호가 틀린 경우
				else if(result == 0){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('비밀번호가 틀렸습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				//아이디가 없는 경우
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
			}
		}
	%>

</Body>
</html>
