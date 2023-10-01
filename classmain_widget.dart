import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/backend/api_requests/api_calls.dart';
import '/components/dropdownlang_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'classmain_model.dart';
import 'package:http/http.dart' as http;
export 'classmain_model.dart';

class ClassmainWidget extends StatefulWidget {
  const ClassmainWidget({
    Key? key,
    required this.classid,
  }) : super(key: key);

  final int? classid;

  @override
  _ClassmainWidgetState createState() => _ClassmainWidgetState();
}

String removeBrackets(String inputString) {
  // 대괄호 제거
  String resultString = inputString.replaceAll(RegExp(r'[\[\]]'), '');
  return resultString;
}

class _ClassmainWidgetState extends State<ClassmainWidget> {
  late ClassmainModel _model;
  String attendanceType = '';
  String checkstdid = "";
  String checkstdname = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClassmainModel());

    FFAppState().update(() {
      FFAppState().classid = widget.classid!;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<String> callAPI(String date, int ids) async {
    var url1 = Uri.parse(
      'https://dq09qtwexsof0.cloudfront.net/churros/students/attendance/classroom/' +
          FFAppState().classid.toString() +
          '/date/' +
          date,
    );
    print("=====" + url1.toString());
    var response = await http.get(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
    );
    print('call: ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> responseList = jsonDecode(response.body);
      print('Parsed API Response: $responseList');

      // Filter by studentId 7
      List<dynamic> filteredList =
          responseList.where((item) => item['studentId'] == ids).toList();
      print('After filtering by studentId : $filteredList');

      // Sort by 'id' in descending order
      filteredList.sort((a, b) => b['id'].compareTo(a['id']));
      print('After sorting by ID in descending order: $filteredList');

      if (filteredList.isNotEmpty) {
        int studentId = filteredList[0]['studentId'];
        attendanceType = filteredList[0]['attendanceType'];

        print('Student ID: $studentId');
        print('Attendance Type: $attendanceType');
        return attendanceType;
      } else {
        print('No data found for studentId 7');
      }
    }
    return "errer";
  }

  Future<Color> setatt(String date, String id) async {
    var idd = int.parse(id);
    await callAPI(date, idd); // 'await'를 사용하여 callAPI가 완료될 때까지 기다립니다.

    print('========' + attendanceType.toString());
    if (attendanceType == 'in') {
      return Color(0xFF00C75B);
    } else {
      return Color(0xFFC8C8C8);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    var now = new DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd').format(now);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 왼쪽 이미지 추가
                    Image.asset(
                      'assets/images/ijul.png', // 이미지 경로
                      width: 50, // 원하는 너비
                      height: 50, // 원하는 높이
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.85,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: FutureBuilder<ApiCallResponse>(
                        future: DetailclassCall.call(widget.classid),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          final columnDetailclassResponse = snapshot.data!;
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 130, 0, 80),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('HomePage');
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Image.asset(
                                            'assets/images/churros_logo.png',
                                            width: 300,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //ok
                                    Container(
                                      width: 160,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.chat_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24,
                                          ),
                                          Icon(
                                            Icons.perm_identity,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24,
                                          ),
                                          Icon(
                                            Icons.notifications_none,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24,
                                          ),
                                          if (FFAppState().lang == 'kor')
                                            Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showAlignedDialog(
                                                    context: context,
                                                    isGlobal: true,
                                                    avoidOverflow: false,
                                                    targetAnchor:
                                                        AlignmentDirectional(
                                                                0, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    followerAnchor:
                                                        AlignmentDirectional(
                                                                0.6, -0.6)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    builder: (dialogContext) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: GestureDetector(
                                                          onTap: () => _model
                                                                  .unfocusNode
                                                                  .canRequestFocus
                                                              ? FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      _model
                                                                          .unfocusNode)
                                                              : FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Container(
                                                            height: 140,
                                                            width: 180,
                                                            child:
                                                                DropdownlangWidget(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      setState(() {}));
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                    ),
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/kor.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (FFAppState().lang == 'eng')
                                            Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showAlignedDialog(
                                                    context: context,
                                                    isGlobal: true,
                                                    avoidOverflow: false,
                                                    targetAnchor:
                                                        AlignmentDirectional(
                                                                0, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    followerAnchor:
                                                        AlignmentDirectional(
                                                                0.6, -0.6)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    builder: (dialogContext) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: GestureDetector(
                                                          onTap: () => _model
                                                                  .unfocusNode
                                                                  .canRequestFocus
                                                              ? FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      _model
                                                                          .unfocusNode)
                                                              : FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Container(
                                                            height: 140,
                                                            width: 180,
                                                            child:
                                                                DropdownlangWidget(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      setState(() {}));
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                    ),
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/eng.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (FFAppState().lang == 'mong')
                                            Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showAlignedDialog(
                                                    context: context,
                                                    isGlobal: true,
                                                    avoidOverflow: false,
                                                    targetAnchor:
                                                        AlignmentDirectional(
                                                                0, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    followerAnchor:
                                                        AlignmentDirectional(
                                                                0.6, -0.6)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    builder: (dialogContext) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: GestureDetector(
                                                          onTap: () => _model
                                                                  .unfocusNode
                                                                  .canRequestFocus
                                                              ? FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      _model
                                                                          .unfocusNode)
                                                              : FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Container(
                                                            height: 140,
                                                            width: 180,
                                                            child:
                                                                DropdownlangWidget(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      setState(() {}));
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                    ),
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/mong.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 40),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 20,
                                                    borderWidth: 1,
                                                    buttonSize: 40,
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_left,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 24,
                                                    ),
                                                    onPressed: () async {
                                                      context.safePop();
                                                    },
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: removeBrackets(
                                                              DetailclassCall
                                                                  .schoolName(
                                                            columnDetailclassResponse
                                                                .jsonBody,
                                                          ).toString()),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: removeBrackets(
                                                              DetailclassCall
                                                                  .className(
                                                            columnDetailclassResponse
                                                                .jsonBody,
                                                          ).toString()),
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 32,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 10, 0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        context.pushNamed(
                                                            'attendance');
                                                      },
                                                      text: FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '9cnld9pq' /* 출석 확인하기 */,
                                                      ),
                                                      options: FFButtonOptions(
                                                        height: 40,
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(24, 0,
                                                                    24, 0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 0),
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily),
                                                                ),
                                                        elevation: 1,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                  // FFButtonWidget(
                                                  //   onPressed: () {
                                                  //     print('Button pressed ...');
                                                  //   },
                                                  //   text: FFLocalizations.of(context)
                                                  //       .getText(
                                                  //     'sof1rtx9' /* 학생 관리하기 */,
                                                  //   ),
                                                  //   options: FFButtonOptions(
                                                  //     height: 40,
                                                  //     padding: EdgeInsetsDirectional
                                                  //         .fromSTEB(24, 0, 24, 0),
                                                  //     iconPadding: EdgeInsetsDirectional
                                                  //         .fromSTEB(0, 0, 0, 0),
                                                  //     color:
                                                  //         FlutterFlowTheme.of(context)
                                                  //             .primaryBackground,
                                                  //     textStyle:
                                                  //         FlutterFlowTheme.of(context)
                                                  //             .titleSmall
                                                  //             .override(
                                                  //               fontFamily:
                                                  //                   FlutterFlowTheme.of(
                                                  //                           context)
                                                  //                       .titleSmallFamily,
                                                  //               color:
                                                  //                   FlutterFlowTheme.of(
                                                  //                           context)
                                                  //                       .primary,
                                                  //               useGoogleFonts: GoogleFonts
                                                  //                       .asMap()
                                                  //                   .containsKey(
                                                  //                       FlutterFlowTheme.of(
                                                  //                               context)
                                                  //                           .titleSmallFamily),
                                                  //             ),
                                                  //     elevation: 1,
                                                  //     borderSide: BorderSide(
                                                  //       color: Colors.transparent,
                                                  //       width: 1,
                                                  //     ),
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(8),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFF6E5),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 24, 24, 24),
                                          child: AutoSizeText(
                                            removeBrackets(
                                                DetailclassCall.description(
                                              columnDetailclassResponse
                                                  .jsonBody,
                                            ).toString()),
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: Color(0xFFFF6F27),
                                                  fontSize: 18,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily),
                                                ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Wrap(
                                              spacing: 30,
                                              runSpacing: 30,
                                              alignment: WrapAlignment.center,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              runAlignment: WrapAlignment.start,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              clipBehavior: Clip.none,
                                              children: [
                                                // Generated code for this Container Widget...
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    width: 380,
                                                    height: 452,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(20, 24,
                                                                  20, 28),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            12,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFFFFE9E9),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            6,
                                                                            6,
                                                                            6,
                                                                            6),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/eva_clock-outline.png',
                                                                        width:
                                                                            28,
                                                                        height:
                                                                            28,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  '5d8inm0a' /* 시간표 */,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'pretendard',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      20,
                                                                  borderWidth:
                                                                      1,
                                                                  buttonSize:
                                                                      40,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 24,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    context.pushNamed(
                                                                        'timetable');
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 48,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          24,
                                                                          16,
                                                                          24,
                                                                          0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.00,
                                                                              0.00),
                                                                          child:
                                                                              Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              'l2hjv4gp' /* 월 */,
                                                                            ),
                                                                            style:
                                                                                FlutterFlowTheme.of(context).bodyMedium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.00,
                                                                              0.00),
                                                                          child:
                                                                              Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              '8swi3pjk' /* 화 */,
                                                                            ),
                                                                            style:
                                                                                FlutterFlowTheme.of(context).bodyMedium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.00,
                                                                            0.00),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'lie740sd' /* 수 */,
                                                                          ),
                                                                          style:
                                                                              FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.00,
                                                                            0.00),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'qvh9040p' /* 목 */,
                                                                          ),
                                                                          style:
                                                                              FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.00,
                                                                            0.00),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'ysmidn2q' /* 금 */,
                                                                          ),
                                                                          style:
                                                                              FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            24,
                                                                            0,
                                                                            24,
                                                                            24),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  '0lb5b45q' /* 1교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'lcfqnpbj' /* 2교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'uwc4naep' /* 3교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'iz135bum' /* 4교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'ocfd3k7x' /*5교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                48,
                                                                            height:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.00, 0.00),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'f5c22ugl' /* 6교시 */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Expanded(
                                                                      child: FutureBuilder<
                                                                          ApiCallResponse>(
                                                                        future:
                                                                            getTime.call(FFAppState().classid),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Center(
                                                                              child: SizedBox(
                                                                                width: 50,
                                                                                height: 50,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    FlutterFlowTheme.of(context).primary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final gridViewGetclassResponse =
                                                                              snapshot.data!;
                                                                          return Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final timelist = getJsonField(
                                                                                gridViewGetclassResponse.jsonBody,
                                                                                r'''$[*]''',
                                                                              ).toList();
                                                                              timelist.sort((a, b) {
                                                                                final idA = a['id'] as int;
                                                                                final idB = b['id'] as int;
                                                                                return idA.compareTo(idB);
                                                                              });
                                                                              return GridView.builder(
                                                                                padding: EdgeInsets.zero,
                                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                  crossAxisCount: 6,
                                                                                  mainAxisSpacing: 0,
                                                                                  childAspectRatio: 1,
                                                                                ),
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemCount: timelist.length,
                                                                                itemBuilder: (context, timelistIndex) {
                                                                                  final timelistItem = timelist[timelistIndex];
                                                                                  return Container(
                                                                                    width: 100,
                                                                                    height: 100,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Align(
                                                                                      alignment: AlignmentDirectional(0.00, 0.00),
                                                                                      child: Text(
                                                                                        (getTime.subject(timelist) as List).map<String>((s) => s.toString()).toList()[timelistIndex],
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    width: 380,
                                                    height: 452,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(24, 24,
                                                                  24, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        20),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          12,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFE1EDFF),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              6,
                                                                              6,
                                                                              6,
                                                                              6),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/eva_bell-outline.png',
                                                                          width:
                                                                              24,
                                                                          height:
                                                                              24,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'lf0f4hsx' /* 알림장 */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'pretendard',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        20,
                                                                    borderWidth:
                                                                        1,
                                                                    buttonSize:
                                                                        40,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 24,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      context.pushNamed(
                                                                          'notice');
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: FutureBuilder<
                                                                ApiCallResponse>(
                                                              future: NoticeCall
                                                                  .call(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                // Customize what your widget looks like when it's loading.
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Center(
                                                                    child:
                                                                        SizedBox(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                final listViewNoticeCallResponse =
                                                                    snapshot
                                                                        .data!;
                                                                return Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (listViewNoticeCallResponse
                                                                            .jsonBody
                                                                            .toString() ==
                                                                        '[]') {
                                                                      return Container();
                                                                    }

                                                                    final class1 =
                                                                        getJsonField(
                                                                      listViewNoticeCallResponse
                                                                          .jsonBody,
                                                                      r'''$[:]''',
                                                                    ).toString();
                                                                    int count =
                                                                        0;

                                                                    for (int i =
                                                                            0;
                                                                        i < class1.length;
                                                                        i++) {
                                                                      if (class1[
                                                                              i] ==
                                                                          '{') {
                                                                        count++;
                                                                      }
                                                                    }

                                                                    if (count ==
                                                                        1) {
                                                                      return ListView
                                                                          .builder(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        itemCount:
                                                                            1,
                                                                        itemBuilder:
                                                                            (context,
                                                                                noticelistIndex) {
                                                                          return Card(
                                                                            clipBehavior:
                                                                                Clip.antiAliasWithSaveLayer,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            elevation:
                                                                                4,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                    child: Text(
                                                                                      (NoticeCall.publishedDate(
                                                                                        listViewNoticeCallResponse.jsonBody,
                                                                                      ) as List)
                                                                                          .map<String>((s) => s.toString())
                                                                                          .toList()[noticelistIndex],
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FlutterFlowTheme.of(context).secondary,
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                    child: Text(
                                                                                      (NoticeCall.contents(
                                                                                        listViewNoticeCallResponse.jsonBody,
                                                                                      ) as List)
                                                                                          .map<String>((s) => s.toString())
                                                                                          .toList()[noticelistIndex],
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }

                                                                    final noticelist =
                                                                        getJsonField(
                                                                      listViewNoticeCallResponse
                                                                          .jsonBody,
                                                                      r'''$[*]''',
                                                                    ).toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          noticelist
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              noticelistIndex) {
                                                                        final noticelistItem =
                                                                            noticelist[noticelistIndex];
                                                                        return Card(
                                                                          clipBehavior:
                                                                              Clip.antiAliasWithSaveLayer,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          elevation:
                                                                              4,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16,
                                                                                16,
                                                                                16,
                                                                                16),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                  child: Text(
                                                                                    (NoticeCall.publishedDate(
                                                                                      listViewNoticeCallResponse.jsonBody,
                                                                                    ) as List)
                                                                                        .map<String>((s) => s.toString())
                                                                                        .toList()[noticelistIndex],
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).secondary,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                  child: Text(
                                                                                    (NoticeCall.contents(
                                                                                      listViewNoticeCallResponse.jsonBody,
                                                                                    ) as List)
                                                                                        .map<String>((s) => s.toString())
                                                                                        .toList()[noticelistIndex],
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    width: 380,
                                                    height: 452,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(24, 24,
                                                                  24, 28),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            12,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFFE3F6EC),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            7,
                                                                            8,
                                                                            7),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/evaCalendarOutline0.png',
                                                                        width:
                                                                            24,
                                                                        height:
                                                                            24,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  '3p1oq10r' /* 캘린더 */,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'pretendard',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      20,
                                                                  borderWidth:
                                                                      1,
                                                                  buttonSize:
                                                                      40,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 24,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    context.pushNamed(
                                                                        'createcalender');
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          FlutterFlowCalendar(
                                                            color: Color(
                                                                0xFF00C75B),
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            weekFormat: false,
                                                            weekStartsMonday:
                                                                false,
                                                            rowHeight: 40,
                                                            onChange:
                                                                (DateTimeRange?
                                                                    newSelectedDate) {
                                                              setState(() => _model
                                                                      .calendarSelectedDay =
                                                                  newSelectedDate);
                                                            },
                                                            titleStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall,
                                                            dayOfWeekStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                            dateStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium,
                                                            selectedDateStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall,
                                                            inactiveDateStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    width: 380,
                                                    height: 452,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(24, 24,
                                                                  24, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        26),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          12,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFFFE9E9),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              6,
                                                                              6,
                                                                              6,
                                                                              6),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/eva_clock-outline.png',
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'nsejnn27' /* 가정 통신문 */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'pretendard',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        20,
                                                                    borderWidth:
                                                                        1,
                                                                    buttonSize:
                                                                        40,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 24,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      context.pushNamed(
                                                                          'newsletter');
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: FutureBuilder<
                                                                ApiCallResponse>(
                                                              future: Newscall
                                                                  .call(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                // Customize what your widget looks like when it's loading.
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Center(
                                                                    child:
                                                                        SizedBox(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                final listViewnewsCallResponse =
                                                                    snapshot
                                                                        .data!;

                                                                return Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (listViewnewsCallResponse
                                                                            .jsonBody
                                                                            .toString() ==
                                                                        '[]') {
                                                                      return Container();
                                                                    }

                                                                    final class1 =
                                                                        getJsonField(
                                                                      listViewnewsCallResponse
                                                                          .jsonBody,
                                                                      r'''$[:]''',
                                                                    ).toString();
                                                                    int count =
                                                                        0;

                                                                    for (int i =
                                                                            0;
                                                                        i < class1.length;
                                                                        i++) {
                                                                      if (class1[
                                                                              i] ==
                                                                          '{') {
                                                                        count++;
                                                                      }
                                                                    }

                                                                    if (count ==
                                                                        1) {
                                                                      return ListView
                                                                          .builder(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        itemCount:
                                                                            1,
                                                                        itemBuilder:
                                                                            (context,
                                                                                noticelistIndex) {
                                                                          return Card(
                                                                            clipBehavior:
                                                                                Clip.antiAliasWithSaveLayer,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            elevation:
                                                                                4,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                    child: Text(
                                                                                      (Newscall.title(
                                                                                        listViewnewsCallResponse.jsonBody,
                                                                                      ) as List)
                                                                                          .map<String>((s) => s.toString())
                                                                                          .toList()[noticelistIndex],
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FlutterFlowTheme.of(context).secondary,
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                    child: Text(
                                                                                      (Newscall.contents(
                                                                                        listViewnewsCallResponse.jsonBody,
                                                                                      ) as List)
                                                                                          .map<String>((s) => s.toString())
                                                                                          .toList()[noticelistIndex],
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }

                                                                    final noticelist =
                                                                        getJsonField(
                                                                      listViewnewsCallResponse
                                                                          .jsonBody,
                                                                      r'''$[*]''',
                                                                    ).toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          noticelist
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              noticelistIndex) {
                                                                        final noticelistItem =
                                                                            noticelist[noticelistIndex];
                                                                        return Card(
                                                                          clipBehavior:
                                                                              Clip.antiAliasWithSaveLayer,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          elevation:
                                                                              4,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16,
                                                                                16,
                                                                                16,
                                                                                16),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                  child: Text(
                                                                                    (Newscall.title(
                                                                                      listViewnewsCallResponse.jsonBody,
                                                                                    ) as List)
                                                                                        .map<String>((s) => s.toString())
                                                                                        .toList()[noticelistIndex],
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).secondary,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                  child: Text(
                                                                                    (Newscall.contents(
                                                                                      listViewnewsCallResponse.jsonBody,
                                                                                    ) as List)
                                                                                        .map<String>((s) => s.toString())
                                                                                        .toList()[noticelistIndex],
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    width: 380,
                                                    height: 452,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(24, 24,
                                                                  24, 24),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        20),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          12,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFFFE9E9),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10,
                                                                              8,
                                                                              10,
                                                                              8),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/evaPersonOutline0.png',
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              18,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'y1t003uk' /* 학생들 정보 */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'pretendard',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        20,
                                                                    borderWidth:
                                                                        1,
                                                                    buttonSize:
                                                                        40,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 24,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          'IconButton pressed ...');
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                              child: FutureBuilder<
                                                                  ApiCallResponse>(
                                                                future: getstudent.call(
                                                                    FFAppState()
                                                                        .classid),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  final wrapGetstudentResponse =
                                                                      snapshot
                                                                          .data!;
                                                                  return Builder(
                                                                    builder:
                                                                        (context) {
                                                                      if (wrapGetstudentResponse
                                                                              .jsonBody
                                                                              .toString() ==
                                                                          '[]') {
                                                                        return Container();
                                                                      }

                                                                      final class1 =
                                                                          getJsonField(
                                                                        wrapGetstudentResponse
                                                                            .jsonBody,
                                                                        r'''$[:]''',
                                                                      ).toString();
                                                                      int count =
                                                                          0;

                                                                      for (int i =
                                                                              0;
                                                                          i < class1.length;
                                                                          i++) {
                                                                        if (class1[i] ==
                                                                            '{') {
                                                                          count++;
                                                                        }
                                                                      }

                                                                      if (count <=
                                                                          4) {
                                                                        print(
                                                                            1111);

                                                                        final noticelist =
                                                                            getJsonField(
                                                                          wrapGetstudentResponse
                                                                              .jsonBody,
                                                                          r'''$[0]''',
                                                                          true,
                                                                        ).toList();
                                                                        return Wrap(
                                                                            spacing:
                                                                                10,
                                                                            runSpacing:
                                                                                10,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                            direction: Axis.horizontal,
                                                                            runAlignment: WrapAlignment.start,
                                                                            verticalDirection: VerticalDirection.down,
                                                                            clipBehavior: Clip.none,
                                                                            children: List.generate(
                                                                              noticelist.length,
                                                                              (noticelistIndex) {
                                                                                final noticelistItem = noticelist[noticelistIndex];

                                                                                return InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {},
                                                                                  child: Material(
                                                                                    color: Colors.transparent,
                                                                                    elevation: 0,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: FutureBuilder<Color>(
                                                                                      future: setatt(
                                                                                        formatDate,
                                                                                        (getstudent.id(
                                                                                          wrapGetstudentResponse.jsonBody,
                                                                                        ) as List)
                                                                                            .map<String>((s) => s.toString())
                                                                                            .toList()[noticelistIndex],
                                                                                      ),
                                                                                      builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                                                                                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                                                                          return Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 70,
                                                                                                height: 30,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.white,
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                                                                                  child: Column(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      Align(
                                                                                                        alignment: AlignmentDirectional(0.00, 0.00),
                                                                                                        child: Text(
                                                                                                          (getstudent.name(
                                                                                                            wrapGetstudentResponse.jsonBody,
                                                                                                          ) as List)
                                                                                                              .map<String>((s) => s.toString())
                                                                                                              .toList()[noticelistIndex],
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                color: FlutterFlowTheme.of(context).tertiary,
                                                                                                                fontSize: 14,
                                                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                                                                child: Icon(
                                                                                                  Icons.circle_sharp,
                                                                                                  color: snapshot.data!,
                                                                                                  size: 10,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        } else {
                                                                                          // Loading state or error state. You can adjust this part based on your needs.
                                                                                          return Container(
                                                                                            width: 70,
                                                                                            height: 30,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.white,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: AlignmentDirectional(0.00, 0.00),
                                                                                                    child: Text(
                                                                                                      (getstudent.name(
                                                                                                        wrapGetstudentResponse.jsonBody,
                                                                                                      ) as List)
                                                                                                          .map<String>((s) => s.toString())
                                                                                                          .toList()[noticelistIndex],
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).tertiary,
                                                                                                            fontSize: 14,
                                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ));
                                                                      }

                                                                      final noticelist =
                                                                          getJsonField(
                                                                        wrapGetstudentResponse
                                                                            .jsonBody,
                                                                        r'''$[*]''',
                                                                      ).toList();

                                                                      return Wrap(
                                                                          spacing:
                                                                              10,
                                                                          runSpacing:
                                                                              10,
                                                                          alignment: WrapAlignment
                                                                              .start,
                                                                          crossAxisAlignment: WrapCrossAlignment
                                                                              .start,
                                                                          direction: Axis
                                                                              .horizontal,
                                                                          runAlignment: WrapAlignment
                                                                              .start,
                                                                          verticalDirection: VerticalDirection
                                                                              .down,
                                                                          clipBehavior: Clip
                                                                              .none,
                                                                          children:
                                                                              List.generate(
                                                                            noticelist.length,
                                                                            (noticelistIndex) {
                                                                              final noticelistItem = noticelist[noticelistIndex];

                                                                              return InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {},
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  elevation: 0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  child: FutureBuilder<Color>(
                                                                                    future: setatt(
                                                                                      formatDate,
                                                                                      (getstudent.id(
                                                                                        wrapGetstudentResponse.jsonBody,
                                                                                      ) as List)
                                                                                          .map<String>((s) => s.toString())
                                                                                          .toList()[noticelistIndex],
                                                                                    ),
                                                                                    builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                                                                                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                                                                        return Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Container(
                                                                                              width: 70,
                                                                                              height: 30,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.white,
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Align(
                                                                                                      alignment: AlignmentDirectional(0.00, 0.00),
                                                                                                      child: Text(
                                                                                                        (getstudent.name(
                                                                                                          wrapGetstudentResponse.jsonBody,
                                                                                                        ) as List)
                                                                                                            .map<String>((s) => s.toString())
                                                                                                            .toList()[noticelistIndex],
                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                              color: FlutterFlowTheme.of(context).tertiary,
                                                                                                              fontSize: 14,
                                                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                                                              child: Icon(
                                                                                                Icons.circle_sharp,
                                                                                                color: snapshot.data!,
                                                                                                size: 10,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      } else {
                                                                                        // Loading state or error state. You can adjust this part based on your needs.
                                                                                        return Container(
                                                                                          width: 70,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Align(
                                                                                                  alignment: AlignmentDirectional(0.00, 0.00),
                                                                                                  child: Text(
                                                                                                    (getstudent.name(
                                                                                                      wrapGetstudentResponse.jsonBody,
                                                                                                    ) as List)
                                                                                                        .map<String>((s) => s.toString())
                                                                                                        .toList()[noticelistIndex],
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                          color: FlutterFlowTheme.of(context).tertiary,
                                                                                                          fontSize: 14,
                                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ));
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ])),
        ),
      ),
    );
  }
}
