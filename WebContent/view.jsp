<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
<link rel="stylesheet" href="css/custom.css">
<title>BBS-view</title>
</head>


<body style= "background-color : white;">

	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
			//로그인이 된 회원은 로그인의 정보를 담을 수 있도록 설정
		}
		
		//bbsID를 초기화시킴
		int bbsID = 0;
		
		//'bbsID'라는 데이터가 넘어온 것이 존재하면 캐스팅하여 변수에 담는다.
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		
		//넘어온 데이터가 없는 경우
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp");
			script.println("</script>");
		}
		
		//유효한 글이라면 구체적인 정보를 'bbs'라는 인스턴스에 담는다.
		Bbs bbs = new BbsDAO().getBbs(bbsID);
	%>
	

	<nav class="navbar navbar-expand-lg navbar-light bg-light">
  		<a class="navbar-brand" href="#" >JSP 게시판</a>
  			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item">
        <a class="nav-link" href="main.jsp">메인 <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="bbs.jsp">게시판</a>
      </li>
			<%
				if(userID == null) //로그인이 되어있지 않았을때, 
				{
			%>
			
			<li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		          접속하기
		        </a>
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		          <a class="dropdown-item" href="login.jsp">로그인</a>
		          <div class="dropdown-divider"></div>
		          <a class="dropdown-item" href="join.jsp">회원가입</a>
		
		        </div>
		      </li>
		      
			<%
				}else	//로그인이 되었을때
				{
			%>	
			
				<li class="nav-item dropdown">
			        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			          회원관리
			        </a>
			        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
			          <a class="dropdown-item" href="logoutAction.jsp">로그아웃</a>
			          <div class="dropdown-divider"></div>
					<a class="dropdown-item" href="deleteUser.jsp">탈퇴하기</a>
			          <div class="dropdown-divider"></div>
					<a class="dropdown-item" href="mypage.jsp">마이페이지</a>
			        </div>
			      </li>
   				</ul>
			<% 
				}
			%>
			
			
		</div>
	</nav>
	
	<div class = "container pt-3">
		<div class = "row">
				<table class = "table table-stripped" style = "text-align:center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan = "2" style = "background-color:#aaaaaa; text-align:cneter;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style = "width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle() %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"> <%= bbs.getUserID() %></td>
							
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan = "2"><%= bbs.getBbsDate().substring(0,11)+bbs.getBbsDate().substring(11,13)+"시"+bbs.getBbsDate().substring(14,16)+"분" %></td>
						</tr>
						<tr>
							<td>내용</td>
						<td colspan="2" style="height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;")
							.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
					</tbody>
				</table>
				<a href = "bbs.jsp" class = "btn btn-primary">목록</a>
				<%
					if(userID != null && userID.equals(bbs.getUserID())){
				%>	
				
					<a href = "update.jsp?bbsID=<%=bbsID %>" class = "btn btn-primary">수정</a>
					<a href = "deleteAction.jsp?bbsID=<%=bbsID %>" class = "btn btn-primary">삭제</a>		
				<%
					}
				%>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns" crossorigin="anonymous"></script>
</body>
</html>
							
