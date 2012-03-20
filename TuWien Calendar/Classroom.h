


#import <Foundation/Foundation.h>


@interface Classroom : NSObject {
	int classroomId;
	NSString *_address;
	NSString *_name;
	NSString *_location;
	NSString *_type;
	NSString *_pdf_link_cms;

	
	//Building *building;
}
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *pdf_link_cms;

//@property (nonatomic,retain) Building *building;
-(Classroom *)initWithName:(NSString*)name
                   address:(NSString*)address
                  location:(NSString*)location
                      type:(NSString*)type
                   pdflink:(NSString*)pdflink;



@end