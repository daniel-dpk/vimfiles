" Mel syntax file
" Language:     Mel (Maya Embedded Language)
" Maintainer:   Daniel Pook-Kolb <daniel@dpk.stargrav.com>
"
"
" You can tweak the highlighting with the following options.
"
" This will highlight spaces before tabs as errors.
"   let g:mel_space_tab_error = 1
"
" This will highlight trailing spaces as either errors, strings, or without
" special highlighting. Set this to one of the following values. The empty
" string means no special highlighting (default).
"   let g:mel_space_trailing = ''
"   let g:mel_space_trailing = 'String'
"   let g:mel_space_trailing = 'Error'
"
" Using this line, no error will be highlighted no matter whether the previous
" commands were used.
"   let g:mel_no_error = 1
"
" This will highlight command flags as strings.
"   let g:mel_flag_as_string = 1
"
"
" Note: If you're running a vim older than 6.3, you probably have the old mel
"       syntax file that doesn't check whether a syntax was loaded. In this
"       case, you have to remove (or rename) the old mel.vim syntax file!


" Preparations {{{1

" Initial Steps {{{2

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif


" InitOption {{{2
" Define a function for initializing options local to this file. It will
" ensure a local variable for the specified option exists. If the
" corresponding global variable exists, its value is used. Otherwise, a given
" default will be used.
function! s:fnInitOption( option, default )
    if !exists("g:mel_".a:option)
        " The global variable doesn't exist, so we create the local variable
        " and initialize it with the default value.
        let s:{a:option} = a:default
    else
        " The global variable exists, so we'll initialize the local variable
        " with its value.
        let s:{a:option} = g:mel_{a:option}
    endif
endfunction

" To allow convenient usage of this function, we'll create a temporary
" command for it.
command! -nargs=+ InitOption call s:fnInitOption(<f-args>)


" Parse/Initialize the options {{{2
InitOption space_tab_error 0
InitOption space_trailing  ''
InitOption no_error        0
InitOption flag_as_string  0

" }}}1


" Define the highlighting groups. {{{1

" Basic MEL Syntax {{{2
" Numbers
syn match   melInteger  "\<\d\+\>"
syn match   melFloat    "\<\d\+\([eE][-+]\?\d\+\)\?\>"
syn match   melFloat    "\<\d\+\.\d*\([eE][-+]\?\d\+\)\?\>"
syn match   melFloat    "\.\d\+\([eE][-+]\?\d\+\)\?\>"

" Variables
syn match   melVar      "\$\(\a\|_\)\w*"

" Flags
syn match   melFlag     "-\a[A-Za-z0-9]*"

" Special characters
syn match   melCharSpecial  contained "\\[ntr\.\\"]"

" Strings
syn match   melCharError    contained "\\[^ntr\.\\"]"
syn region  melString       start=+"+ skip=+\\"+ end=+"+ contains=melCharSpecial,melCharError

" Comments
syn region  melComment      start="/\*" end="\*/"   contains=@melCommentGroup
syn match   melComment      "//.*"                  contains=@melCommentGroup
syn match   melCommentError "\*/"

" Create a highlighting cluster for the comments, so that we can add further
" comment highlighting easily. The cluster has already been contained in
" melComment, so that the relationship is established.
syn cluster melCommentGroup contains=melComment


" Highlight spaces before tabs and mark trailing spaces.
syntax match    melSpaceTrailing    "\s\+$"
syntax match    melSpaceError       " \+\ze\t" containedin=melFoldOpen1,melFoldOpen2,melFoldOpen3
" Add them to the comment group so that its highlighted only within it.
syntax cluster  melCommentGroup add=melSpaceTrailing,melSpaceError


" Some special comment highlightings. {{{2
" Hide the fold marks.
syntax match    melFoldMarks    contained "{\{3}\d*$\|}\{3}\d*$"
syntax match    melFoldMarks    contained "^//\s*}\{3}\d*$"
syntax match    melFoldMarks    contained "\s\@<=//\s*}\{3}\d*$"
syntax cluster  melCommentGroup add=melFoldMarks

