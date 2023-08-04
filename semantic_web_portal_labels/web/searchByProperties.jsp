<%--
    Document   : SearchByProperty
    Created on : 28.08.2018, 12:31:13
    Author     : Anastasiia Kysliak
--%>

<%@page import="gui.SearchResult"%>
<%@page import="gui.DetailedResultsList"%>
<%@page import="gui.Properties"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import= "java.util.LinkedList" %>
<%@page import= "mswQuery.*" %>
<%@page import= "gui.LSDR_Srcs" %>
<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : 'en'}" scope="session" />
<fmt:setLocale value="${language}" />
<% MSWQuery.setLocale((String)pageContext.findAttribute("language")); %>
<fmt:setBundle basename="<%= LSDR_Srcs.GUI_DATA %>" />

<c:if test="${empty properties}">
    <c:set var="properties" value= "<%= MSWQuery.getPropertiesList() %>" scope="session" />
</c:if>
<c:set var="prev_property" value="${not empty property? property : ''}" scope="session" />
<c:set var="property" value="${not empty param.property? param.property : not empty property? property : properties.getFirst()}" scope="session" />
<c:set var="propertyChanged" value='${prev_property != property}' />
<c:if test ="${empty values || propertyChanged}">
    <c:set var="values" value="<%= MSWQuery.getValuesList((String)pageContext.findAttribute("property")) %>" scope="session" />
</c:if>
<c:set var="value" value="${propertyChanged || empty value? values.getFirst() : not empty param.value? param.value : value}" scope="session" />

<c:set var ="show_results_prop" value= '${not empty param.search? true: not empty show_results_prop? show_results_prop : false}' scope = "session" />

<c:choose>
    <c:when test="${not empty param.search}">
        <c:set var ="res_prop_names" value= '<%= MSWQuery.searchByPropertyValue((String)pageContext.findAttribute("property"), (String)pageContext.findAttribute("value")) %>' scope = "session" />
        <c:set var ="res_prop_infFound" value= '<%= new DetailedResultsList() %>' scope = "session" />
    </c:when>
    <c:otherwise>
        <c:if test = "${empty res_prop_infFound}" >
            <c:set var ="res_prop_infFound" value= '<%= new DetailedResultsList() %>' scope = "session" />
        </c:if>
    </c:otherwise>
</c:choose>
<%
    DetailedResultsList res_prop_infFound = (DetailedResultsList)pageContext.findAttribute("res_prop_infFound");
%>

<!DOCTYPE html>

<html lang="${language}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <title>${IndianBioDiversityPortal}</title>
    </head>
    <body>
        <link href="styleshit.css" rel="stylesheet" type="text/css">
        <fmt:message key="SearchByProperties" var="SearchByProperties" />
        <h1>${SearchByProperties}</h1>
        <form name="startForm" action="searchByProperties" method="post">
            <fmt:message key="Home" var="Home" />
            <fmt:message key="ByScientificName" var="ByScientificName" />
            <fmt:message key="InTaxTree" var="InTaxTree" />
            <input type="submit" value=${Home} onclick="form.action='index.jsp';">
            <input type="submit" value=${ByScientificName} onclick="form.action='searchByScientificName.jsp';">
            <input type="submit" value=${InTaxTree} onclick="form.action='searchInTaxTree.jsp';">
        </form>
        <form>
            <table>
                <tbody>
                    <tr>
                        <td><fmt:message key="ChooseProperty" /></td>
                        <td>
                            <select id="property" name="property" style="width: 20em;" onchange= "submit()">
                                <c:forEach items="${properties}" var = "prop" >
                                    <option value="${prop}" ${property == prop ? 'selected' : ''}>
                                        <%= MSWQuery.getLabel((String)pageContext.findAttribute("prop")) %>
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="ChooseValueName"/></td>
                        <td>
                            <select id="value" name="value" style="width: 20em;" onchange= "submit()">
                                <c:forEach items="${values}" var = "val" >
                                    <option value="${val}" ${value == val? 'selected' : ''}>
                                        <%= MSWQuery.getLabel((String)pageContext.findAttribute("val")) %>
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
        <form>
            <input name ="search" type ="submit" value = "<fmt:message key= "Search" />">
        </form>
        <c:if test="${show_results_prop}">
            <fmt:message key="hide_result" var="hide_result" />
            <form>
                <div style="height:250px;overflow:auto;">
                    <% LinkedList<String> res_prop = (LinkedList<String>)pageContext.findAttribute("res_prop_names"); %>
                    <c:forEach items="${res_prop_names}" var = "res_name" >
                        <form>
                            <br/>
                            <%
                                String res_name = (String)pageContext.findAttribute("res_name");
                                String hide_res_name = "hide_" + res_name;
                                boolean show_detailed_result = false;
                                SearchResult res_prop_detailed = null;
                                if(request.getParameter(res_name) != null){
                                    res_prop_detailed = res_prop_infFound.getResult(res_name);
                                    show_detailed_result = true;
                                    res_prop_detailed.setShow(show_detailed_result);
                                }
                                else if (request.getParameter(hide_res_name) != null) {
                                    res_prop_detailed = res_prop_infFound.getResult(res_name);
                                    show_detailed_result = false;
                                    res_prop_detailed.setShow(show_detailed_result);
                                }
                                else if(res_prop_infFound.informationAvailable(res_name)) {
                                    res_prop_detailed = res_prop_infFound.getResult(res_name);
                                    show_detailed_result = res_prop_detailed.getShow();
                                }
                            %>
                            <c:choose>
                                <c:when test= "<%= show_detailed_result %>" >
                                    <h3><%= MSWQuery.getLabel((String)pageContext.findAttribute("res_name")) %></h3>
                                    <table>
                                        <tbody>
                                            <c:forEach items="<%= Properties.getProperties() %>" var = "prop" >
                                                <tr>
                                                    <td style="width: 10em;"><%= MSWQuery.getLabel((String)pageContext.findAttribute("prop")) %></td>
                                                    <td>
                                                        <c:set var ="res_values" value= '<%= res_prop_detailed.getSearchResult().get((String)pageContext.findAttribute("prop")) %>'/>
                                                        <c:set var ="separater" value= ''/>
                                                        <c:forEach items="${res_values}" var = "res_value" >
                                                            ${separater}
                                                            <%= MSWQuery.getLabel((String)pageContext.findAttribute("res_value")) %>
                                                            <c:set var ="separater" value= ','/>
                                                        </c:forEach>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                <input name ="hide_${res_name}" type ="submit" value = "${hide_result}" style="float: right;" >
                                </c:when>
                                <c:otherwise>
                                    <input name ="${res_name}" type ="submit" value = "<%= MSWQuery.getLabel((String)pageContext.findAttribute("res_name")) %>">
                                </c:otherwise>
                        </c:choose>
                        </form>
                    </c:forEach>
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
