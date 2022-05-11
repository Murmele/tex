\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{MartinMarmsolerDokument}[2022/05/11 Martin Marmsoler Document class]

% Options:
% usage: \documentclass[options]{MartinMarmsolerDokument} % use comma separated options or let empty if default is fine
% * confidential: Defines if the document shall be declared as confidential or not
%                 if confidential additional watermarks / text is shown in the footer
%                 that the document is confidential
% * hideTableOfContent: if passed, the table of content are hidden
% * hideTableOfFiguresTables: if passed, the table of figures and tables are hidden
% * hideNomenclature: if passed, the nomenclature section will be hidden

% texlive/2021/texmf-dist/doc/latex/base/clsguide.pdf

%---------------------------------------------------------------------------------------------------------
% REQUIREMENTS
\LoadClass[10pt]{article}
\RequirePackage{geometry}
\RequirePackage{import}
\RequirePackage{placeins} % Required by FloatBarrier
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{fancyhdr} % fancy. To change footer and header
\RequirePackage[x11names]{xcolor}
\RequirePackage{ifthen} % To be able to use boolean
% \RequirePackage[ngerman]{babel} to change the date format to dd. MM YYYY

\usepackage{hyperref} % getting clickable links in the table of content

% Used by the specification
\RequirePackage{longtable}
\RequirePackage{multirow}
\RequirePackage{fmtcount}% http://ctan.org/pkg/fmtcount Needed in the specification to format the subsection title

\RequirePackage{nomencl} % Nomenclature
\makenomenclature

\usepackage{tocloft} % used by the specification to change distance

\RequirePackage{gensymb} % \degree{} and other symbols

%---------------------------------------------------------------------------------------------------------
% SPECIFIC DEFINES
\definecolor{Color2}{HTML}{2b3d49} % blue
\definecolor{Color1}{HTML}{808080} % gray

\newcommand{\Company}{Martin Marmsoler}
%---------------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------------
% GENERAL DEFINES
\geometry{a4paper, left=0cm, top=0cm, bottom=0cm, right=0cm}

% Redefine command from nomencl so that it will be included the file in the build folder
\makeatletter
\def\@printnomenclature[#1]{%
	\nom@tempdim#1\relax
	% search in build folder!
	\@input@{build/\jobname\@inputfileextension}}
\makeatother
%---------------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------------
% BEGIN DECLARING OPTIONS
\DeclareOption{confidential}{\newcommand{\confidentialText}{Internal - Confidential}	}

\newif\iftableOfContent
\tableOfContenttrue
\DeclareOption{hideTableOfContent}{\tableOfContentfalse}

\newif\iftableOfFiguresTables
\tableOfFiguresTablestrue
\DeclareOption{hideTableOfFiguresTables}{\tableOfFiguresTablesfalse}

\newif\ifnomenclature
\nomenclaturetrue
\DeclareOption{hideNomenclature}{\nomenclaturefalse}

% Otherwise the options are not processed
% Do not define any options below this command!
\ProcessOptions*
%---------------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------------
% AT BEGIN DOCUMENT
% Will be called at the beginning of the document not earlier
\AtBeginDocument{%
	\input{MyTitlePage.tex}
	\newpage
	\documentstylesheet
	
	\iftableOfContent
		\tableofcontents
		\newpage
	\fi

	\iftableOfFiguresTables
		\listoffigures
		\listoftables
		\newpage
	\fi
	
	\ifnomenclature
	\printnomenclature
	\newpage
	\fi
}

%---------------------------------------------------------------------------------------------------------
% AT END DOCUMENT
% End of Document command
\AtEndDocument{
	% Last page
	\clearpage % newpage did not work
	
	{\Huge\Company}
	\vfill
	
%	\begin{flushright}
%		\includegraphics[width=10cm]{Logos/LastPageLogo.jpg}
%	\end{flushright}
}

%---------------------------------------------------------------------------------------------------------
% DOCUMENT STYLE
\NewDocumentCommand{\colorrule}{O{4pt}m}{%
	{\color{#2}\hrule width \hsize height #1}%
}

% This is how the document looks like after the title page
\newcommand{\documentstylesheet}{
	\newgeometry{includeheadfoot, left=3cm, top=0cm, bottom=4cm, right=3cm, bindingoffset=0cm}
	\setlength\headheight{3cm}
	% Fancy hdr must be after the geometry change, otherwise the margin settings are not read properly
	% https://answerbun.com/tex-latex/fancyhdr-package-not-working/	
	\pagestyle{fancy}
	\fancyhf{}
	
	\renewcommand\headrule{
%		\colorrule{blue}
		\begin{minipage}{1\textwidth}
			\colorrule{Color2}
			\colorrule{Color1}
	\end{minipage}}%

	\renewcommand\footrule{
		\colorrule{Color2}
	}
	
	%	\headheight = 3cm
	%	\headsep = 25pt
	%\topmargin = 1pt
	% Set header and footer
	
	% TODO: add header logo
	%\fancyhead[RE, RO]{\includegraphics[width=2cm]{Logos/HeaderLogo.png}}
	\fancyfoot[C]{}
	\fancyfoot[RO, LE] {\color{Color1} Page \thepage} % Right odd, Left even 
	%\footheigth = 3cm
	%	\renewcommand{\footrulewidth}{0.4pt}
	
	\fancyfoot[RE, LO] {
		\color{Color1}
		\Company
		\ifdefined\confidentialText
			\newline \confidentialText
		\fi
	}
}
