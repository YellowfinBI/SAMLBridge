<%@page import="com.onelogin.saml2.SamlAuth"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<%
		SamlAuth auth = new SamlAuth(request, response);
		if (request.getParameter("attrs") == null) {
			auth.login();
		} else {
			String x = request.getPathInfo();
			auth.login("attrs.jsp");
		}
	%>
</body>
</html>
