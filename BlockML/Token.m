//
//  Token.m
//  BlockML
//
//  Created by Lindemann on 02.09.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "Token.h"

@interface Token () <NSCopying>

@end

@implementation Token

- (void)setType:(TokenType)type {
    _type = type;
    if (type != STRING) {
        self.value = nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    Token *copy = [Token new];
    copy.value = [_value copyWithZone:zone];
    copy.type = _type;
    return copy;
}

- (NSString *)description {
    switch (self.type) {
        case STRING:
            return [NSString stringWithFormat: @"%@", self.value];
            break;
        case OPEN_SB:
            return [NSString stringWithFormat: @"["];
            break;
        case CLOSE_SB:
            return [NSString stringWithFormat: @"]"];
            break;
        case H1_SB:
            return [NSString stringWithFormat: @"h1["];
            break;
        case H2_SB:
            return [NSString stringWithFormat: @"h2["];
            break;
        case H3_SB:
            return [NSString stringWithFormat: @"h3["];
            break;
        case H4_SB:
            return [NSString stringWithFormat: @"h4["];
            break;
        case H5_SB:
            return [NSString stringWithFormat: @"h5["];
            break;
        case H6_SB:
            return [NSString stringWithFormat: @"h6["];
            break;
        case TOC_SB:
            return [NSString stringWithFormat: @"toc["];
            break;
        case SEC_SB:
            return [NSString stringWithFormat: @"sec["];
            break;
        case CODE_SB:
            return [NSString stringWithFormat: @"code["];
            break;
        case CODEWC_SB:
            return [NSString stringWithFormat: @"codewc["];
            break;
        case IMG_SB:
            return [NSString stringWithFormat: @"img["];
            break;
        case IMGWC_SB:
            return [NSString stringWithFormat: @"imgwc["];
            break;
        case FN_SB:
            return [NSString stringWithFormat: @"fn["];
            break;
        case B_SB:
            return [NSString stringWithFormat: @"b["];
            break;
        case I_SB:
            return [NSString stringWithFormat: @"i["];
            break;
        case U_SB:
            return [NSString stringWithFormat: @"u["];
            break;
        case UL_SB:
            return [NSString stringWithFormat: @"ul["];
            break;
        case OL_SB:
            return [NSString stringWithFormat: @"ol["];
            break;
        case MATH_SB:
            return [NSString stringWithFormat: @"math["];
            break;
        case A_SB:
            return [NSString stringWithFormat: @"a["];
            break;
        case TITLE_SB:
            return [NSString stringWithFormat: @"title["];
            break;
        case FRONTPAGE_SB:
            return [NSString stringWithFormat: @"frontpage["];
            break;
        case XR_SB:
            return [NSString stringWithFormat: @"xr["];
            break;
        case XRA_SB:
            return [NSString stringWithFormat: @"xra["];
            break;
        case Q_SB:
            return [NSString stringWithFormat: @"q["];
            break;
        case PB_SB:
            return [NSString stringWithFormat: @"pb["];
            break;
        case HTML_SB:
            return [NSString stringWithFormat: @"html["];
            break;
        case ICODE_SB:
            return [NSString stringWithFormat: @"icode["];
            break;
        case FK_SB:
            return [NSString stringWithFormat: @"fk["];
            break;
        case FRA_SB:
            return [NSString stringWithFormat: @"fra["];
            break;
        case OPEN_COM:
            return [NSString stringWithFormat: @"/*"];
            break;
        case CLOSE_COM:
            return [NSString stringWithFormat: @"*/"];
            break;
        case LF:
            return [NSString stringWithFormat: @"LF"];
            break;
        case END:
            return [NSString stringWithFormat: @"END"];
            break;
            
        default:
            return [NSString stringWithFormat: @"%d", self.type];
            break;
    }
}

@end
