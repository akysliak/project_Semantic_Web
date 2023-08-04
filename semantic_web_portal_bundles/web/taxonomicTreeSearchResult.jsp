<%-- 
    Document   : taxonomicTreeSearchResult
    Created on : 24.02.2019, 14:03:56
    Author     : Anastasiia Kysliak
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import= "java.util.LinkedList" %>
<%@page import= "mswQuery.*" %>
<%@page import= "gui.*" %>
<%@page import="mswQuery.MSWQuery"%>

<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : 'en'}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="<%= LSDR_Srcs.GUI_DATA %>" />
<fmt:setBundle basename="<%= LSDR_Srcs.ONTOLOGY_LABELS %>" var = "labels" scope = "session"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <title>${IndianBioDiversityPortal}</title>
    </head>
    <body>
        <link href="styleshit.css" rel="stylesheet" type="text/css">
        <fmt:message key="SearchResults" var="SearchResults" />
        <h1>${SearchResults}</h1>
        <form>
            <input name ="return" type ="submit" value = '<fmt:message key= "return" />' onclick="form.action='searchInTaxTree.jsp';">
        </form>
        <br/>
        <form>
            <c:if test = "${empty res_taxTree_names}">
                <label style="width: 10em; color: #F00"><fmt:message key= "No_results_found" /></label>
            </c:if>
            <div style="height:300px;overflow:auto;">
                <c:forEach items="${res_taxTree_names}" var = "res_name" >
                    <form>
                        <br/>
                        <%
                            String res_name = (String)pageContext.findAttribute("res_name");
                            DetailedResultsList res_taxTree_infFound = (DetailedResultsList)session.getAttribute("res_taxTree_infFound");
                            String hide_res_name = "hide_" + res_name;
                            boolean show_detailed_result = false;
                            SearchResult res_taxTree_detailed = null;
                            if(request.getParameter(res_name) != null){
                                res_taxTree_detailed = res_taxTree_infFound.getResult(res_name);
                                show_detailed_result = true;
                                res_taxTree_detailed.setShow(show_detailed_result);
                            }
                            else if(request.getParameter(hide_res_name) != null) {
                                res_taxTree_detailed = res_taxTree_infFound.getResult(res_name);
                                show_detailed_result = false;
                                res_taxTree_detailed.setShow(show_detailed_result);
                            }
                            else if(res_taxTree_infFound.informationAvailable(res_name)) {
                                res_taxTree_detailed = res_taxTree_infFound.getResult(res_name);
                                show_detailed_result = res_taxTree_detailed.getShow();
                            }
                        %>
                        <c:choose>
                            <c:when test= "<%= show_detailed_result %>" >
                                <h3><fmt:message key= "${res_name}" bundle="${labels}" /></h3>
                                <table>
                                    <tbody>
                                        <c:forEach items="<%= Properties.getProperties() %>" var = "prop" >
                                            <tr>
                                                <td style="width: 10em;"><fmt:message key= "${prop}" bundle="${labels}" /></td>
                                                <td>
                                                    <c:set var ="res_values" value= '<%= res_taxTree_detailed.getSearchResult().get((String)pageContext.findAttribute("prop")) %>'/>
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
                            <input name ="hide_${res_name}" type ="submit" value = "<fmt:message key= "hide_result" />" style="float: right;" >
                            </c:when>
                            <c:otherwise>
                                <input name ="${res_name}" type ="submit" value = "<fmt:message key= "${res_name}" bundle = "${labels}" />">
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:forEach>
            </div>
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
