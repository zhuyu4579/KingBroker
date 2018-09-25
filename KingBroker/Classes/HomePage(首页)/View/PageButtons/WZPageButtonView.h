//
//  WZPageButtonView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPageButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (strong, nonatomic) IBOutlet UIButton *buttonFive;
@property (strong, nonatomic) IBOutlet UIButton *buttonSix;

@property (weak, nonatomic) IBOutlet UIButton *newsLable;
@property (strong, nonatomic) IBOutlet UILabel *anNewLabel;

- (IBAction)answerTask:(id)sender;
- (IBAction)findHouses:(id)sender;
- (IBAction)Report:(id)sender;
- (IBAction)Boarding:(id)sender;
- (IBAction)houseBook:(UIButton *)sender;
- (IBAction)videToker:(UIButton *)sender;

- (IBAction)seeNews:(id)sender;


+(instancetype)pageButtons;
@end
