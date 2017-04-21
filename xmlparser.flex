
%%

%byaccj

%{
  private Parser yyparser;
  
  private int sectionCounter = 0;
  
  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%x IN_XML IN_DOCTYPE IN_XML_TAG IN_DOCTYPE_TAG IN_DEDICATION_TAG IN_PREFACE_TAG IN_NOTE_TAG IN_AUTHORNOTES_TAG IN_BOOK_TAG IN_ITEMLOT_TAG IN_ITEMTOC_TAG IN_ITEMLOF_TAG IN_LOT_TAG IN_LOF_TAG IN_TOC_TAG IN_PART_TAG IN_CHAPTER_TAG ID_ATT IN_SECTION_TAG IN_SUBSECTION_TAG IN_SECTION_TAG IN_FIGURE_TAG IN_TABLE_TAG IN_ROW_TAG IN_CELL_TAG 


XML="<?xml version='1.0' encoding='UTF-8'?>"
DOCTYPE="<!DOCTYPE book SYSTEM \"book.dtd\">"

NL = [\t|\n|\r|\r\n|" "]*
PCDATA = [a-zA-Z0-9][^<>]+[a-zA-Z0-9\-\_\.\(" ")*\&\#\$\%]
VALUE_ATT = "\""[a-zA-Z0-9_" ".]*"\""

//------  ATTRIBUTES  -------

ID_ATT = " id="
TITLE_ATT = " title="
CAPTION_ATT = " caption="
PATH_ATT = " path="
EDITION_ATT = " edition="

//---------------------------

//--------  TAG  ---------

PART_TAG = "<part"
CHAPTER_TAG = "<chapter"
SECTION_TAG = "<section"
FIGURE_TAG = "<figure"
TABLE_TAG = "<table"
ROW_TAG = "<row>"
CELL_TAG = "<cell>"
AUTHORNOTES_TAG = "<authornotes>"
NOTE_TAG = "<note>"
TOC_TAG="<toc>"
LOF_TAG="<lof>"
LOT_TAG="<lot>"
ITEM_TAG="<item"
PREFACE_TAG="<preface>"
BOOK_TAG="<book"
DEDICATION_TAG="<dedication>"

//---------------------------

//-----  CLOSE TAG  ---------

END_PART="</part>"
END_CHAPTER="</chapter>"
END_SECTION="</section>"
END_FIGURE="</figure>"
END_TABLE="</table>"
END_ROW="</row>"
END_CELL="</cell>"
END_TOC="</toc>"
END_LOF="</lof>"
END_LOT="</lot>"
END_ITEM="</item>"
END_PREFACE="</preface>"
END_BOOK="</book>"
END_AUTHORNOTES="</authornotes>"
END_NOTE="</note>"
END_PREFACE="</preface>"
END_DEDICATION="</dedication>"

CLOSE_TAG = >
SHORT_CLOSE_TAG = " />"

//---------------------------


%%
<IN_XML,IN_DOCTYPE,IN_DOCTYPE_TAG,IN_DEDICATION_TAG,IN_PREFACE_TAG,IN_NOTE_TAG,IN_AUTHORNOTES_TAG,IN_BOOK_TAG,IN_ITEMLOT_TAG,IN_ITEMTOC_TAG,IN_ITEMLOF_TAG,IN_LOT_TAG,IN_LOF_TAG,IN_TOC_TAG,IN_PART_TAG,IN_CHAPTER_TAG,IN_SECTION_TAG,IN_SECTION_TAG,IN_SUBSECTION_TAG,IN_TABLE_TAG,IN_ROW_TAG,IN_CELL_TAG,IN_FIGURE_TAG>{NL} { return Parser.NL; }

//----------------------  HEADER  ------------------------

<YYINITIAL>{XML} {yybegin(IN_XML);
	return Parser.XML;
}

<IN_XML>{DOCTYPE} {yybegin(IN_DOCTYPE);
	return Parser.DOCTYPE;
}

//--------------------------------------------------------

//----------------------  BOOK  --------------------------

<IN_DOCTYPE>{BOOK_TAG} {yybegin(IN_BOOK_TAG);
	return Parser.BOOK_TAG;
}

<IN_BOOK_TAG>{END_BOOK} {yybegin(IN_DOCTYPE_TAG);
	return Parser.END_BOOK;
}

//--------------------------------------------------------

//-------------------  DEDICATION  -----------------------

<IN_BOOK_TAG>{DEDICATION_TAG} { yybegin(IN_DEDICATION_TAG);
	return Parser.DEDICATION_TAG;
}

<IN_DEDICATION_TAG>{END_DEDICATION} {yybegin(IN_BOOK_TAG);
	return Parser.END_DEDICATION;
}

//--------------------------------------------------------

//--------------------  PREFACE  -------------------------

<IN_BOOK_TAG>{PREFACE_TAG} { yybegin(IN_PREFACE_TAG);
	return Parser.PREFACE_TAG;
}

<IN_PREFACE_TAG>{END_PREFACE} {yybegin(IN_BOOK_TAG);
	return Parser.END_PREFACE;
}

//--------------------------------------------------------

//----------------------  PART  --------------------------

<IN_BOOK_TAG>{PART_TAG} { yybegin(IN_PART_TAG);
	return Parser.PART_TAG;
}

<IN_PART_TAG>{END_PART} {yybegin(IN_BOOK_TAG);
	return Parser.END_PART;
}

//--------------------------------------------------------

//----------------------  TOC  ---------------------------

<IN_PART_TAG>{TOC_TAG} { yybegin(IN_TOC_TAG);
	return Parser.TOC_TAG;
}

<IN_TOC_TAG>{ITEM_TAG} { yybegin(IN_ITEMTOC_TAG);
	return Parser.ITEM_TAG;
}

<IN_TOC_TAG>{END_TOC} {yybegin(IN_PART_TAG);
	return Parser.END_TOC;
}

//--------------------------------------------------------

//----------------------  LOF  ---------------------------

<IN_PART_TAG>{LOF_TAG} { yybegin(IN_LOF_TAG);
	return Parser.LOF_TAG;
}

<IN_LOF_TAG>{END_LOF} {yybegin(IN_PART_TAG);
	return Parser.END_LOF;
}

//--------------------------------------------------------

//----------------------  LOT  ---------------------------

<IN_PART_TAG>{LOT_TAG} { yybegin(IN_LOT_TAG);
	return Parser.LOT_TAG;
}

<IN_LOT_TAG>{END_LOT} {yybegin(IN_PART_TAG);
	return Parser.END_LOT;
}

//--------------------------------------------------------

//----------------------  ITEM  --------------------------

<IN_LOT_TAG>{ITEM_TAG} { yybegin(IN_ITEMLOT_TAG);
	return Parser.ITEM_TAG;
}	

<IN_LOF_TAG>{ITEM_TAG} { yybegin(IN_ITEMLOF_TAG);
	return Parser.ITEM_TAG;
}

<IN_ITEMTOC_TAG>{END_ITEM} {yybegin(IN_TOC_TAG);
	return Parser.END_ITEM;
}

<IN_ITEMLOF_TAG>{END_ITEM} {yybegin(IN_LOF_TAG);
	return Parser.END_ITEM;
}

<IN_ITEMLOT_TAG>{END_ITEM} {yybegin(IN_LOT_TAG);
	return Parser.END_ITEM;
}

//--------------------------------------------------------

//--------------------  CHAPTER  -------------------------

<IN_PART_TAG>{CHAPTER_TAG} { yybegin(IN_CHAPTER_TAG);
	return Parser.CHAPTER_TAG;
}

<IN_CHAPTER_TAG>{END_CHAPTER} {yybegin(IN_PART_TAG);
	return Parser.END_CHAPTER;
}

//--------------------------------------------------------

//---------------------  NOTE  ---------------------------

<IN_AUTHORNOTES_TAG>{NOTE_TAG} { yybegin(IN_NOTE_TAG);
	return Parser.NOTE_TAG;
}

<IN_NOTE_TAG>{END_NOTE} {yybegin(IN_AUTHORNOTES_TAG);
	return Parser.END_NOTE;
}

//--------------------------------------------------------

//--------------------  FIGURE  --------------------------

<IN_SECTION_TAG>{FIGURE_TAG} { yybegin(IN_FIGURE_TAG);
	return Parser.FIGURE_TAG;
}

<IN_FIGURE_TAG>{END_FIGURE} {yybegin(IN_SECTION_TAG); 

	return Parser.END_FIGURE;
}

<IN_FIGURE_TAG>{SHORT_CLOSE_TAG} {yybegin(IN_SECTION_TAG); 
return Parser.SHORT_CLOSE_TAG;
}

//--------------------------------------------------------

//--------------------  TABLE  ---------------------------

<IN_SECTION_TAG>{TABLE_TAG} { yybegin(IN_TABLE_TAG);
	return Parser.TABLE_TAG;
}

<IN_TABLE_TAG>{END_TABLE} {yybegin(IN_SECTION_TAG); 
	return Parser.END_TABLE;
}

//--------------------------------------------------------

//---------------------  ROW  ----------------------------

<IN_TABLE_TAG>{ROW_TAG} {yybegin(IN_ROW_TAG);
	return Parser.ROW_TAG;
}

<IN_ROW_TAG>{END_ROW} {yybegin(IN_TABLE_TAG); 
	return Parser.END_ROW;
}

//--------------------------------------------------------

//--------------------  CELL  ----------------------------

<IN_ROW_TAG>{CELL_TAG} {yybegin(IN_CELL_TAG);
	return Parser.CELL_TAG;
}

<IN_CELL_TAG>{END_CELL} {yybegin(IN_ROW_TAG); 
	return Parser.END_CELL;
}

//--------------------------------------------------------

//-----------------  AUTHORNOTES  ------------------------

<IN_BOOK_TAG>{AUTHORNOTES_TAG} { yybegin(IN_AUTHORNOTES_TAG);
	return Parser.AUTHORNOTES_TAG;
}

<IN_AUTHORNOTES_TAG>{END_AUTHORNOTES} {yybegin(IN_BOOK_TAG);
	return Parser.END_AUTHORNOTES;
}

//--------------------------------------------------------

//--------------------  SECTION  -------------------------
					
<IN_CHAPTER_TAG,IN_SECTION_TAG>{SECTION_TAG} { yybegin(IN_SECTION_TAG);
	sectionCounter++;
	return Parser.SECTION_TAG;
}

<IN_SECTION_TAG>{END_SECTION} {sectionCounter--;
	if(sectionCounter>0) yybegin(IN_SECTION_TAG);
	else	yybegin(IN_CHAPTER_TAG); 
	return Parser.END_SECTION;
}

//--------------------------------------------------------

//----------------------  PCDATA  ------------------------

<IN_DEDICATION_TAG,IN_PREFACE_TAG,IN_SECTION_TAG,IN_NOTE_TAG,IN_CELL_TAG,
IN_ITEMTOC_TAG,IN_ITEMLOF_TAG,IN_ITEMLOT_TAG>{PCDATA} {	
	yyparser.yylval = new ParserVal(yytext());
	return Parser.PCDATA;			
}

//--------------------------------------------------------

//---------------------  ATTRIBUTI  -----------------------

<IN_ITEMTOC_TAG,IN_ITEMLOF_TAG,IN_ITEMLOT_TAG,IN_PART_TAG,IN_CHAPTER_TAG,
IN_SECTION_TAG,IN_FIGURE_TAG,IN_TABLE_TAG>{ID_ATT} { 
	return Parser.ID_ATT;
}

<IN_PART_TAG,IN_CHAPTER_TAG,IN_SECTION_TAG>{TITLE_ATT} {
	return Parser.TITLE_ATT;
}

<IN_FIGURE_TAG,IN_TABLE_TAG>{CAPTION_ATT} {
	return Parser.CAPTION_ATT;
}

<IN_FIGURE_TAG>{PATH_ATT} { 
	return Parser.PATH_ATT;
}

<IN_BOOK_TAG>{EDITION_ATT} { 
	return Parser.EDITION_ATT;
}

<IN_BOOK_TAG,IN_ITEMTOC_TAG,IN_ITEMLOF_TAG,IN_ITEMLOT_TAG,IN_PART_TAG,
IN_CHAPTER_TAG,IN_SECTION_TAG,IN_SUBSECTION_TAG,IN_FIGURE_TAG,IN_TABLE_TAG>
{VALUE_ATT} {	
	yyparser.yylval = new ParserVal(yytext());
	return Parser.VALUE_ATT;			
}

//--------------------------------------------------------

//---------------------  CLOSE TAG  ----------------------

<IN_BOOK_TAG,IN_ITEMTOC_TAG,IN_ITEMLOF_TAG,IN_ITEMLOT_TAG,IN_PART_TAG,
IN_CHAPTER_TAG,IN_SECTION_TAG,IN_SUBSECTION_TAG,IN_TABLE_TAG>
{CLOSE_TAG} { 
return Parser.CLOSE_TAG;
}

//--------------------------------------------------------

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }
