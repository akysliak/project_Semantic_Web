<%-- 
    Document   : index
    Created on : 28.08.2018, 04:18:51
    Author     : Anastasiia Kysliak
--%>
<%@page import="java.util.Date" %>
<%@page import="com.hp.hpl.jena.rdf.model.Model" %>
<%@page import="com.hp.hpl.jena.util.FileManager" %>
<%@page import="java.io.IOException" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import= "java.util.LinkedList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import= "gui.LSDR_Srcs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : 'en'}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename= "gui.gui_bundle" />
<!DOCTYPE html>

<html lang="${language}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <title>${IndianBioDiversityPortal}</title>
    </head>
    <body>
        <link href="styleshit.css" rel="stylesheet" type="text/css">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <h1>${IndianBioDiversityPortal}</h1>
        <form name="startForm" action="searchByScientificName" method="post">
            <fmt:message key="ByScientificName" var="ByScientificName" />
            <fmt:message key="ByProperties" var="ByProperties" />
            <fmt:message key="InTaxTree" var="InTaxTree" />
            <input type="submit" value=${ByScientificName} onclick="form.action='searchByScientificName.jsp';">
            <input type="submit" value=${ByProperties} onclick="form.action='searchByProperties.jsp';">
            <input type="submit" value=${InTaxTree} onclick="form.action='searchInTaxTree.jsp';">
        </form>
        <form>
            <select id="language" name="language" onchange="submit()">
                <option value="en" ${language == 'en' ? 'selected' : ''}>English</option>
                <option value="de" ${language == 'de' ? 'selected' : ''}>Deutsch</option>
                <option value="ru" ${language == 'ru' ? 'selected' : ''}>Русский</option>
            </select>
        </form>
    </body>
</html>
