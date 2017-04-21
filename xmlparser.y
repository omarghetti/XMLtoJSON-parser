
%{
  import java.io.*;
%}
      
%token<sval> XML DOCTYPE NL PCDATA
%token<sval> DEDICATION_TAG PREFACE_TAG NOTE_TAG AUTHORNOTES_TAG BOOK_TAG ITEM_TAG PART_TAG LOT_TAG LOF_TAG TOC_TAG CHAPTER_TAG SECTION_TAG FIGURE_TAG TABLE_TAG ROW_TAG CELL_TAG 
%token<sval> CLOSE_TAG SHORT_CLOSE_TAG 
%token<sval> EDITION_ATT ID_ATT TITLE_ATT VALUE_ATT CAPTION_ATT PATH_ATT
%token<sval> END_DEDICATION END_PREFACE END_NOTE END_AUTHORNOTES END_BOOK END_ITEM END_LOT END_LOF END_TOC END_PART END_CHAPTER END_SECTION END_FIGURE END_TABLE END_ROW END_CELL
%type<sval> document header dedication preface notes note authornotes t_book book t_item items item lot lof toc parts t_part part t_chapter chapter chapters t_section section sections figure t_table table row rows cell cells
%type<sval> texts text 

%%
document: header NL book NL{System.out.println($3);}
		| header NL book{System.out.println($3);}
		;

book: t_book NL preface NL parts NL END_BOOK {$$=$1+" \"content\": [\n"+"\t"+$3+"\t"+$5+" ]\n"+"}" ; }
		| t_book NL preface NL parts NL authornotes NL END_BOOK {$$=$1+" \"content\": [\n"+"\t"+$3+"\t"+$5+"\t"+$7+" ]\n"+"}" ; }
		| t_book NL dedication NL preface NL parts NL authornotes NL END_BOOK {$$=$1+" \"content\": [\n\t"+$3+"\t"+$5+"\t"+$7+"\t"+$9+" ]\n"+"}" ; }
		| t_book NL dedication NL preface NL parts NL END_BOOK {$$=$1+" \"content\": [\n"+"\t"+$3+"\t"+$5+"\t"+$7+" ]\n"+"}" ; }
		;

t_book: BOOK_TAG CLOSE_TAG {$$="{\n"+" \"tag\": \"book\",\n" ; }
		| BOOK_TAG EDITION_ATT VALUE_ATT CLOSE_TAG {$$="{\n" + " \"tag\": \"book\",\n"+" \"@edition\": "+ $3 + ",\n" ; }
		;

dedication: DEDICATION_TAG NL texts NL END_DEDICATION {$$ = "{\n" + " \"tag\": \"dedication\",\n" + " \"content\": [\n" + " \"" + $3 + "\" ]\n" + "}," ;}
           | {} {$$= "";};
		;

preface: PREFACE_TAG NL texts NL END_PREFACE {$$ ="{\n"+"\t"+" \"tag\": \"preface\",\n" +"\t"+ " \"content\": [\n" +"\t"+ " \"" + $3 + "\" ]\n" +"\t"+ "},\n" ;}
		  ;		
		
		
authornotes: AUTHORNOTES_TAG NL notes NL END_AUTHORNOTES {$$ = ",{\n" + " \"tag\": \"authornotes\",\n" + " \"content\": [\n" +$3+" ]\n" + "}" ;}
		  | {} {$$= "";}
		  ;	
		
		
notes: notes NL note {$$=$1+","+$3;}
		| note {$$=$1;}
		;
		
note: NOTE_TAG NL texts NL END_NOTE {$$ = "{\n" + " \"tag\": \"note\",\n" + " \"content\": [\n" + " \"" + $3 + "\" ]\n" + "}\n" ;}
		;
		
parts: parts NL part {$$=$1+","+$3;}
		| part {$$=$1;}
		;
		