" Make the lines with an opening fold highlighted differently. The order in
" which we add these syntax items is important, as the last one matching is
" preferred.
syntax match    melFoldOpen3    contained "//.*\(\s{\{3}[3-9]\?$\)\@=" contains=melTODO,melNotes
syntax match    melFoldOpen1    contained "//.*\(\s{\{3}1$\)\@="       contains=melTODO,melNotes
syntax match    melFoldOpen2    contained "//.*\(\s{\{3}2$\)\@="       contains=melTODO,melNotes
syntax cluster  melCommentGroup add=melFoldOpen1,melFoldOpen2,melFoldOpen3

" Important lines are marked with an "<" at their end.
syntax match    melImportant    contained "//.*\(\s<$\)\@=" contains=melTODO,melNotes
syntax cluster  melCommentGroup add=melImportant
" Hide the "<" mark.
syntax match    melFoldMarks    contained "\s<$"

" Todo and mark comments.
syntax keyword  melTODO         contained TODO FIXME MARK
syntax cluster  melCommentGroup add=melTODO

" Comment notes.
syntax match    melNotes        contained "NOTE:\s\+"
syntax cluster  melCommentGroup add=melNotes

" }}}1


" Keyword highlighting {{{1
" Last updated: Jan 13, 2006

" melFunction {{{2
syntax keyword melFunction about abs addAttr addAttributeEditorNodeHelp addDynamic addNewShelfTab
syntax keyword melFunction addPP advanceToNextDrivenKey affectedNet affects aimConstraint air
syntax keyword melFunction alias aliasAttr align alignCtx alignCurve alignSurface allViewFit
syntax keyword melFunction ambientLight angle angleBetween animCone animCurveEditor animDisplay
syntax keyword melFunction animView annotate appendStringArray applicationName applyAttrPreset
syntax keyword melFunction applyTake arcLenDimContext arcLengthDimension arclen arrayMapper
syntax keyword melFunction art3dPaintCtx artAttrCtx artAttrPaintVertexCtx artBuildPaintMenu
syntax keyword melFunction artFluidAttrCtx artPuttyCtx artSelectCtx artSetPaintCtx
syntax keyword melFunction artUserPaintCtx assignCommand assignInputDevice attachCurve
syntax keyword melFunction attachDeviceAttr attachSurface attrColorSliderGrp attrCompatibility
syntax keyword melFunction attrControlGrp attrEnumOptionMenu attrEnumOptionMenuGrp attrFieldGrp
syntax keyword melFunction attrFieldSliderGrp attrNavigationControlGrp attrPresetEditWin
syntax keyword melFunction attributeExists attributeInfo attributeMenu attributeQuery
syntax keyword melFunction autoKeyframe autoPlace
syntax keyword melFunction acos acosh acosd asin asinh asind atan atan2 atanh atand atan2d

syntax keyword melFunction bakeClip bakeResults bakeSimulation basename basenameEx batchRender
syntax keyword melFunction bessel bevel bevelPlus binMembership bindPose bindSkin blend2
syntax keyword melFunction blendShape blendShapeEditor blendShapePanel blendTwoAttr blindDataType
syntax keyword melFunction boneLattice boundary boxDollyCtx boxZoomCtx bufferCurve
syntax keyword melFunction buildBookmarkMenu buildKeyframeMenu button buttonManip

