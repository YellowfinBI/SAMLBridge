<%@page import="java.rmi.RemoteException"%>
<%@page import="java.util.UUID"%>
<%@page import="com.hof.saml.SamlBridgeServlet"%>
<%@page import="com.hof.mi.web.service.*"%>
<%@page import="com.onelogin.saml2.SamlAuth"%>
<%@page import="com.onelogin.saml2.servlet.ServletUtils"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%> 
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%! 

 public boolean userExists(String userId) {
	
	try {
	
		AdministrationServiceResponse rs = null;
	    AdministrationServiceRequest rsr = new AdministrationServiceRequest();
	    AdministrationServiceService ts = new AdministrationServiceServiceLocator(SamlBridgeServlet.yellowfinWebservicesURL + "/services/AdministrationService");
	    AdministrationServiceSoapBindingStub rssbs = (AdministrationServiceSoapBindingStub) ts.getAdministrationService();
	    
	    rsr.setLoginId(SamlBridgeServlet.yellowfinWebservicesUsername);
	    rsr.setPassword(SamlBridgeServlet.yellowfinWebservicesPassword);
	    rsr.setOrgId(new Integer(1));
	    rsr.setFunction("GETUSER");
		
	    AdministrationPerson ap = new AdministrationPerson();
	    ap.setUserId(userId);
	    rsr.setPerson(ap);
	    rs = rssbs.remoteAdministrationCall(rsr);
	    
	    if (rs.getPerson()!=null) return true;
    
	} catch (Exception e) {
		e.printStackTrace();
	}
    
    return false;
    
 }

 public boolean createUser(String username, String password, String firstName, String secondName, String fullName, String emailAddress, String role) {
	 
	    try {
	 
		    AdministrationServiceResponse rs = null;
		    AdministrationServiceRequest rsr = new AdministrationServiceRequest();
		    AdministrationServiceService ts = new AdministrationServiceServiceLocator(SamlBridgeServlet.yellowfinWebservicesURL + "/services/AdministrationService");
		    AdministrationServiceSoapBindingStub rssbs = (AdministrationServiceSoapBindingStub) ts.getAdministrationService();
		    
		    rsr.setLoginId(SamlBridgeServlet.yellowfinWebservicesUsername);
		    rsr.setPassword(SamlBridgeServlet.yellowfinWebservicesPassword);
		    rsr.setOrgId(new Integer(1));
		    rsr.setFunction("ADDUSER");
			
		    if (firstName==null && secondName==null && fullName!=null) {
		    	
		    	int index = fullName.indexOf(" ");
		    	if (index>0) {
		    		firstName = fullName.substring(0, index).trim();
		    		secondName = fullName.substring(index).trim();
		    	} else {
		    		firstName = fullName;
		    		secondName = "";
		    	}
		    }
		    
		    AdministrationPerson ap = new AdministrationPerson();
		    ap.setUserId(username);
		    ap.setPassword(password);
		    ap.setFirstName(firstName);
		    ap.setSalutationCode(null);
		    ap.setLastName(secondName);
		    ap.setRoleCode(role);
		    ap.setEmailAddress(emailAddress);
		    rsr.setPerson(ap);
		     
		    rs = rssbs.remoteAdministrationCall(rsr);
		    
		    if ("SUCCESS".equals(rs.getStatusCode()) ) return true;
	    
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    
	    return false;
	    
 }

 
 public String ssoUser(String userId) {
	 
	    try {
	 
		    AdministrationServiceResponse rs = null;
		    AdministrationServiceRequest rsr = new AdministrationServiceRequest();
		    AdministrationServiceService ts = new AdministrationServiceServiceLocator(SamlBridgeServlet.yellowfinWebservicesURL + "/services/AdministrationService");
		    AdministrationServiceSoapBindingStub rssbs = (AdministrationServiceSoapBindingStub) ts.getAdministrationService();
		    
		    rsr.setLoginId(SamlBridgeServlet.yellowfinWebservicesUsername);
		    rsr.setPassword(SamlBridgeServlet.yellowfinWebservicesPassword);
		    rsr.setOrgId(new Integer(1));
		    rsr.setFunction("LOGINUSERNOPASSWORD");
			
		    AdministrationPerson ap = new AdministrationPerson();
		    ap.setUserId(userId);
		    rsr.setPerson(ap);
		    
		    rs = rssbs.remoteAdministrationCall(rsr);
		    
		    if ("SUCCESS".equals(rs.getStatusCode()) ) return rs.getLoginSessionId();
	    
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    
	    return null;
	 
 }
 
public String get(String key, Map<String, List<String>> attributes) {
	
	List<String> attrs = attributes.get(key);
	if (attrs!=null && attrs.size() > 0) return attrs.get(0);
	return null;
}
 
 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
		StringBuffer sb = new StringBuffer(2000);
		Boolean unsuccessful = false;

		SamlAuth auth = new SamlAuth(request, response);
		auth.processResponse();

		if (!auth.isAuthenticated()) {
			sb.append("<div class=\"alert alert-danger\" role=\"alert\">Not authenticated</div>");
			unsuccessful = true;
		}

		List<String> errors = auth.getErrors();

	    if (!errors.isEmpty()) {
	    	sb.append("<p>" + StringUtils.join(errors, ", ") + "</p>");
	    	if (auth.isDebugActive()) {
	    		String errorReason = auth.getLastErrorReason();
	    		if (errorReason != null && !errorReason.isEmpty()) {
	    			sb.append("<p>" + auth.getLastErrorReason() + "</p>");
	    		}
	    	}
	    	sb.append("<a href=\"dologin.jsp\" class=\"btn btn-primary\">Login</a>");
	    } else {
			Map<String, List<String>> attributes = auth.getAttributes();
			String nameId = auth.getNameId();

			session.setAttribute("attributes", attributes);
			session.setAttribute("nameId", nameId);

			String relayState = request.getParameter("RelayState");

			if (relayState != null && relayState != ServletUtils.getSelfRoutedURLNoQuery(request) &&
				!relayState.contains("/dologin.jsp") ) { // We don't want to be redirected to login.jsp neither
				response.sendRedirect(request.getParameter("RelayState"));
			} else {
				
				String username = get(SamlBridgeServlet.attributeUsername, attributes);
  				String email = get(SamlBridgeServlet.attributeEmailAddress, attributes);
  				String firstName = get(SamlBridgeServlet.attributeFirstName, attributes);
  				String lastName = get(SamlBridgeServlet.attributeLastName, attributes);
  				String fullName = get(SamlBridgeServlet.attributeFullName, attributes);
  				String role = SamlBridgeServlet.yellowfinRole;
				
				if (attributes.isEmpty()) {
					sb.append("<div class=\"alert alert-danger\" role=\"alert\">You don't have any attributes</div>");							
				}
				else {
					
					boolean userExists = userExists(username);
					boolean createdUserOK = false;
					boolean errorsFindingUser = false;
					
					if (!userExists && SamlBridgeServlet.autoprovisionUsers) {
						
						if (username==null || email==null || (firstName==null && lastName==null && fullName==null) || role == null) {
							errorsFindingUser = true;
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">You don't have all the required provisioning attributes</div>");	
						}
						if (username==null ) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Username attribute '" + SamlBridgeServlet.attributeUsername + "' not available</div>");	
						}
						if (email==null ) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Email attribute '" + SamlBridgeServlet.attributeEmailAddress + "' not available</div>");	
						}
						if (fullName==null) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Full Name attribute '" + SamlBridgeServlet.attributeFullName + "' not available</div>");	
						}
						if (firstName==null) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">First Name attribute '" + SamlBridgeServlet.attributeFirstName + "' not available</div>");	
						}
						if (lastName==null ) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Last Name attribute '" + SamlBridgeServlet.attributeLastName + "' not available</div>");	
						}
						if (role==null ) {
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Role attribute not set</div>");	
						}
						
						if (!errorsFindingUser ) {
							createdUserOK = createUser(username, UUID.randomUUID().toString().substring(0,16), firstName, lastName, fullName, email, role);
						
							if (!createdUserOK) {
								errorsFindingUser = true;
								sb.append("<div class=\"alert alert-danger\" role=\"alert\">Problem provisioning Yellowfin User. Please check Yellowfin logs.</div>");	
							} else {
								userExists = true;
							}
							
							
						}
					}
					
					if (!userExists) {
						
						errorsFindingUser = true;
						sb.append("<div class=\"alert alert-danger\" role=\"alert\">Could not find User.</div>");	
						
					}
					
					if (!errorsFindingUser) {
					
						String token = ssoUser(username);
						
						if (token==null) {
							
							sb.append("<div class=\"alert alert-danger\" role=\"alert\">Problems redirecting to Yellowfin. Please contact an Administrator </div>");
							
						} else {
						
						String redirectURL = SamlBridgeServlet.yellowfinWebservicesURL + "/logon.i4?LoginWebserviceId=" + token;
					    response.sendRedirect(redirectURL);
						return;	
						
						}
					}
				    
				}
	
			}
		}
		%>
<!DOCTYPE html>
<html>
<head>
	 <meta charset="utf-8">
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1">
	 <title>Yellowfin SAML Bridge</title>
	 <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">

     <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
     <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
     <!--[if lt IE 9]>
       <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
       <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
     <![endif]-->
</head>
<body>
	<div class="container">
    	<h1>Yellowfin SAML Bridge</h1>

    	<!--  TODO Session support  --> 

		<%= sb.toString() %>
	
	</div>
</body>
</html>
