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
    
    HTML_SB,    // html[
    
    C_SB,       // c[
    
    B_SB,       // b[
    
    I_SB,       // i[
    
    U_SB,       // u[
    
    M_SB,       // m[
    
    ID_SB,      // id[
    
    /* block */
    
    H1_SB,      // h1[
    H2_SB,      // h2[
    H3_SB,      // h3[
    H4_SB,      // h4[
    H5_SB,      // h5[
    H6_SB,      // h6[
    
    UL_SB,      // ul[
    OL_SB,      // ol[
    
    TOC_SB,     // toc[
    
    SEC_SB,     // sec[
    
    CODE_SB,    // code[
    
    MATH_SB,    // math[
    
    IMG_SB,     // img[
    
    Q_SB,       // q[
    
    PB_SB,      // pb[
    
    FRONTPAGE_SB,// frontpage[
    
    TITLE_SB,    // title[
    
    /* S T R I N G */
    
    STRING,
    
    /* W H I T S P A C E */
    
    LF,         // \n
    
    END,        // End Of File

} TokenType;