syntax keyword melFunction CBG camera cameraView canCreateManip canvas capitalizeString
syntax keyword melFunction ceil changeSubdivComponentDisplayLevel changeSubdivRegion
syntax keyword melFunction channelBox character characterMap characterOutlineEditor chdir
syntax keyword melFunction checkBox checkBoxGrp checkDefaultRenderGlobals choice circle
syntax keyword melFunction circularFillet clamp clear clearCache clip clipEditor
syntax keyword melFunction clipEditorCurrentTimeCtx clipSchedule clipSchedulerOutliner
syntax keyword melFunction clipTrimBefore closeCurve closeSurface cluster cmdFileOutput cmdShell
syntax keyword melFunction coarsenSubdivSelectionList collision color colorAtPoint colorEditor
syntax keyword melFunction colorIndex colorIndexSliderGrp colorSliderButtonGrp colorSliderGrp
syntax keyword melFunction columnLayout commandEcho commandLine commandPort componentEditor
syntax keyword melFunction computePolysetVolume condition cone confirmDialog connectAttr
syntax keyword melFunction connectControl connectDynamic connectJoint connectionInfo constrain
syntax keyword melFunction constrainValue constructionHistory contextInfo control
syntax keyword melFunction convertFromOldLayers convertLightmap convertSolidTx
syntax keyword melFunction convertTessellation convertUnit copyArray copyFlexor copyKey
syntax keyword melFunction copySkinWeights cos cpButton cpCache cpCollision cpConstraint
syntax keyword melFunction cpGetSolverAttr cpPanel cpProperty cpSeam cpSetEdit cpSetSolverAttr
syntax keyword melFunction cpSolver cpTool createDisplayLayer createDrawCtx createEditor
syntax keyword melFunction createMotionField createNewShelf createNode createRenderLayer
syntax keyword melFunction createSubdivRegion cross crossProduct ctxAbort ctxCompletion
syntax keyword melFunction ctxEditMode ctxTraverse currentCtx currentTime currentTimeCtx
syntax keyword melFunction currentUnit curve curveAddPtCtx curveCVCtx curveEPCtx curveEditorCtx
syntax keyword melFunction curveIntersect curveMoveEPCtx curveOnSurface curveSketchCtx cutKey
syntax keyword melFunction cycleCheck cylinder
syntax keyword melFunction cosh cosd

syntax keyword melFunction dagPose defaultLightListCheckBox defaultNavigation defineDataServer
syntax keyword melFunction defineVirtualDevice deformer deg_to_rad delete deleteAttr
syntax keyword melFunction deleteShadingGroupsAndMaterials deleteShelfTab deleteUI
syntax keyword melFunction deleteUnusedBrushes delrandstr detachCurve detachDeviceAttr
syntax keyword melFunction detachSurface deviceEditor devicePanel dgInfo dgdirty dgeval dgtimer
syntax keyword melFunction dimWhen directKeyCtx directionalLight dirmap dirname disable
syntax keyword melFunction disconnectAttr disconnectJoint diskCache displacementToPoly
syntax keyword melFunction displayAffected displayColor displayCull displayLevelOfDetail
syntax keyword melFunction displayPref displayRGBColor displaySmoothness displayStats
syntax keyword melFunction displaySurface distanceDimContext distanceDimension doBlur docServer
syntax keyword melFunction dolly dollyCtx dopeSheetEditor dot dotProduct
syntax keyword melFunction doubleProfileBirailSurface drag draggerContext dropoffLocator
syntax keyword melFunction duplicate duplicateCurve duplicateSurface dynCache dynControl
syntax keyword melFunction dynExport dynExpression dynGlobals dynPaintEditor dynParticleCtx
syntax keyword melFunction dynPref dynRelEdPanel dynRelEditor dynamicLoad

syntax keyword melFunction editAttrLimits editDisplayLayerGlobals editDisplayLayerMembers
syntax keyword melFunction editRenderLayerGlobals editRenderLayerMembers editor editorTemplate
syntax keyword melFunction effector emit emitter enableDevice encodeString endString endsWith env
syntax keyword melFunction equivalent equivalentTol erf eval evalDeferred evalEcho event
syntax keyword melFunction exactWorldBoundingBox exclusiveLightCheckBox exec executeForEachObject
syntax keyword melFunction exists exp exportComposerCurves expression expressionEditorListen
syntax keyword melFunction extendCurve extendSurface extrude

