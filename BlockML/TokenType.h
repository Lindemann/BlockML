//
//  TokenType.h
//  BlockML
//
//  Created by Lindemann on 02.09.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

typedef enum  _TokenType {
    
    /* K E Y W O R D */
    
    // SB - Sqare Brackets
    OPEN_SB,    // [
    CLOSE_SB,   // ]
    
    // I N L I N E
    
    A_SB,       // a[
    
    FN_SB,      // fn[
    
    FK_SB,       // fk[
    FRA_SB,      // fra[
    
    HTML_SB,    // html[
    
    ICODE_SB,    // icode[
    
    XRA_SB,     // xra[
    
    // S T A N D A L O N E
    
    H1_SB,      // h1[
    H2_SB,      // h2[
    H3_SB,      // h3[
    H4_SB,      // h4[
    H5_SB,      // h5[
    H6_SB,      // h6[
    
    UL_SB,      // ul[
    OL_SB,      // ol[
    
    TITLE,      // title[
    
    TOC_SB,     // toc[
    
    SEC_SB,     // sec[
    
    CODE_SB,    // code[
    
    CODEWC_SB,    // codewc[
    
    MATH_SB,    // math[
    
    FRONTPAGE_SB,// frontpage[
    
    TITLE_SB,    // title[
    
    IMG_SB,     // img[
    IMGWC_SB,   // imgwc[
    
    Q_SB,       // q[
    
    PB_SB,      // pb[
    
    XR_SB,       // xr[
    
    B_SB,       // b[
    I_SB,       // i[
    U_SB,       // u[
    
    /* S T R I N G */
    
    STRING,
    
    /* W H I T S P A C E */
    
    LF,         // \n
    
    END,        // End Of File
    
    /* C O M M E N T */
    
    OPEN_COM,   // /*
    CLOSE_COM,  // */
    
} TokenType;