<%--
    Document   : searchByScientificName
    Created on : 28.08.2018, 12:32:07
    Author     : Anastasiia Kysliak
--%>

<%@page import="gui.Properties"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import= "java.util.LinkedList" %>
<%@page import= "mswQuery.*" %>
<%@page import= "gui.LSDR_Srcs" %>

<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : 'en'}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="<%= LSDR_Srcs.GUI_DATA %>" />
<fmt:setBundle basename="<%= LSDR_Srcs.ONTOLOGY_LABELS %>" var = "labels" scope = "session"/>

<c:set var="scientificNames" value= "<%= MSWQuery.getScientificNamesList() %>" scope="session" />
<c:set var="scientificName" value="${not empty param.scientificName? param.scientificName : not empty scientificName? scientificName : scientificNames.getFirst()}" scope="session" />
<c:set var ="show_results_scName" value= '${not empty param.search? true: not empty show_results_scName? show_results_scName : false}' scope = "session" />

<c:choose>
    <c:when test="${not empty param.search}">
        <c:set var ="res_scName" value= '<%= MSWQuery.searchByScientificName((String)pageContext.findAttribute("scientificName"), Properties.getProperties()) %>' scope = "session" />
    </c:when>
    <c:otherwise>
        <c:set var ="res_scName" value= '${res_scName}' scope = "session" />
    </c:otherwise>
</c:choose>

<!DOCTYPE html>

<html lang="${language}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <title>${IndianBioDiversityPortal}</title>
    </head>
    <body>
        <link href="styleshit.css" rel="stylesheet" type="text/css">
        <fmt:message key="SearchByScientificName" var="SearchByScientificName" />
        <h1>${SearchByScientificName}</h1>
        <form name="startForm" action="searchByScientificName" method="post">
            <fmt:message key="Home" var="Home" />
            <fmt:message key="ByProperties" var="ByProperties" />
            <fmt:message key="InTaxTree" var="InTaxTree" />
            <input type="submit" value=${Home} onclick="form.action='index.jsp';">
            <input type="submit" value=${ByProperties} onclick="form.action='searchByProperties.jsp';">
            <input type="submit" value=${InTaxTree} onclick="form.action='searchInTaxTree.jsp';">
        </form>
        <form>
            <label for="PleaseChooseScientificName"><fmt:message key="PleaseChooseScientificName" />:</label>
            <select id="scientificName" name="scientificName" onchange= "submit()">
                <c:forEach items="${scientificNames}" var = "scName" >
                    <option value="${scName}" ${scientificName == scName ? 'selected' : ''}><fmt:message key="${scName}" bundle="${labels}"/></option>
                </c:forEach>
            </select>
        </form>
        <form>
            <input name ="search" type ="submit" value = "<fmt:message key= "Search" />">
        </form>
        <c:if test="${show_results_scName}">
            <form>
                <h2><fmt:message key= '${res_scName.get("scientific_name").getFirst()}' bundle = "${labels}" /></h2>
                <div style="height:100px;overflow:auto;">
                    <% HashMap<String, LinkedList<String>> res_scName = (HashMap<String, LinkedList<String>>)pageContext.findAttribute("res_scName"); %>
                    <c:set var ="res_keys" value= '<%= res_scName.keySet() %>'/>
                    <table>
                        <tbody>
                            <c:forEach items="<%= Properties.getProperties() %>" var = "prop" >
                                <tr>
                                    <td style="width: 10em;"><fmt:message key= "${prop}" bundle="${labels}" /></td>
                                    <td>
                                        <c:set var ="res_values" value= '<%= res_scName.get((String)pageContext.findAttribute("prop")) %>'/>
                                        <c:set var ="separater" value= ''/>
                                        <c:forEach items="${res_values}" var = "res_value" >
                                            ${separater}
                                            <fmt:message key= "${res_value}" bundle="${labels}" />
                                            <c:set var ="separater" value= ','/>
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </form>
        </c:if>
        <form>
            <select id="language" name="language" onchange="submit()">
                <option value="en" ${language == 'en' ? 'selected' : ''}>English</option>
                <option value="de" ${language == 'de' ? 'selected' : ''}>Deutsch</option>
                <option value="ru" ${language == 'ru' ? 'selected' : ''}>Русский</option>
            </select>
        </form>
    </body>
</html>
