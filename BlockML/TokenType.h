//
//  TokenType.h
//  BlockML
//
//  Created by Lindemann on 02.09.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

typedef enum {
    
    /* K E Y W O R D */
    
    /* sqare brackets */
    
    OPEN_SB,    // [
    CLOSE_SB,   // ]
    
    /* inline */
    
    A_SB,       // a[
    
    FN_SB,      // fn[
    
    IHTML_SB,    // ihtml[
    
    SUB_SB,     // sub[
    SUP_SB,     // sup[
    B_SB,       // b[
    C_SB,       // c[
    I_SB,       // i[
    M_SB,       // m[
    S_SB,       // s[
    U_SB,       // u[
    
    IM_SB,      // im[
    
    ID_SB,      // id[
    
    /* block */
    
    H1_SB,      // h1[
    H2_SB,      // h2[
    H3_SB,      // h3[
    H4_SB,      // h4[
    H5_SB,      // h5[
    H6_SB,      // h6[
    
    TABLE_SB,   // table[
    TR_SB,      // tr[
    TH_SB,      // th[
    TD_SB,      // td[
    
    UL_SB,      // ul[
    OL_SB,      // ol[
    
    TOC_SB,     // toc[
    
    SEC_SB,     // sec[
    
    CODE_SB,    // code[
    
    MATH_SB,    // math[
    
    HTML_SB,    // html[
    
    IMG_SB,     // img[
    
    CAP_SB,     // cap[
    
    BIB_SB,     // bib[
    
    Q_SB,       // q[
    
    PB_SB,      // pb[
    
    FP_SB,// frontpage[
    
    TITLE_SB,    // title[
    
    /* S T R I N G */
    
    STRING,
    
    /* W H I T S P A C E */
    
    LF,         // \n
    
    END,        // End Of File

} TokenType;