part: t_part NL toc NL chapters NL END_PART {$$=$1+"\t\t"+" \"content\": [\n"+"\t\t\t"+$3+"\t\t"+","+$5+"\t"+" ]\n"+"\t\t"+"}\n";}
		| t_part NL toc NL chapters NL lof NL END_PART {$$=$1+"\t\t"+" \"content\": [\n"+"\t\t\t"+$3+"\t\t"+","+$5+"\t\t"+","+$7+"\t"+" ]\n"+"\t\t"+"}\n";}
		| t_part NL toc NL chapters NL lof NL lot NL END_PART {$$=$1+"\t\t"+" \"content\": [\n"+"\t\t\t"+$3+"\t\t"+","+$5+"\t\t"+","+$7+"\t\t"+","+$9+"\t"+" ]\n"+"\t\t"+"}\n";}
		| t_part NL toc NL chapters NL lot NL END_PART {$$=$1+"\t\t"+" \"content\": [\n"+"\t\t"+$3+"\t\t\t"+","+$5+"\t\t"+","+$7+"\t"+" ]\n"+"\t\t"+"}\n";}
		;

t_part: PART_TAG ID_ATT VALUE_ATT CLOSE_TAG {$$ ="{\n" +"\t"+ " \"tag\": \"part\",\n" + "\t"+" \"id\": "+  $3 + ",\n";}
		| PART_TAG ID_ATT VALUE_ATT TITLE_ATT VALUE_ATT CLOSE_TAG {$$ = "{\n" +"\t"+ " \"tag\": \"part\",\n" + "\t"+" \"id\": "+  $3 + ",\n"+"\t"+" \"title\": "+  $5 + ",\n" ;}
		;
		
lot: LOT_TAG NL items NL END_LOT {$$ ="{\n" +"\t\t" + " \"tag\": \"lot\",\n" +"\t\t" + " \"content\": [\n" + $3 +"\t\t"+ " ]\n"+"}\n" ;}
		;
		
lof: LOF_TAG NL items NL END_LOF  {$$ ="{\n" +"\t\t" + " \"tag\": \"lof\",\n" +"\t\t" + " \"content\": [\n" + $3 + "\t\t"+" ]\n" + "}\n" ;}
		;
		
toc: TOC_TAG NL items NL END_TOC {$$ ="{\n"+ "\t\t" + " \"tag\": \"toc\",\n" + "\t\t"+" \"content\": [\n" + $3 +"\t\t"+" ]\n" + "}\n" ;}													   
		;

items: items NL item {$$=$1+","+$3;}
		| item {$$=$1;}
		;

item: t_item texts END_ITEM {$$=$1+"\t\t\t"+" \"content\": [" + " \"" + $2 + "\" ]\n"+"\t\t\t"+"}\n";}
		;
		
t_item: ITEM_TAG ID_ATT VALUE_ATT CLOSE_TAG {$$ = "\t\t\t"+"{\n" + "\t\t\t" + " \"tag\": \"item\",\n" +"\t\t\t" + " \"id\": "+  $3 + ",\n";}
		;
		
chapters: chapters NL chapter {$$=$1+","+$3;}
		| chapter {$$=$1;}
		;

chapter: t_chapter NL sections NL END_CHAPTER {$$=$1+"\t\t"+" \"content\": [\n"+$3+" ]\n"+"}\n";}

t_chapter: CHAPTER_TAG ID_ATT VALUE_ATT TITLE_ATT VALUE_ATT CLOSE_TAG {$$ ="{\n" +"\t\t"+ " \"tag\": \"chapter\",\n" +"\t\t"+" \"id\": "+  $3 + ",\n"+"\t\t"+" \"title\": "+  $5 + ",\n";}
		;

sections: section {$$=$1;}
		| sections NL section {$$=$1+","+$3;}
		;

