
if exists("b:current_syntax")
    finish
endif

" provide fallback HiLink command 
if version < 508
  command! -nargs=+ HaxeHiLink hi link <args>
else
  command! -nargs=+ HaxeHiLink hi def link <args>
endif

" characters that cannot be in a hscript program (outside a string)
syn match hscriptError "[\\`]"

" keywords
" --------
syn keyword hscriptTypedef typedef extends implements
syn keyword hscriptTypeDecl class enum abstract interface import using package from to
syn keyword hscriptStorageClass static inline public private macro dynamic extern override

syn match   hscriptTypedef		"\.\s*\<class\>"ms=s+1
syn match   hscriptTypeDecl       "^class\>"
syn match   hscriptTypeDecl       "[^.]\s*\<class\>"ms=s+1

syn keyword hscriptException try catch throw
syn keyword hscriptRepeat for do while in
syn keyword hscriptLabel case
syn keyword hscriptConditional switch
syn match hscriptConditional "\<\#\@<!\(if\|else\)\>"
syn keyword hscriptConstant null never super this default get set
syn keyword hscriptFunction function __dollar__new new
syn match hscriptFunction "\<__[^_]\+__\>"
syn keyword hscriptKeyword untyped cast continue break return trace var is
syn match hscriptKeyword "\$type"

syn match hscriptError "\<#\@<!elseif\>"

" type identifiers
" ----------------
syn match hscriptType "\<[A-Z][a-zA-Z_0-9]*\>"

" operators
" ---------
" Did a lot of work here to ensure a lot of invalid operators are highlighted as errors.

" put ,; in seperate highlight group to .: to avoid mistakes.
syn match hscriptOperator "[:?]"
syn match hscriptOperator2 "[;,]"

" match . and ... as operators, and .. and more than 4 . as errors
syn match hscriptOperator "\.\@<!\(\.\|\.\.\.\)\.\@!"
syn match hscriptError "\.\@<!\.\.\.\@!"
syn match hscriptError "\.\{4,\}"

" match <,>,<<,>>,>>> as operators and more than 3 < or more than 4 > as errors
syn match hscriptOperator ">\@<!\(>\|>>\|>>>\)>\@!"
syn match hscriptOperator "<\@<!\(<\|<<\)<\@!"
syn match hscriptError ">\{4,\}\|<\{3,}"

" match &| in 1 or 2 as operator, and more than 2 as error
" match &&= and ||= as errors
syn match hscriptOperator "&\@<!&&\?&\@!"
syn match hscriptOperator "|\@<!||\?|\@!"
syn match hscriptError "&\{3,\}\||\{3,}\|&&=\|||="

" match = in 1 or 2 as operator, and more than 2 as error
" match !== as an error
syn match hscriptOperator "=\@<!==\?=\@!"
syn match hscriptError "=\{3,\}\|!=="

" match (+-*/%&!<>)=? as operators
" have to match &!<> seperate to avoid highlighting things like &&= &&& <<< as okay
syn match hscriptOperator "[+\-*/%^!]=\?=\@!"
syn match hscriptOperator "<\@<!<=\?[=<]\@!"
syn match hscriptOperator ">\@<![>]=\?[=>]\@!"
syn match hscriptOperator "&\@<!&=\?[=&]\@!"
syn match hscriptOperator "|\@<!|=\?[=|]\@!"

" string literals
" ---------------
" Did a lot of work to ensure that string interpolations are handled nicely
syn match hscriptErrorCharacter contained "\\\(x.\{0,2}\|u.\{0,4\}\|[^"'\\/nrt]\)"
syn match hscriptSpecialCharacter contained "\\\(x[a-fA-F0-9]\{2\}\|[0-7]\{3\}\|["'\\/nrt]\)"
syn match hscriptIntSpecialChar contained "\$\@<!\(\$\$\)\+\(\(\$\$\)\+\)\@!"
syn match hscriptInterpolatedIdent contained "\((\$\$)\+\)\@<!\$[a-zA-Z_][a-zA-Z_0-9]*"
syn region hscriptInterpolated contained start=+\((\$\$)\+\)\@<!\${+ end=+}+ contains=TOP
syn region hscriptInterpolated contained start=+\(\$\(\$\$\)\+\)\@<!${+ end=+}+ contains=TOP
syn region hscriptDString start=+"+ end=+"+ contains=hscriptSpecialCharacter,hscriptErrorCharacter,@Spell
syn region hscriptSString start=+'+ end=+'+ contains=hscriptSpecialCharacter,hscriptErrorCharacter,hscriptIntSpecialChar,hscriptInterpolatedIdent,hscriptInterpolated,@Spell

" int/float/bool literal
" ----------------------
syn match hscriptInt "\<\([0-9]\+\|0x[0-9a-fA-F]\+\)\>"
syn match hscriptFloat "\<\([\-+]\?[0-9]*\.\?[0-9]\+([eE][\-+]\?[0-9]\+)\?\)\>"
syn keyword hscriptBool true false

