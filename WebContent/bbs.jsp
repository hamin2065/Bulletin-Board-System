<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
<link rel="stylesheet" href="css/custom.css">
<title>BBS-main</title>
<style type = "text/css">
	a{
		color:#000000;
		text-decoration: none;
	}
</style>
</head>


<body style= "background-color : #6E7783;">

	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
			//로그인이 된 회원은 로그인의 정보를 담을 수 있도록 설정
		}
		
		int pageNumber = 1;
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>

	<nav class="navbar navbar-expand-lg navbar-light bg-light justify-content-center">
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
						<a class="dropdown-item" href="deleteUser.jsp">탈퇴</a>
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
				<table class = "table table-hover" style="text-align:center; border:1px solid; background-color: #D8E6E7">
					<thead>
						<tr>
							<th style = "background-color:#eeeeee; text-align = center;">번호</th>
							<th style = "background-color:#eeeeee; text-align = center;">제목</th>
							<th style = "background-color:#eeeeee; text-align = center;">작성자</th>
							<th style = "background-color:#eeeeee; text-align = center;">작성일</th>
						</tr>
					</thead>
					<tbody>
	
						<%
							BbsDAO bbsDAO = new BbsDAO();
							ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
							
							for(int i = 0;i<list.size();i++){
								int bbs_num = (pageNumber-1)*10+i+1;
								
						%>
						<tr>
							<!-- 번호, 제목, 작성자, 작성일 표시 -->
							<td><%= bbs_num %></td>
							<td><a href = "view.jsp?bbsID=<%=list.get(i).getBbsID()%>">
							<%= list.get(i).getBbsTitle()%>
							<% if(pageNumber == 1 && i == 0){%>
							<span class="badge badge-danger">NEW!</span><%} %>
							</a></td>
							<td><%=list.get(i).getUserID()%></td>
							<td><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13)+
							"시"+list.get(i).getBbsDate().substring(14,16)+"분"%></td>
							<!-- MySQL에서 Date를 2019-06-06 12시48분으로 나타냄 -->
						</tr>
						<%
							}
						%>
					</tbody>
					
				</table>
				<!-- 페이징 처리 -->
				<%
					if(pageNumber != 1){
				%>
						<a href="bbs.jsp?pageNumber=<%=pageNumber-1%>" class = "btn btn-success btn-arrow-left">이전</a>
				<%
					}if(bbsDAO.nextPage(pageNumber+1)){
				%>
						<a href="bbs.jsp?pageNumber=<%=pageNumber+1%>" class = "btn btn-success btn-arrow-left">다음</a>
						
				<%	
					}
				%>
				
					<a href = "write.jsp" class="btn btn-outline-dark btn-arrow-right">글쓰기</a>
			
			</div>
		</div>
	
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns" crossorigin="anonymous"></script>
</body>
</html>