section: t_section NL table NL END_SECTION {$$=$1+" \"content\": [\n"+$3+" ]\n"+"}\n";}
		| t_section NL sections NL END_SECTION {$$=$1+" \"content\": [\n"+$3+" ]\n"+"}\n";}
		| t_section NL figure NL END_SECTION {$$=$1+$3+"}\n";}
		| t_section NL texts NL END_SECTION {$$=$1+" \"content\": \"" + $3 + "\"\n"+"}\n";}
		| t_section NL END_SECTION {$$=$1+"}\n";}
		| t_section NL texts NL sections NL texts NL END_SECTION {$$=$1+" \"content\": [\"" + $3 + "\",\n"+$5+", \""+$7+"\""+"]}\n";}
		| t_section NL texts NL sections NL END_SECTION {$$=$1+" \"content\": [\"" + $3 + "\",\n"+$5+"]}\n";}
		| t_section NL texts NL table NL texts NL END_SECTION {$$=$1+" \"content\": [\"" + $3 + "\",\n"+$5+","+"\""+$7 + "\" ]\n"+"}\n";}
		| t_section NL texts NL figure NL texts NL sections NL END_SECTION {$$=$1+" \"content\": [\"" + $3 + "\"\n"+","+$5+",\n\"" + $7 + "\",\n"+$9+"]}\n";}
		| t_section NL texts NL figure NL sections NL END_SECTION {$$=$1+" \"content\": [\"" + $3 + "\"\n"+","+$5+","+$7+"]}\n";}
		;
		
t_section: SECTION_TAG ID_ATT VALUE_ATT TITLE_ATT VALUE_ATT CLOSE_TAG {$$ ="{\n"+" \"tag\": \"section\",\n"+" \"id\": "+  $3 + ",\n"+" \"title\": "+  $5 + ",\n";}
		;
		
figure: FIGURE_TAG ID_ATT VALUE_ATT CAPTION_ATT VALUE_ATT PATH_ATT VALUE_ATT SHORT_CLOSE_TAG {$$ ="{\n"+" \"tag\": \"figure\",\n"+" \"id\": "+  $3 + "," + " \"caption\": "+  $5 + ",\n"+" \"path\": "+  $2 + "}\n";}
		| FIGURE_TAG ID_ATT VALUE_ATT CAPTION_ATT VALUE_ATT SHORT_CLOSE_TAG 	{$$ ="{\n"+" \"tag\": \"figure\",\n"+" \"id\": "+  $3 + "," + " \"caption\": "+  $5 + "}\n";}
		;
		
table: t_table NL rows NL END_TABLE {$$=$1+"\"content\": ["+$3+"]}\n";}
		;

t_table: TABLE_TAG ID_ATT VALUE_ATT CAPTION_ATT VALUE_ATT CLOSE_TAG {$$ ="{\n" + " \"tag\": \"table\",\n"+" \"id\": "+  $3 + ", \"caption\": "+  $5 + ",\n";}
		;

rows: 	row {$$=$1;}
		| rows NL row {$$=$1+","+$3;}
		;
	
row: ROW_TAG NL cells NL END_ROW  {$$ ="{\n" + " \"tag\": \"row\",\n"+" \"content\": [\n" + $3 + " ]\n"+"}" ;}
		;

cells: cell {$$=$1;}
		| cells NL cell {$$=$1+","+$3;}
		;
		
cell: CELL_TAG texts END_CELL  {$$ ="{\n" +" \"tag\": \"cell\",\n"+" \"content\": [\n \""+ $2 + "\" ]\n" + "}" ;}
		;
		
header: XML NL DOCTYPE {$$=$1+$3;}
		;
texts: text {$$=$1.replace("\n", "").replace("\r", "").replace("\t", "");}
	 | texts NL text {$$=$1+$3;}
	 ;
text: PCDATA{$$=$1;}
	;
%%

  private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error + " at " + yychar);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }

  public static void main(String args[]) throws IOException {

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
	  yyparser.yyparse();
    }
    else {
      // interactive mode
      System.out.println("Error: file not found");
    }
  }
