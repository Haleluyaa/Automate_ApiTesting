*** Settings ***
Library           Selenium2Library
Library           RequestsLibrary
Library           ExcelLibrary

*** Variables ***
&{Dic_element}    url=http://localhost:8099    headers=Content-Type=application/json

*** Test Cases ***
LiApiTest
    [Documentation]    Sample Test For Li Api
    [Tags]    post
    [Setup]
    [Timeout]
    Open Excel Current Directory    TestApiWebApp.xls
    @{sheet}    Get Sheet Names
    Comment    :FOR    ${sheet}    IN    @{sheetname}
    Log    @{sheet}
    ${row_count}    Get Row Count    @{sheet}
    : FOR    ${index}    IN RANGE    2    ${row_count}
    \    ${LI} =    Read Cell Data By Coordinates    @{sheet}    0    ${index}
    \    Create Session    LiApi    ${Dic_element.url}
    \    ${json} =    Evaluate    json.loads('''${LI}''')    json
    \    ${resp} =    Post Request    LiApi    /language    ${json}
    \    Log    ${resp.status_code}
    \    Log    ${resp.headers}
    \    Run Keyword If    "${resp.status_code}" == "400"    Should Contain    ${resp.text}    error
    \    Log    ${resp.text}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    Should Contain    ${resp.text}    language
    \    ${headers} =    Convert To String    ${resp.headers}
    \    Should Contain    ${headers}    application/json

TCCApiTest
    [Documentation]    Positive TCC Api Test
    Open Excel Current Directory    TestApiWebApp.xls
    @{sheet}    Get Sheet Names
    Comment    :FOR    ${sheet}    IN    @{sheetname}
    Log    @{sheet}
    ${row_count}    Get Row Count    @{sheet}
    :FOR    ${index}    IN RANGE    2    ${row_count}
    \    ${TCC} =    Read Cell Data By Coordinates    @{sheet}    1    ${index}
    \    Create Session    TCCApi    ${Dic_element.url}
    \    ${json} =    Evaluate    json.loads('''${TCC}''')    json
    \    ${resp} =    Post Request    TCCApi    /fragments    ${Dic_element.jsonString}    ${json}
    \    Log    ${resp.status_code}
    \    Log    ${resp.headers}
    \    Run Keyword If    "${resp.status_code}" == "400"    Should Contain    ${resp.text}    error
    \    Log    ${resp.text}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    Should Contain    ${resp.text}    language
    \    ${headers} =    Convert To String    ${resp.headers}
    \    Should Contain    ${headers}    application/json