syntax keyword melFunction fcheck fclose feof fflush fgetline fgetword file fileBrowserDialog
syntax keyword melFunction fileDialog fileExtension fileInfo filetest filletCurve filter
syntax keyword melFunction filterCurve filterExpand filterStudioImport findAllIntersections
syntax keyword melFunction findKeyframe findMenuItem findRelatedSkinCluster finder firstParentOf
syntax keyword melFunction fitBspline flexor floatEq floatField floatFieldGrp floatScrollBar
syntax keyword melFunction floatSlider floatSlider2 floatSliderButtonGrp floatSliderGrp floor
syntax keyword melFunction flow fluidCacheInfo fluidEmitter fluidVoxelInfo flushUndo fmod
syntax keyword melFunction fontDialog fopen formLayout fprint frameLayout fread freeFormFillet
syntax keyword melFunction frewind fromNativePath fwrite

syntax keyword melFunction gamma gauss geometryConstraint getApplicationVersionAsFloat getAttr
syntax keyword melFunction getClassification getDefaultBrush getFileList getFluidAttr
syntax keyword melFunction getInputDeviceRange getMayaPanelTypes getModifiers getPanel
syntax keyword melFunction getParticleAttr getenv getpid glRender glRenderEditor globalStitch
syntax keyword melFunction gmatch goal gotoBindPose grabColor gradientControl
syntax keyword melFunction gradientControlNoAttr graphDollyCtx graphSelectContext graphTrackCtx
syntax keyword melFunction gravity grid gridLayout group groupObjectsByName

syntax keyword melFunction hardenPointCurve hardware hardwareRenderPanel headsUpDisplay help
syntax keyword melFunction helpLine hermite hide hilite hitTest hotBox hotkey hotkeyCheck
syntax keyword melFunction hsv_to_rgb hwReflectionMap hwRender hwRenderLoad hyperGraph hyperPanel
syntax keyword melFunction hyperShade hypot

syntax keyword melFunction iconTextButton iconTextCheckBox iconTextRadioButton
syntax keyword melFunction iconTextRadioCollection iconTextStaticLabel ikHandle ikHandleCtx
syntax keyword melFunction ikHandleDisplayScale ikSolver ikSplineHandleCtx ikSystem ikSystemInfo
syntax keyword melFunction ikfkDisplayMethod image imfPlugins importComposerCurves
syntax keyword melFunction inheritTransform insertJoint insertJointCtx insertKeyCtx
syntax keyword melFunction insertKnotCurve insertKnotSurface instance instancer intField
syntax keyword melFunction intFieldGrp intScrollBar intSlider intSliderGrp interToUI internalVar
syntax keyword melFunction intersect iprEngine isAnimCurve isConnected isDirty isParentOf isTrue
syntax keyword melFunction isValidObjectName isValidString isValidUiName isolateSelect itemFilter
syntax keyword melFunction itemFilterAttr itemFilterRender itemFilterType

syntax keyword melFunction joint jointCluster jointCtx jointDisplayScale jointLattice

syntax keyword melFunction keyTangent keyframe keyframeOutliner keyframeRegionCurrentTimeCtx
syntax keyword melFunction keyframeRegionDirectKeyCtx keyframeRegionDollyCtx
syntax keyword melFunction keyframeRegionInsertKeyCtx keyframeRegionMoveKeyCtx
syntax keyword melFunction keyframeRegionScaleKeyCtx keyframeRegionSelectKeyCtx
syntax keyword melFunction keyframeRegionSetKeyCtx keyframeRegionTrackCtx keyframeStats

