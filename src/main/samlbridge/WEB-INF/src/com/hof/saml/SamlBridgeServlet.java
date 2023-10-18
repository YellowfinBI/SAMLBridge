package com.hof.saml;

import java.util.Enumeration;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

public class SamlBridgeServlet extends javax.servlet.http.HttpServlet {

	 public static String yellowfinWebservicesURL = null;
	 public static String yellowfinWebservicesUsername = null;
	 public static String yellowfinWebservicesPassword = null;
	 public static String yellowfinRole = null;
	 public static boolean autoprovisionUsers = false;
	 
	 public static String attributeUsername = null;
	 public static String attributeFirstName = null;
	 public static String attributeLastName = null;
	 public static String attributeFullName = null;
	 public static String attributeEmailAddress = null;
	 
	 
	 public void init(ServletConfig config) throws ServletException {
		 
		 super.init(config);
		 
		 Enumeration<String> options = config.getInitParameterNames();
		 
		 while (options.hasMoreElements()) {
			 String option = options.nextElement();
			 String loweroption = option.toLowerCase();
			 String value = config.getInitParameter(option);
			 
			 if ("yellowfinwebserviceurl".equals(loweroption)) {
				 
				 yellowfinWebservicesURL = value;
				 
			 } else if ("yellowfinwebserviceuser".equals(loweroption)) { 
				
				 yellowfinWebservicesUsername = value;
				 
			 } else if ("yellowfinwebservicepassword".equals(loweroption)) {
						
					 yellowfinWebservicesPassword = value;
					 
			 } else if ("usernameattribute".equals(loweroption)) {
							
				     attributeUsername = value;
			 
			 } else if ("firstnameattribute".equals(loweroption)) {
					
			     	attributeFirstName = value;
			     
			 } else if ("lastnameattribute".equals(loweroption)) {
					
			     	attributeLastName = value;
			     	
			 } else if ("fullnameattribute".equals(loweroption)) {
					
			     	attributeFullName = value;
			     
			 } else if ("emailattribute".equals(loweroption)) {
					
			     	attributeEmailAddress = value;
			     	
			 } else if ("yellowfinrole".equals(loweroption)) {
					
			     	yellowfinRole = value;
			     	
			 } else if ("autoprovision".equals(loweroption)) {
					
			     	autoprovisionUsers = Boolean.valueOf(value);
			     	
			 }
			 
			 
		 }
		 
		 System.out.println("============ Yellowfin SAML Bridge ===============");
		 System.out.println("");
		 System.out.println(" Yellowfin Webservices URL: " + yellowfinWebservicesURL);
		 System.out.println(" Yellowfin Webservices User: " + yellowfinWebservicesUsername);
		 System.out.println(" Yellowfin Webservices Password: " + (yellowfinWebservicesPassword==null ? "Not Set" : "Set") );
		 System.out.println("");
		 System.out.println(" SAML Attribute Mappings: ");
		 System.out.println("");
		 System.out.println(" Username: " + attributeUsername);
		 System.out.println(" Email: " + attributeEmailAddress);
		 System.out.println(" First Name: " + attributeFirstName);
		 System.out.println(" Last Name: " + attributeLastName);
		 System.out.println(" Full Name Attribute: " + attributeFullName);
		 System.out.println("");
		 System.out.println(" New User Default Role: " + yellowfinRole);
		 System.out.println("");
		 System.out.println(" User Auto Provision: " + autoprovisionUsers);
		 System.out.println("");
		 System.out.println("==================================================");
		 
		 if (yellowfinWebservicesURL==null || yellowfinWebservicesUsername == null || yellowfinWebservicesPassword == null ) throw new ServletException("Webservice Parameters Not Set");
		 if (autoprovisionUsers && yellowfinRole==null ) throw new ServletException("Yellowfin Role Not Set");  
		 
	 }
	
}
