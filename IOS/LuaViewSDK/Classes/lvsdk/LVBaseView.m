//
//  LVBaseView.m
//  JU
//
//  Created by dongxicheng on 12/29/14.
//  Copyright (c) 2014 ju.taobao.com. All rights reserved.
//

#import "LVBaseView.h"
#import "LView.h"
#import "LVTransform3D.h"
#import <QuartzCore/QuartzCore.h>
#import "LVStruct.h"
#import <JUFLXLayoutKit/JUFLXLayoutKit.h>

@implementation LVBaseView


-(id) init:(lv_State*) l{
    self = [super init];
    if( self ){
        self.lv_lview = (__bridge LView *)(l->lView);
    }
    return self;
}

static void releaseUserDataView(LVUserDataView* userdata){
    if( userdata && userdata->view ){
        UIView<LVProtocal>* view = CFBridgingRelease(userdata->view);
        userdata->view = NULL;
        if( view ){
            view.lv_userData = nil;
            view.lv_lview = nil;
            [view removeFromSuperview];
        }
    }
}

-(void) dealloc {
}

#pragma -mark center
static int center (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGPoint center = view.center;
            if ( lv_gettop(L)>=2  ) {
                if ( lv_isuserdata(L, 2) ) {
                    LVUserDataStruct* user = lv_touserdata(L, 2);
                    if ( LVIsType(user, LVUserDataStruct) ) {
                        memcpy(&center, user->data, sizeof(CGPoint));
                    } else {
                        LVError(@"LVBaseView.setCenter1");
                    }
                } else {
                    if( lv_isnumber(L, 2) ){
                        center.x = lv_tonumber(L, 2);// 2
                    }
                    if( lv_isnumber(L, 3) ){
                        center.y = lv_tonumber(L, 3);// 3
                    }
                }
                if(  isnan(center.x) || isnan(center.y) ){
                    LVError(@"LVBaseView.setCenter2");
                } else {
                    view.center = center;
                }
                return 0;
            } else {
                lv_pushnumber(L, center.x );
                lv_pushnumber(L, center.y );
                return 2;
            }
        }
    }
    return 0;
}

static int centerX(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGPoint center = view.center;
            if ( lv_gettop(L)>=2  ) {
                if( lv_isnumber(L, 2) ){
                    center.x = lv_tonumber(L, 2);// 2
                }
                if(  isnan(center.x) || isnan(center.y) ){
                    LVError(@"LVBaseView.setCenterX2");
                } else {
                    view.center = center;
                }
                return 0;
            } else {
                lv_pushnumber(L, center.x );
                return 1;
            }
        }
    }
    return 0;
}

static int centerY(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGPoint center = view.center;
            if ( lv_gettop(L)>=2  ) {
                if( lv_isnumber(L, 2) ){
                    center.y = lv_tonumber(L, 2);// 2
                }
                if(  isnan(center.x) || isnan(center.y) ){
                    LVError(@"LVBaseView.setCenterX2");
                } else {
                    view.center = center;
                }
                return 0;
            } else {
                lv_pushnumber(L, center.y );
                return 1;
            }
        }
    }
    return 0;
}

#pragma -mark frame
static int frame (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if( lv_gettop(L)>=2 ) {
                if ( lv_isuserdata(L, 2) ) {
                    LVUserDataStruct* user = lv_touserdata(L, 2);
                    if ( LVIsType(user, LVUserDataStruct) ) {
                        memcpy(&r, user->data, sizeof(CGRect));
                    } else {
                        LVError(@"LVBaseView.setFrame1");
                    }
                } else {
                    if( lv_isnumber(L, 2) ){
                        r.origin.x = lv_tonumber(L, 2);// 2
                    }
                    if( lv_isnumber(L, 3) ){
                        r.origin.y = lv_tonumber(L, 3);// 3
                    }
                    if( lv_isnumber(L, 4) ){
                        r.size.width = lv_tonumber(L, 4);// 4
                    }
                    if( lv_isnumber(L, 5) ){
                        r.size.height = lv_tonumber(L, 5);// 5
                    }
                }
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.setFrame2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.x    );
                lv_pushnumber(L, r.origin.y    );
                lv_pushnumber(L, r.size.width  );
                lv_pushnumber(L, r.size.height );
                return 4;
            }
        }
    }
    return 0;
}

#pragma -mark frame
static int size (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                if ( lv_isuserdata(L, 2) ) {
                    LVUserDataStruct* user = lv_touserdata(L, 2);
                    if ( LVIsType(user, LVUserDataStruct) ) {
                        memcpy(&r.size, user->data, sizeof(CGSize));
                    } else {
                        LVError(@"LVBaseView.setSize1");
                    }
                } else {
                    if( lv_isnumber(L, 2) ){
                        r.size.width = lv_tonumber(L, 2);// 4
                    }
                    if( lv_isnumber(L, 3) ){
                        r.size.height = lv_tonumber(L, 3);// 5
                    }
                }
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.setSize2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.size.width  );
                lv_pushnumber(L, r.size.height );
                return 2;
            }
        }
    }
    return 0;
}

static int origin (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                if ( lv_isuserdata(L, 2) ) {
                    LVUserDataStruct* user = lv_touserdata(L, 2);
                    if ( LVIsType(user, LVUserDataStruct) ) {
                        memcpy(&r.origin, user->data, sizeof(CGPoint));
                    } else {
                        LVError(@"LVBaseView.setOrigin1");
                    }
                } else {
                    if( lv_isnumber(L, 2) ){
                        r.origin.x = lv_tonumber(L, 2);// 2
                    }
                    if( lv_isnumber(L, 3) ){
                        r.origin.y = lv_tonumber(L, 3);// 3
                    }
                }
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.setOrigin2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.x    );
                lv_pushnumber(L, r.origin.y    );
                return 2;
            }
        }
    }
    return 0;
}

static int x (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.origin.x = lv_tonumber(L, 2);// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.x );
                return 1;
            }
        }
    }
    return 0;
}

#pragma - mark flxNode
static int flxChildNodes(lv_State *L)
{
    LVUserDataView *user = (LVUserDataView *)lv_touserdata(L, 1);
    if (user) {
        UIView *view = (__bridge UIView *)(user->view);
        int childNum = lv_gettop(L);
        if (view && childNum>=2 ) {
            NSMutableArray* childs = [[NSMutableArray alloc] init];
            for( int i=2; i<=childNum; i++ ) {
                LVUserDataView * childUser = (LVUserDataView *)lv_touserdata(L, i);
                if( LVIsType(user, LVUserDataView) ) {
                    UIView* temp = (__bridge UIView *)(childUser->view);
                    if( temp ) {
                        [childs addObject:temp.ju_flxNode];
                    }
                }
            }
            view.ju_flxNode.childNodes = childs;
            return 0;
        }
    }
    return 0;
}

static int flxBindingInlineCSS(lv_State *L)
{
    LVUserDataView *user = (LVUserDataView *)lv_touserdata(L, 1);
    UIView *view = (__bridge UIView *)(user->view);
    int childNum = lv_gettop(L);
    if (view && childNum==2) {
        if (lv_type(L, 2) == LV_TSTRING) {
            [view.ju_flxNode bindingInlineCSS:[NSString stringWithUTF8String:lv_tostring(L, 2)]];
            return 0;
        }
    }
    return 0;
}

//static int flxMeasure(lv_State *L)
//{
//    LVUserDataView *user = (LVUserDataView *)lv_touserdata(L, 1);
//    UIView *view = (__bridge UIView *)(user->view);
//    int childNum = lv_gettop(L);
//    if (view && childNum == 2) {
//        if (lv_type(L, 2) == LV_TFUNCTION) {
//            lv_pushvalue(L, 1);
//            lv_pushvalue(L, 2);
//            lv_udataRef(L, USERDATA_FLEX_DELEGATE);
//        }
//        view.ju_flxNode.measure = ^CGSize(CGFloat width) {
//            lv_pushUserdata(L, user );
//            lv_pushUDataRef(L, USERDATA_FLEX_DELEGATE );
//            lv_pushnumber(L, width);
//            lv_runFunctionWithArgs(L, 1, 2);
//            CGSize size = CGSizeZero;
//            size.width = lv_tonumber(L, -2);
//            size.height = lv_tonumber(L, -1);
//            return size;
//        };
//
//    }
//    return 0;
//}

static int flxLayout(lv_State *L)
{
    LVUserDataView *user = (LVUserDataView *)lv_touserdata(L, 1);
    if (user) {
        BOOL async = FALSE;
        int argNum = lv_gettop(L);
        for ( int i=1; i<=argNum; i++ ) {
            if ( lv_type(L, i)==LV_TBOOLEAN ){
                async = lv_toboolean(L, i);
            }
            if( lv_type(L, i) == LV_TFUNCTION ) {
                lv_pushvalue(L, 1);
                lv_pushvalue(L, i);
                lv_udataRef(L, USERDATA_FLEX_DELEGATE);
            }
        }
        UIView *view = (__bridge UIView *)(user->view);
        [view.ju_flxNode layoutAsync:async completionBlock:^{
            lv_pushUserdata(L, user );
            lv_pushUDataRef(L, USERDATA_FLEX_DELEGATE );
            lv_runFunction(L);
        }];
    }
    return 0;
}


static int y (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.origin.y = lv_tonumber(L, 2);// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.y );
                return 1;
            }
        }
    }
    return 0;
}

static int bottom (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.origin.y = lv_tonumber(L, 2)-r.size.height;// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.y + r.size.height );
                return 1;
            }
        }
    }
    return 0;
}

static int right (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.origin.x = lv_tonumber(L, 2)-r.size.width;// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.origin.x + r.size.width );
                return 1;
            }
        }
    }
    return 0;
}

static int width (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.size.width = lv_tonumber(L, 2);// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.size.width );
                return 1;
            }
        }
    }
    return 0;
}

static int height (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            CGRect r = view.frame;
            if ( lv_gettop(L)>=2 ) {
                r.size.height = lv_tonumber(L, 2);// 2
                if( isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height) ){
                    LVError(@"LVBaseView.y2: %s", NSStringFromCGRect(r) );
                } else {
                    view.frame = r;
                }
                return 0;
            } else {
                lv_pushnumber(L, r.size.height );
                return 1;
            }
        }
    }
    return 0;
}

static int addGestureRecognizer (lv_State *L) {
    LVUserDataView * userDataView = (LVUserDataView *)lv_touserdata(L, 1);
    LVUserDataGesture * userDataGesture = (LVUserDataGesture *)lv_touserdata(L, 2);
    if( userDataView && LVIsType(userDataGesture,LVUserDataGesture) ){
        UIView* view = (__bridge UIView *)(userDataView->view);
        UIGestureRecognizer* gesture = (__bridge UIGestureRecognizer *)(userDataGesture->gesture);
        if( view && gesture ){
            [view addGestureRecognizer:gesture];
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int removeGestureRecognizer (lv_State *L) {
    LVUserDataView * userDataView = (LVUserDataView *)lv_touserdata(L, 1);
    LVUserDataGesture * userDataGesture = (LVUserDataGesture *)lv_touserdata(L, 2);
    if( userDataView && LVIsType(userDataGesture,LVUserDataGesture) ){
        UIView* view = (__bridge UIView *)(userDataView->view);
        UIGestureRecognizer* gesture = (__bridge UIGestureRecognizer *)(userDataGesture->gesture);
        if( view && gesture ){
            [view removeGestureRecognizer:gesture];
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int addSubview (lv_State *L) {
    LVUserDataView * father = (LVUserDataView *)lv_touserdata(L, 1);
    LVUserDataView * son = (LVUserDataView *)lv_touserdata(L, 2);
    if( father &&  LVIsType(son,LVUserDataView) ){
        UIView* viewRoot = (__bridge UIView *)(father->view);
        UIView* viewSub = (__bridge UIView *)(son->view);
        if( viewRoot && viewSub ){
            if ( viewSub.superview!= viewRoot ) {
                [viewSub removeFromSuperview];
                [viewRoot addSubview:viewSub];
            }
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int removeFromSuperview (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            [view removeFromSuperview];
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int removeAllSubviews (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            while (view.subviews.count) {
                UIView* child = view.subviews.lastObject;
                [child removeFromSuperview];
            }
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

#pragma -mark hidden
static int hidden(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            if ( lv_gettop(L)>=2 ) {
                BOOL yes = lvL_checkbool(L, 2);
                view.hidden = yes;
                return 0;
            } else {
                lv_pushboolean(L, view.hidden );
                return 1;
            }
        }
    }
    return 0;
}

static int becomeFirstResponder(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            if( view.canBecomeFirstResponder )
                [view becomeFirstResponder];
            
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int resignFirstResponder(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            if( view.canResignFirstResponder)
                [view resignFirstResponder];
            
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

static int isFirstResponder(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            lv_pushboolean(L, view.isFirstResponder?1:0 );
            return 1;
        }
    }
    return 0;
}

#pragma -mark userInteractionEnabled
static int userInteractionEnabled(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            if ( lv_gettop(L)>=2 ) {
                BOOL yes = lvL_checkbool(L, 2);
                view.userInteractionEnabled = yes;
                return 0;
            } else {
                lv_pushboolean(L, view.userInteractionEnabled );
                return 1;
            }
        }
    }
    return 0;
}

#pragma -mark backgroundColor
static int backgroundColor (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            NSUInteger color = lv_tonumber(L, 2);// 2
            float a = ( (color>>24)&0xff )/255.0;
            float r = ( (color>>16)&0xff )/255.0;
            float g = ( (color>>8)&0xff )/255.0;
            float b = ( (color>>0)&0xff )/255.0;
            float alpha = 1;
            if( lv_gettop(L)>=3 ) {
                alpha = lv_tonumber(L, 3);
            }
            if( a <= 0 ){
                a =  alpha;
            }
            if( a > 1 ){
                a = 1;
            }
            if( [view isKindOfClass:[UIView class]] ){
                view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
                return 0;
            }
        } else {
            UIColor* color = view.backgroundColor;
            NSUInteger c = 0;
            float a = 0;
            if( lv_uicolor2int(color, &c, &a) ){
                lv_pushnumber(L, c );
                lv_pushnumber(L, a );
                return 2;
            }
        }
    }
    return 0;
}

#pragma -mark alpha
static int alpha (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if ( lv_gettop(L)>=2 ) {
            double alpha = lv_tonumber(L, 2);// 2
            view.alpha = alpha;
            return 0;
        } else {
            float alpha = view.alpha;
            lv_pushnumber(L, alpha );
            return 1;
        }
    }
    return 0;
}

#pragma -mark cornerRadius
static int cornerRadius (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double r = lv_tonumber(L, 2);// 2
            view.layer.cornerRadius = r;
            return 0;
        } else {
            float r = view.layer.cornerRadius;
            lv_pushnumber(L, r );
            return 1;
        }
    }
    return 0;
}

#pragma -mark borderWidth
static int borderWidth (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double width = lv_tonumber(L, 2);// 2
            view.layer.borderWidth = width;
            return 0;
        } else {
            float w = view.layer.borderWidth;
            lv_pushnumber(L, w );
            return 1;
        }
    }
    return 0;
}

#pragma -mark shadow
static int setShadowPath (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        [view layer].shadowPath =[UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}
static int setMasksToBounds (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    BOOL masksToBounds = lvL_checkbool(L, 2);// 2
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        view.layer.masksToBounds = masksToBounds;
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}

static int setShadowOffset (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    float x = lv_tonumber(L, 2);// 2
    float y = lv_tonumber(L, 3);// 2
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        [view.layer setShadowOffset:CGSizeMake(x, y)];
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}

static int setShadowRadius (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    float radius = lv_tonumber(L, 2);// 2
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        [view.layer setShadowRadius:radius];
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}

static int setShadowOpacity (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    float opacity = lv_tonumber(L, 2);// 2
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        [view.layer setShadowOpacity:opacity];
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}

static int setShadowColor (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    int color = lv_tonumber(L, 2);// 2
    float alpha = 1;
    if( lv_gettop(L)>=3 ) {
        alpha = lv_tonumber(L, 3);// 2
    }
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        [view.layer setShadowColor:lv_UIColorFromRGBA(color, alpha).CGColor];
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}


#pragma -mark borderColor

UIColor* lv_UIColorFromRGBA(NSInteger rgbValue, float alphaValue){
    return [UIColor
         colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
         green:       ((float)((rgbValue & 0x00FF00) >> 8 ))/255.0
         blue:        ((float)((rgbValue & 0x0000FF)      ))/255.0
         alpha:alphaValue];

}

static int borderColor (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if ( lv_gettop(L)>=2 ) {
            int color = lv_tonumber(L, 2);// 2
            float alpha = 1;
            if( lv_gettop(L)>=3 ) {
                alpha = lv_tonumber(L, 3);// 2
            }
            view.layer.borderColor = lv_UIColorFromRGBA(color, alpha).CGColor;
            lv_pushvalue(L,1);
            return 1;
        } else {
            UIColor* color = [UIColor colorWithCGColor:view.layer.borderColor];
            NSUInteger c = 0;
            float a = 0;
            if( lv_uicolor2int(color, &c, &a) ){
                lv_pushnumber(L, c );
                lv_pushnumber(L, a );
                return 2;
            }
        }
    }
    return 0;
}

#pragma -mark clipsToBounds
static int clipsToBounds(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            if( lv_gettop(L)>=2 ) {
                BOOL yes = lvL_checkbool(L, 2);
                view.clipsToBounds = yes;
                return 0;
            } else {
                lv_pushnumber(L, view.clipsToBounds );
                return 1;
            }
        }
    }
    return 0;
}

static int sizeToFit(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( view ){
            [view sizeToFit];
            lv_pushvalue(L,1);
            return 1;
        }
    }
    return 0;
}

#pragma -mark transformRoteAndScale
static int transformRoteAndScale (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    double angle = lv_tonumber(L, 2);
    double scaleX = 1;
    double scaleY = 1;
    if( user ){
        if( lv_isnumber(L, 3) ){
            scaleX = lv_tonumber(L, 3);
        } else {
            scaleX = 1;
        }
        if( lv_isnumber(L, 4) ){
            scaleY = lv_tonumber(L, 4);
        } else {
            scaleY = 1;
        }
        UIView* view = (__bridge UIView *)(user->view);
        CGAffineTransform tran1 = CGAffineTransformMakeScale(scaleX, scaleY);
        CGAffineTransform tran2 = CGAffineTransformMakeRotation(angle);
        view.transform = CGAffineTransformConcat(tran1, tran2);
        lv_pushvalue(L,1);
        return 1;
    }
    return 0;
}

static int rotation (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double angle = lv_tonumber(L, 2);
            view.lv_rotation = angle;
            CATransform3D tX = CATransform3DMakeRotation(view.lv_rotationX, 1, 0, 0);
            CATransform3D tY = CATransform3DMakeRotation(view.lv_rotationY, 0, 1, 0);
            CATransform3D tZ = CATransform3DMakeRotation(view.lv_rotation, 0, 0, 1);
            CATransform3D r = CATransform3DConcat(tX, tY);
            r = CATransform3DConcat(r, tZ);
            view.layer.transform = r;
            lv_pushvalue(L,1);
            return 1;
        } else {
            lv_pushnumber(L, view.lv_rotationX);
            return 1;
        }
    }
    return 0;
}

static int rotationX (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double angle = lv_tonumber(L, 2);
            view.lv_rotationX = angle;
            CATransform3D tX = CATransform3DMakeRotation(view.lv_rotationX, 1, 0, 0);
            CATransform3D tY = CATransform3DMakeRotation(view.lv_rotationY, 0, 1, 0);
            CATransform3D tZ = CATransform3DMakeRotation(view.lv_rotation, 0, 0, 1);
            CATransform3D r = CATransform3DConcat(tX, tY);
            r = CATransform3DConcat(r, tZ);
            view.layer.transform = r;
            return 1;
        } else {
            lv_pushnumber(L, view.lv_rotationX);
            return 1;
        }
    }
    return 0;
}

static int rotationY (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double angle = lv_tonumber(L, 2);
            view.lv_rotationY = angle;
            CATransform3D tX = CATransform3DMakeRotation(view.lv_rotationX, 1, 0, 0);
            CATransform3D tY = CATransform3DMakeRotation(view.lv_rotationY, 0, 1, 0);
            CATransform3D tZ = CATransform3DMakeRotation(view.lv_rotation, 0, 0, 1);
            CATransform3D r = CATransform3DConcat(tX, tY);
            r = CATransform3DConcat(r, tZ);
            view.layer.transform = r;
        } else {
            lv_pushnumber(L, view.lv_rotationY);
            return 1;
        }
    }
    return 0;
}

static int scale (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        int argNum = lv_gettop(L);
        if ( argNum >=2 ) {
            double scaleX = lv_tonumber(L, 2);
            view.lv_scaleX = scaleX;
            if( argNum>=3 ) {
                double scaleY = lv_tonumber(L, 3);
                view.lv_scaleY = scaleY;
            }
            CGAffineTransform tran1 = CGAffineTransformMakeScale(view.lv_scaleX, view.lv_scaleY);
            CGAffineTransform tran2 = CGAffineTransformMakeRotation(view.lv_rotation);
            view.transform = CGAffineTransformConcat(tran1, tran2);
            lv_pushvalue(L,1);
            return 1;
        } else {
            lv_pushnumber(L, view.lv_scaleX);
            lv_pushnumber(L, view.lv_scaleY);
            return 2;
        }
    }
    return 0;
}

static int scaleX (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if ( lv_gettop(L)>=2 ) {
            double scaleX = lv_tonumber(L, 2);
            view.lv_scaleX = scaleX;
            CGAffineTransform tran1 = CGAffineTransformMakeScale(view.lv_scaleX, view.lv_scaleY);
            CGAffineTransform tran2 = CGAffineTransformMakeRotation(view.lv_rotation);
            view.transform = CGAffineTransformConcat(tran1, tran2);
            lv_pushvalue(L,1);
            return 1;
        } else {
            lv_pushnumber(L, view.lv_scaleX);
            return 1;
        }
    }
    return 0;
}

static int scaleY (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double scaleY = lv_tonumber(L, 2);
            view.lv_scaleY = scaleY;
            CGAffineTransform tran1 = CGAffineTransformMakeScale(view.lv_scaleX, view.lv_scaleY);
            CGAffineTransform tran2 = CGAffineTransformMakeRotation(view.lv_rotation);
            view.transform = CGAffineTransformConcat(tran1, tran2);
            lv_pushvalue(L,1);
            return 1;
        } else {
            lv_pushnumber(L, view.lv_scaleY);
            return 1;
        }
    }
    return 0;
}

static int transform3D (lv_State *L) {
    LVUserDataView* user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if ( lv_gettop(L)>=2 ) {
            LVUserDataTransform3D* transform = (LVUserDataTransform3D *)lv_touserdata(L, 2);
            if ( LVIsType(transform, LVUserDataTransform3D)) {
                view.layer.transform = transform->transform;
                return 0;
            }
        } else {
            CATransform3D t = view.layer.transform;
            [LVTransform3D pushTransform3D:L transform3d:t];
            return 1;
        }
    }
    return 0;
}

#pragma -mark anchorPoint
static int anchorPoint (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView* view = (__bridge UIView *)(user->view);
        if( lv_gettop(L)>=2 ) {
            double x = lv_tonumber(L, 2);// 2
            double y = lv_tonumber(L, 3);// 3
            view.layer.anchorPoint = CGPointMake(x, y);
            return 0;
        } else {
            CGPoint p = view.layer.anchorPoint;
            lv_pushnumber(L, p.x );
            lv_pushnumber(L, p.y );
            return 2;
        }
    }
    return 0;
}

static int delegate (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        if ( lv_gettop(L)>=2 ) {
            lv_settop(L, 2);
            lv_udataRef(L, USERDATA_KEY_DELEGATE);
            return 1;
        } else {
            lv_pushUDataRef(L, USERDATA_KEY_DELEGATE);
            return 1;
        }
    }
    return 0;
}

#pragma -mark __gc
static int __gc (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    releaseUserDataView(user);
    return 0;
}

static int __tostring (lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        UIView<LVProtocal>* view = (__bridge UIView<LVProtocal> *)(user->view);
        if( view ){
            NSString* s = [NSString stringWithFormat:@"%@",view];
            lv_pushstring(L, s.UTF8String);
            return 1;
        }
    }
    return 0;
}

static int releaseObject(lv_State *L) {
    LVUserDataView * user = (LVUserDataView *)lv_touserdata(L, 1);
    if( user ){
        //[LVUtil unregistry:L key:(__bridge id)user->view];
        UIView* view = (__bridge UIView *)(user->view);
        user->view = NULL;
        if( [view isKindOfClass:[LView class]] ){
            LView* lView = (LView*)view;
            lv_stopAndExitNow(lView.l);
        }
        [view removeFromSuperview];
    }
    return 0;
}
//---------------------------
static int __newindex (lv_State *L) {
    NSString* key = lv_paramString(L, 2);
    if( key ){
        lv_getmetatable( L, 1 );
        lv_getfield(L, -1, key.UTF8String);
        if( lv_type(L, -1)==LV_TFUNCTION ) {
            lv_CFunction function =  lv_tocfunction(L,-1);
            if( function ) {
                lv_remove(L, 2);
                lv_settop(L, 2);
                return function(L);
            }
        }
    }
    LVError(@"not found property: %@", key);
    return 0;
}

static const struct lvL_reg baseMemberFunctions [] = {
    {"setHidden", hidden },
    {"hidden",    hidden },
    
    {"setUserInteractionEnabled", userInteractionEnabled },
    {"userInteractionEnabled",    userInteractionEnabled },
    
    {"setEnabled", userInteractionEnabled },
    {"enabled",    userInteractionEnabled },
    
    {"setBackgroundColor",  backgroundColor },
    {"backgroundColor",     backgroundColor },
    
    {"setAlpha",    alpha },
    {"alpha",       alpha },
    
    {"setCornerRadius",     cornerRadius },
    {"cornerRadius",        cornerRadius },
    
    {"setBorderWidth",      borderWidth },
    {"borderWidth",         borderWidth },
    
    {"setBorderColor",      borderColor },
    {"borderColor",         borderColor },
    
    {"setClipsToBounds",    clipsToBounds },
    {"clipsToBounds",       clipsToBounds },
    
    
    {"setShadowPath",       setShadowPath },
    {"setMasksToBounds",    setMasksToBounds },
    {"setShadowOffset",     setShadowOffset },
    {"setShadowRadius",     setShadowRadius },
    {"setShadowOpacity",    setShadowOpacity },
    {"setShadowColor",      setShadowColor },
    
    {"setFrame",  frame },
    {"frame",     frame },
    
    {"setSize",  size },
    {"size",     size },
    
    {"setOrigin",  origin },
    {"origin",     origin },
    
    {"setXY",  origin },
    {"xy",     origin },
    
    
    {"setCenter", center},
    {"center",    center},
    
    {"centerX",    centerX},
    {"setCenterX",    centerX},
    {"centerY",    centerY},
    {"setCenterY",    centerY},
    
    {"x",    x},
    {"setX", x},
    
    {"y",    y},
    {"setY", y},
    
    
    {"left", x},
    {"setLeft", x},
    
    {"top",     y},
    {"setTop",  y},
    
    {"bottom", bottom},
    {"setBottom", bottom},
    
    {"right",  right},
    {"setRight",  right},
    
    {"width",    width},
    {"setWidth", width},
    
    {"height",    height},
    {"setHeight", height},
    
    {"sizeToFit", sizeToFit},
    
    {"addGestureRecognizer",          addGestureRecognizer },
    {"removeGestureRecognizer",       removeGestureRecognizer },
    
    {"addSubView",          addSubview },
    {"addSubview",          addSubview },
    {"addView",          addSubview },
    
    {"removeFromSuperView", removeFromSuperview },
    {"removeFromSuperview", removeFromSuperview },
    {"removeFromSuper", removeFromSuperview },
    
    {"removeAllSubviews", removeAllSubviews },
    {"removeAllViews", removeAllSubviews },
    
    {"transformRoteAndScale", transformRoteAndScale },
    {"roteAndScale", transformRoteAndScale },
    
    {"rotation", rotation },
    {"rotationX", rotationX },
    {"rotationY", rotationY },
    
    {"setRotation", rotation },
    {"setRotationX", rotationX },
    {"setRotationY", rotationY },
    
    {"scaleX", scaleX },
    {"scaleY", scaleY },
    {"setScaleX", scaleX },
    {"setScaleY", scaleY },
    
    {"scale", scale },
    {"setScale", scale },
    
    {"setAnchorPoint",  anchorPoint },
    {"anchorPoint",     anchorPoint },
    
    {"setDelegate",  delegate },
    {"delegate",     delegate },
    {"setCallback",  delegate },
    {"callback",     delegate },
    
    {"isFirstResponder",        isFirstResponder },
    {"becomeFirstResponder",    becomeFirstResponder },
    {"resignFirstResponder",    resignFirstResponder },
    
    {"hasFocus",        isFirstResponder },
    {"requestFocus",    becomeFirstResponder },
    {"cancelFocus",    resignFirstResponder },
    
    
    {"setTransform3D", transform3D },
    {"transform3D",    transform3D },
    
    {"release",     releaseObject},
    
    {"__gc",        __gc },
    
    {"__tostring",  __tostring},
    
    {"__newindex",  __newindex },
    
    {"flxChildNodes",  flxChildNodes },
    {"flxLayout",  flxLayout },
    {"flxBindingCSS", flxBindingInlineCSS},
    
    {NULL, NULL}
};

+(const lvL_reg*) baseMemberFunctions{
    return baseMemberFunctions;
}

#pragma -mark UIView
static int lvNewView (lv_State *L) {
    LVBaseView* view = [[LVBaseView alloc] init:L];
    {
        NEW_USERDATA(userData, LVUserDataView);
        userData->view = CFBridgingRetain(view);
        view.lv_userData = userData;
        
        lvL_getmetatable(L, META_TABLE_UIView );
        lv_setmetatable(L, -2);
        
        LView* lView = (__bridge LView *)(L->lView);
        if( lView ){
            [lView addSubview:view];
        }
    }
    return 1; /* new userdatum is already on the stack */
}

+(int) classDefine: (lv_State *)L {
    {
        lv_pushcfunction(L, lvNewView);
        lv_setglobal(L, "UIView");
    }
    lv_createClassMetaTable(L, META_TABLE_UIView);
    
    lvL_openlib(L, NULL, [LVBaseView baseMemberFunctions], 0);
    return 1;
}

//----------------------------------------------------------------------------------------

-(NSString*) description{
    return [NSString stringWithFormat:@"<UIView(0x%x) frame = %@>", (int)[self hash], NSStringFromCGRect(self.frame) ];
}

@end