syntax keyword melFunction lassoContext lattice latticeDeformKeyCtx launch layerButton
syntax keyword melFunction layeredShaderPort layeredTexturePort layout lightList lightListEditor
syntax keyword melFunction lightListPanel lightlink lineIntersection linstep listAnimatable
syntax keyword melFunction listAttr listCameras listConnections listDeviceAttachments listHistory
syntax keyword melFunction listInputDeviceAxes listInputDeviceButtons listInputDevices
syntax keyword melFunction listMenuAnnotation listNodeTypes listRelatives listSets listTransforms
syntax keyword melFunction listUnselected listerEditor loadFluid loadNewShelf loadPlugin
syntax keyword melFunction loadPrefObjects lockNode loft log lookThru ls lsThroughFilter lsType
syntax keyword melFunction lsUI

syntax keyword melFunction Mayatomr mag makeIdentity makeLive makePaintable makeRoll
syntax keyword melFunction makeSingleSurface makeTubeOn makebot manipMoveContext
syntax keyword melFunction manipMoveLimitsCtx manipOptions manipRotateContext
syntax keyword melFunction manipRotateLimitsCtx manipScaleContext manipScaleLimitsCtx marker
syntax keyword melFunction match max memory menu menuBarLayout menuEditor menuItem
syntax keyword melFunction menuItemToShelf messageLine min minimizeApp mirrorJoint
syntax keyword melFunction modelCurrentTimeCtx modelEditor modelPanel mouse movIn movOut move
syntax keyword melFunction moveIKtoFK moveKeyCtx moveVertexAlongDirection
syntax keyword melFunction multiProfileBirailSurface mute

syntax keyword melFunction nameCommand nameField namespace namespaceInfo newPanelItems newton
syntax keyword melFunction nodeIconButton nodeOutliner nodePreset nodeType noise nonLinear
syntax keyword melFunction normalConstraint normalize nurbsBoolean nurbsCopyUVSet nurbsCube
syntax keyword melFunction nurbsPlane nurbsSelect nurbsSquare nurbsToPoly nurbsToPolygonsPref
syntax keyword melFunction nurbsToSubdiv nurbsViewDirectionVector

syntax keyword melFunction objExists objectCenter objectLayer objectType objectTypeUI
syntax keyword melFunction obsoleteProc offsetCurve offsetCurveOnSurface offsetSurface
syntax keyword melFunction openGLExtension openMayaPref optionMenu optionMenuGrp optionVar orbit
syntax keyword melFunction orbitCtx orientConstraint outlinerEditor outlinerPanel
syntax keyword melFunction overrideModifier