" comments
" --------
syn keyword hscriptTODO contained TODO FIXME XXX
syn match hscriptComment "//.*" contains=hscriptTODO,@Spell
syn region hscriptComment2 start=+/\*+ end=+\*/+ contains=hscriptTODO,@Spell

" preprocessing
" -------------
syn match hscriptPre "\(#if\|#elseif\|#else\|#end\)"
syn match hscriptPreError "#error"

" regex
" -----
syn region hscriptRegex start=+\~\/+ end=+\/+ contains=hscriptRegexEscape,hscriptRegexError,@Spell

syn match hscriptRegexError contained "\\[^0-9bdnrstwxBDSW(){}\[\]\\$^*\-+|./?]"
syn match hscriptRegexEscape contained "\\[0-9bdnrstwxBDSW(){}\[\]\\$^*\-+|./?]"

" meta
" ----
syn match hscriptMeta "@:\?[a-zA-Z_][a-zA-Z_0-9]*\>"

syn match hscriptCompilerMeta "@:\(
    \abstract
    \\|access
    \\|allow
    \\|annotation
    \\|arrayAccess
    \\|autoBuild
    \\|bind
    \\|bitmap
    \\|build
    \\|buildXml
    \\|classCode
    \\|commutative
    \\|compilerGenerated
    \\|coreApi
    \\|coreType
    \\|cppFileCode
    \\|cppNamespaceCode
    \\|dce
    \\|debug
    \\|decl
    \\|defParam
    \\|delegate
    \\|depend
    \\|deprecated
    \\|event
    \\|enum
    \\|expose
    \\|extern
    \\|fakeEnum
    \\|file
    \\|final
    \\|font
    \\|forward
    \\|from
    \\|functionCode
    \\|functionTailCode
    \\|generic
    \\|genericBuild
    \\|getter
    \\|hack
    \\|headerClassCode
    \\|headerCode
    \\|headerNamespaceCode
    \\|hxGen
    \\|ifFeature
    \\|include
    \\|initPackage
    \\|internal
    \\|isVar
    \\|keep
    \\|keepInit
    \\|keepSub
    \\|macro
    \\|meta
    \\|multiType
    \\|native
    \\|nativeGen
    \\|noCompletion
    \\|noDebug
    \\|noDoc
    \\|noImportGlobal
    \\|noPackageRestrict
    \\|noStack
    \\|noUsing
    \\|notNull
    \\|ns
    \\|op
    \\|optional
    \\|overload
    \\|privateAccess
    \\|property
    \\|protected
    \\|public
    \\|publicFields
    \\|readOnly
    \\|remove
    \\|require
    \\|rtti
    \\|runtime
    \\|runtimeValue
    \\|setter
    \\|sound
    \\|struct
    \\|suppressWarnings
    \\|throws
    \\|to
    \\|transient
    \\|unbound
    \\|unifyMinDynamic
    \\|unreflective
    \\|unsafe
    \\|usage
    \\|volatile
    \\|structInit
    \\)\>"


syn sync ccomment hscriptComment2 minlines=10

HaxeHiLink hscriptMeta Macro
HaxeHiLink hscriptCompilerMeta Identifier
HaxeHiLink hscriptRegex String
HaxeHiLink hscriptDString String
HaxeHiLink hscriptSString Character
HaxeHiLink hscriptSpecialCharacter SpecialChar
HaxeHiLink hscriptIntSpecialChar SpecialChar
HaxeHiLink hscriptRegexEscape SpecialChar
HaxeHiLink hscriptErrorCharacter Error
HaxeHiLink hscriptRegexError Error
HaxeHiLink hscriptInterpolatedIdent Normal
HaxeHiLink hscriptInterpolated Normal
HaxeHiLink hscriptError Error
HaxeHiLink hscriptOperator Operator
HaxeHiLink hscriptOperator2 Identifier
HaxeHiLink hscriptSpecial SpecialChar
HaxeHiLink hscriptInt Number
HaxeHiLink hscriptFloat Float
HaxeHiLink hscriptBool Boolean
HaxeHiLink hscriptComment Comment
HaxeHiLink hscriptComment2 Comment
HaxeHiLink hscriptTODO Todo
HaxeHiLink hscriptPre PreCondit
HaxeHiLink hscriptPreError PreProc
HaxeHiLink hscriptType Type
HaxeHiLink hscriptTypedef Typedef
HaxeHiLink hscriptTypeDecl Keyword " Structure just gives me same colour as Type and looks bad.
HaxeHiLink hscriptStorageClass StorageClass
HaxeHiLink hscriptException Exception
HaxeHiLink hscriptRepeat Repeat
HaxeHiLink hscriptLabel Label
HaxeHiLink hscriptConditional Conditional
HaxeHiLink hscriptConstant Constant
HaxeHiLink hscriptFunction Function
HaxeHiLink hscriptKeyword Keyword

delcommand HaxeHiLink

let b:current_syntax = "hscript"
let b:spell_options = "contained"


" vim: ts=8