syntax keyword melFunction pairBlend palettePort paneLayout panel panelConfiguration panelHistory
syntax keyword melFunction paramDimContext paramDimension paramLocator parent parentConstraint
syntax keyword melFunction particle particleExists particleInstancer particleRenderInfo partition
syntax keyword melFunction pasteKey pathAnimation pause pclose percent performanceOptions
syntax keyword melFunction pfxstrokes pickWalk picture pixelMove planarSrf plane play
syntax keyword melFunction playbackOptions playblast pluginInfo pointConstraint
syntax keyword melFunction pointCurveConstraint pointLight pointMatrixMult pointOnCurve
syntax keyword melFunction pointOnSurface pointPosition poleVectorConstraint polyAppend
syntax keyword melFunction polyAppendFacetCtx polyAppendVertex polyAutoProjection
syntax keyword melFunction polyAverageNormal polyAverageVertex polyBevel polyBlindData polyBoolOp
syntax keyword melFunction polyCacheMonitor polyChipOff polyClipboard polyCloseBorder
syntax keyword melFunction polyCollapseEdge polyCollapseFacet polyColorBlindData
syntax keyword melFunction polyColorPerVertex polyCone polyCopyUV polyCreateFacet
syntax keyword melFunction polyCreateFacetCtx polyCube polyCut polyCutCtx polyCylinder
syntax keyword melFunction polyCylindricalProjection polyDelEdge polyDelFacet polyDelVertex
syntax keyword melFunction polyDuplicateAndConnect polyEditUV polyEvaluate polyExtrudeEdge
syntax keyword melFunction polyExtrudeFacet polyFlipEdge polyFlipUV polyForceUV polyGeoSampler
syntax keyword melFunction polyInfo polyInstallAction polyLayoutUV polyListComponentConversion
syntax keyword melFunction polyMapCut polyMapDel polyMapSew polyMapSewMove polyMergeEdge
syntax keyword melFunction polyMergeEdgeCtx polyMergeFacet polyMergeFacetCtx polyMergeUV
syntax keyword melFunction polyMergeVertex polyMirrorFace polyMoveEdge polyMoveFacet
syntax keyword melFunction polyMoveFacetUV polyMoveUV polyMoveVertex polyNormal
syntax keyword melFunction polyNormalPerVertex polyNormalizeUV polyOptions polyPlanarProjection
syntax keyword melFunction polyPlane polyPoke polyProjection polyQuad polyQueryBlindData
syntax keyword melFunction polyReduce polySelectConstraint polySelectConstraintMonitor
syntax keyword melFunction polySeparate polySetToFaceNormal polySewEdge polySmooth polySoftEdge
syntax keyword melFunction polySphere polySphericalProjection polySplit polySplitCtx
syntax keyword melFunction polySplitEdge polySplitVertex polyStraightenUVBorder polySubdivideEdge
syntax keyword melFunction polySubdivideFacet polySuperCtx polyToSubdiv polyTorus polyTransfer
syntax keyword melFunction polyTriangulate polyUVSet polyUnite polyWedgeFace popen popupMenu pose
syntax keyword melFunction pow preloadRefEd print progressBar progressWindow projFileViewer
syntax keyword melFunction projectCurve projectTangent projectionContext projectionManip
syntax keyword melFunction promptDialog propModCtx propMove psdExport psdTextureFile putenv pwd

syntax keyword melFunction querySubdiv quit

syntax keyword melFunction rad_to_deg radial radioButton radioButtonGrp radioCollection
syntax keyword melFunction radioMenuItemCollection rampColorPort rand randstate rangeControl
syntax keyword melFunction readTake rebuildCurve rebuildSurface recordAttr recordDevice redo
syntax keyword melFunction reference refineSubdivSelectionList refresh refreshAE rehash
syntax keyword melFunction reloadImage removeJoint removeMultiInstance rename renameAttr
syntax keyword melFunction renameSelectionList renameUI render renderGlobalsNode renderInfo
syntax keyword melFunction renderLayerButton renderManip renderPartition renderQualityNode
syntax keyword melFunction renderThumbnailUpdate renderWindowEditor renderWindowSelectContext
syntax keyword melFunction renderer reorder reorderDeformers requires reroot resampleFluid
syntax keyword melFunction resetAE resetTool resolutionNode retarget reverseCurve reverseSurface
syntax keyword melFunction revolve rgb_to_hsv rigidBody rigidSolver roll rollCtx rootOf rot
syntax keyword melFunction rotate rotationInterpolation roundConstantRadius rowColumnLayout
syntax keyword melFunction rowLayout runTimeCommand runup

syntax keyword melFunction sampleImage saveAllShelves saveAttrPreset saveFluid saveImage
syntax keyword melFunction saveInitialState saveMenu savePrefObjects savePrefs saveShelf
syntax keyword melFunction saveToolSettings scale scaleBrushBrightness scaleConstraint scaleKey
syntax keyword melFunction scaleKeyCtx sceneEditor sceneUIReplacement scmh scriptCtx
syntax keyword melFunction scriptEditorInfo scriptJob scriptNode scriptTable scriptedPanel
syntax keyword melFunction scriptedPanelType scrollField scrollLayout sculpt searchPathArray seed
syntax keyword melFunction selLoadSettings select selectContext selectKey selectKeyCtx selectMode
syntax keyword melFunction selectPref selectPriority selectType selectedNodes selectionConnection
syntax keyword melFunction separator setAttr setAttrMapping setConstraintRestPosition
syntax keyword melFunction setDefaultShadingGroup setDrivenKeyframe setDynamic setEditCtx
syntax keyword melFunction setEditor setEscapeCtx setFluidAttr setFocus setInfinity
syntax keyword melFunction setInputDeviceMapping setKeyCtx setKeyPath setKeyframe setMenuMode
syntax keyword melFunction setNodeTypeFlag setParent setParticleAttr setProject setStampDensity
syntax keyword melFunction setStartupMessage setState setToolTo setUITemplate sets
syntax keyword melFunction shadingConnection shadingGeometryRelCtx shadingLightRelCtx shadingNode
syntax keyword melFunction shelfButton shelfLayout shelfTabLayout shellField showHelp showHidden
syntax keyword melFunction showManipCtx showSelectionInTitle showShadingGroupAttrEditor
syntax keyword melFunction showWindow sign simplify sin singleProfileBirailSurface size
syntax keyword melFunction skinCluster skinPercent smoothCurve smoothTangentSurface smoothstep
syntax keyword melFunction snap2to2 snapKey snapMode snapTogetherCtx snapshot soft softMod
syntax keyword melFunction softModCtx sort sound soundControl spaceLocator sphere sphrand
syntax keyword melFunction spotLight spotLightPreviewPort spreadSheetEditor spring sqrt
syntax keyword melFunction squareSurface srtContext stackTrace startString startsWith
syntax keyword melFunction stitchAndExplodeShell stitchSurface stitchSurfacePoints strcmp
syntax keyword melFunction stringArrayCatenate stringArrayCount stringArrayIntersector
syntax keyword melFunction stringArrayRemove stringArrayRemoveDuplicates stringArrayToString
syntax keyword melFunction stringToStringArray strip stroke subdAutoProjection subdCleanTopology
syntax keyword melFunction subdCollapse subdDuplicateAndConnect subdEditUV
syntax keyword melFunction subdListComponentConversion subdMapCut subdMapSewMove
syntax keyword melFunction subdMatchTopology subdMirror subdToBlind subdToPoly
syntax keyword melFunction subdTransferUVsToCache subdiv subdivCrease subdivDisplaySmoothness
syntax keyword melFunction substitute substituteAllString substring superCtx surface
syntax keyword melFunction surfaceShaderList swatchDisplayPort switchTable symbolButton
syntax keyword melFunction symbolCheckBox sysFile system
syntax keyword melFunction sinh sind

syntax keyword melFunction tabLayout tan tangentConstraint texManipContext texMoveContext
syntax keyword melFunction texRotateContext texScaleContext texSelectContext texWinToolCtx text
syntax keyword melFunction textCurves textField textFieldButtonGrp textFieldGrp textScrollList
syntax keyword melFunction textToShelf textureDisplacePlane texturePlacementContext textureWindow
syntax keyword melFunction threePointArcCtx timeControl timePort timerX toNativePath toggle
syntax keyword melFunction toggleAxis toggleWindowVisibility tokenize tokenizeList tolerance
syntax keyword melFunction tolower toolButton toolCollection toolDropped toolHasOptions
syntax keyword melFunction toolPropertyWindow torus toupper trace track trackCtx transformLimits
syntax keyword melFunction translator trim trunc truncateFluidCache truncateHairCache tumble
syntax keyword melFunction tumbleCtx turbulence twoPointArcCtx
syntax keyword melFunction tanh tand

syntax keyword melFunction uiTemplate unassignInputDevice undo undoInfo ungroup uniform unit
syntax keyword melFunction unloadPlugin untangleUV untrim upAxis updateAE userCtx uvLink
syntax keyword melFunction uvSnapshot

syntax keyword melFunction validateShelfName vectorize verifyCmd view2dToolCtx viewCamera
syntax keyword melFunction viewClipPlane viewFit viewHeadOn viewLookAt viewPlace viewSet visor
syntax keyword melFunction volumeAxis vortex

syntax keyword melFunction waitCursor webBrowser webBrowserPrefs whatIs window windowPref
syntax keyword melFunction wire wireContext workspace wrinkle wrinkleContext writeTake

syntax keyword melFunction xbmLangPathList xform xpmPicker

" special functions and flow control {{{2
syn keyword melStatement    break continue return
syn keyword melConditional  if else switch
syn keyword melLabel        case default
syn keyword melRepeat       for in while do
syn keyword melInclude      source

" other {{{2
syntax keyword melType      string float matrix int vector
syntax keyword melBool      yes no true false on off
syntax keyword melKeyword   global proc time frame
syntax keyword melException catch catchQuiet error warning
" }}}1


" Define the highlight linking. {{{1
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_mel_syntax_inits")
    " When the version needs it, store that we have the syntax's highlights.
    " Also, create a temporary command to only set unlinked groups when
    " possible.
    if version < 508
        let did_mel_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif


    " Link some items to extra groups.
    HiLink melNotes         SpecialCommentNotes
    HiLink melFoldOpen2     SpecialComment2
    HiLink melFoldOpen1     SpecialComment1
    HiLink melFoldMarks     Fade


    " Since the above groups aren't known to most colorschemes, we'll link them to
    " default groups.
    HiLink SpecialComment1      SpecialComment
    HiLink SpecialComment2      SpecialComment
    HiLink SpecialCommentNotes  Special
    HiLink Fade                 Ignore


    " Link some items to default, but seldomly used groups.
    HiLink melFoldOpen3     SpecialComment
    HiLink melImportant     SpecialComment
    HiLink melInclude       Include
    HiLink melException     Exception
    HiLink melKeyword       Keyword
    HiLink melLabel         Label
    HiLink melRepeat        Repeat
    HiLink melConditional   Conditional
    HiLink melFunction      Function
    HiLink melFloat         Float
    HiLink melBool          Boolean


    " To ensure most colorschemes show a highlighting for them, we'll link
    " those groups to more frequently used items to, just in case they don't
    " have a highlighting in the current color file.
    HiLink Macro            Define
    "HiLink Typedef         Define
    "HiLink Debug           Exception
    HiLink Label            Conditional
    HiLink Repeat           Conditional
    "HiLink StorageClass        Type
    "HiLink Structure       Type
    HiLink Function         Statement
    HiLink Keyword          Statement
    HiLink Exception        Statement
    "HiLink Operator            Statement
    HiLink Define           PreProc
    "HiLink PreCondit       PreProc
    HiLink Include          PreProc
    HiLink Conditional      Constant
    HiLink Boolean          Number
    HiLink Float            Number
    HiLink SpecialChar      Special
    HiLink SpecialComment   Comment


    " Link the remaining items to the often used syntax groups.
    HiLink melTODO          Todo
    HiLink melString        String
    if s:flag_as_string == 1
        HiLink melFlag          String
    endif
    HiLink melVar           Identifier
    HiLink melType          Type
    HiLink melStatement     Statement
    HiLink melInteger       Number
    HiLink melCharSpecial   SpecialChar
    HiLink melComment       Comment
    if s:no_error == 0
        HiLink melCommentError  Error
        HiLink melCharError     Error
        if s:space_tab_error == 1
            HiLink melSpaceError    Error
        endif
        if -1 != match(s:space_trailing, "^[eE][rR][rR][oO][rR]$")
            HiLink melSpaceTrailing Error
        elseif -1 != match(s:space_trailing, "^[sS][tT][rR][iI][nN][gG]$")
            HiLink melSpaceTrailing String
        endif
    endif


    " Remove the temporary command.
    delcommand HiLink
endif

let b:current_syntax = "mel"
" }}}1


" Finishing steps {{{1

" Delete the temporary commands.
delcommand InitOption

" }}}1


" vim:set ts=4 sw=4 tw=78 fdm=marker fdl=1 fdc=3:
