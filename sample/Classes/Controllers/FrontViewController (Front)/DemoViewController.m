//
//  DemoViewController.m
//  VidyoClientSample_iOS
//
//  Created by lee on 13-5-7.
//
//

#import "DemoViewController.h"
#import "ASIHTTPRequest.h"
#import "VCFoundation.h"
#import "GDataXMLNode.h"
#import "NSString+Base64.h"
#import "FileItemTableCell.h"
#import "FPPopoverController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController
@synthesize workingMember = _workingMember;
@synthesize tableView = _tableView;
@synthesize editButton = _editButton;
@synthesize entityID = _entityID;
@synthesize inviteArray = _inviteArray;
@synthesize myCountID = _myCountID;
@synthesize participantID = _participantID;
@synthesize sArray = _sArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.inviteArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.sArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.title = kCleanMyConferenceTitle;
    
    NSString *myAccountMessage = [NSString stringWithFormat:
                                  @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                  "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                  "<env:Body>"
                                  "<ns1:MyAccountRequest>"
                                  "</ns1:MyAccountRequest>"
                                  "</env:Body>"
                                  "</env:Envelope>"];
    [self myAccount:myAccountMessage];
    
    NSString *soapotherParticipantMessage = [NSString stringWithFormat:
                                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                             "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                             "<env:Body>"
                                             "<ns1:GetParticipantsRequest>"
                                             "<ns1:conferenceID>%@</ns1:conferenceID>"
                                             "</ns1:GetParticipantsRequest>"
                                             "</env:Body>"
                                             "</env:Envelope>",self.myCountID];
    [self getParticipant:soapotherParticipantMessage];
    
    [self.editButton setTitle:keditButtonTitle];
    [self.startButton setTitle:kstartButtonTitle];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setEditing:YES animated:YES];
    [self.inviteArray removeAllObjects];
}

- (void)getParticipant:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    //    [theRequest addValue: auth forHTTPHeaderField:@"Authorization"];
    
    [theRequest addRequestHeader:@"Authorization" value:auth];
    [theRequest addRequestHeader:@"Host" value:[url host]];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeOutSeconds:60.0];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    NSError *error = [theRequest error];
    if (error) {
        return;
    } else {
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",responseString);
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
        
        NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
        NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:GetParticipantsResponse" namespaces:mapping error:&error];
        if (error) {
            NSLog(@"%@",[error debugDescription]);
        } else {
            for (GDataXMLElement *item in items) {
                NSArray *names = [item elementsForName:@"ns1:Entity"];
                parserObj = [[NSMutableArray alloc] initWithCapacity:0];

                for (GDataXMLElement *name in names) {
                    _workingMember = [[Members alloc] init];
                    GDataXMLElement *entityElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                    NSString *vidyoEntityString = [entityElement stringValue];
                    
                    GDataXMLElement *participantElement = [[name elementsForName:@"ns1:participantID"] objectAtIndex:0];
                    NSString *participantString = [participantElement stringValue];
                        
                    GDataXMLElement *displayNameElement = [[name elementsForName:@"ns1:displayName"] objectAtIndex:0];
                    NSString *displayNameString = [displayNameElement stringValue];
             
                    NSLog(@"%@",displayNameString);
                    self.workingMember.displayName = displayNameString;
                    self.workingMember.entityID = vidyoEntityString;
                    self.workingMember.participantID = participantString;
                    
                    [self.sArray addObject:participantString];
                    [parserObj addObject:_workingMember];
                }
            }
        }
    }
}

- (void)myAccount:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    
    [theRequest addRequestHeader:@"Authorization" value:auth];
    [theRequest addRequestHeader:@"Host" value:[url host]];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeOutSeconds:30.0];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns1", nil];
    NSArray *items = [doc.rootElement nodesForXPath:@"//ns1:MyAccountResponse" namespaces:mapping error:&error];
    if (error) {
        return;
    } else {
//        NSString *responseString = [theRequest responseString];
//        NSLog(@"%@",responseString);
        
        for (GDataXMLElement *displayName in items) {
            NSArray *names = [displayName elementsForName:@"ns1:Entity"];
            
            for (GDataXMLElement *name in names) {
                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns1:entityID"] objectAtIndex:0];
                NSString *entityIDString = [entityIDElement stringValue];

                self.myCountID = entityIDString;
            }
        }
    }
}


//- (void)searchMember:(NSString *)soapMessage
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *potalString = [defaults objectForKey:@"potal"];
//    NSString *nameString = [defaults objectForKey:@"username"];
//    NSString *passwordString = [defaults objectForKey:@"password"];
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
//    
//    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
//    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
//    
//    [theRequest addRequestHeader:@"Authorization" value:auth];
//    [theRequest addRequestHeader:@"Host" value:[url host]];
//    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
//    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
//    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setTimeOutSeconds:60.0];
//    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
//    
//    [theRequest startSynchronous];
//    
//    NSError *error = nil;
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[theRequest responseData] options:0 error:&error];
//    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:@"http://portal.vidyo.com/user",@"ns2", nil];
//    NSArray *items = [doc.rootElement nodesForXPath:@"//ns2:SearchResponse" namespaces:mapping error:&error];
//    if (error) {
//        return;
//    } else {
//        for (GDataXMLElement *displayName in items) {
//            NSArray *names = [displayName elementsForName:@"ns2:Entity"];
//            parserObj = [[NSMutableArray alloc] initWithCapacity:0];
//            
//            for (GDataXMLElement *name in names) {
//                _workingMember = [[Members alloc] init];
//                
//                GDataXMLElement *entityTypeElement = [[name elementsForName:@"ns2:EntityType"] objectAtIndex:0];
//                NSString *entityTypeString = [entityTypeElement stringValue];
//                
//                GDataXMLElement *nameElement = [[name elementsForName:@"ns2:displayName"] objectAtIndex:0];
//                NSString *nameString = [nameElement stringValue];
//                
//                GDataXMLElement *statusElement = [[name elementsForName:@"ns2:MemberStatus"] objectAtIndex:0];
//                NSString *statusString = [statusElement stringValue];
//                
//                GDataXMLElement *extensionElement = [[name elementsForName:@"ns2:extension"] objectAtIndex:0];
//                NSString *extensionString = [extensionElement stringValue];
//                
//                GDataXMLElement *entityIDElement = [[name elementsForName:@"ns2:entityID"] objectAtIndex:0];
//                NSString *entityIDString = [entityIDElement stringValue];
//                                
////                if ([statusString isEqualToString:@"Online"]) {
////                    self.workingMember.displayName = nameString;
////                    self.workingMember.status = statusString;
////                    self.workingMember.extension = extensionString;
////                    self.workingMember.entityID = entityIDString;
////                    self.workingMember.entityType = entityTypeString;
////                    [parserObj addObject:_workingMember];
////                }
//            }
//        }
//    }
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:!self.editing animated:YES];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [parserObj count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FileItemTableCell *cell = (FileItemTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FileItemTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [cell.textLabel.font fontWithSize:17];
    }
    
    Members *m = [parserObj objectAtIndex:indexPath.row];
    cell.textLabel.text = m.displayName;
    [cell setChecked:m.isChecked];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Members *m = [parserObj objectAtIndex:indexPath.row];
    
    self.entityID = m.entityID;
    
    if (self.tableView.editing)
	{
		FileItemTableCell *cell = (FileItemTableCell*)[tableView cellForRowAtIndexPath:indexPath];
        m.isChecked = !m.isChecked;
		[cell setChecked:m.isChecked];
        if (m.isChecked) {
            [_inviteArray addObject:m.participantID];
        } else {
            [_inviteArray removeObject:m.participantID];
        }
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setEditButton:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
}
- (IBAction)editClick:(id)sender
{
    for (int i = 0; i < [_sArray count]; i++) {
        NSString *soapLeaveOtherMessage = [NSString stringWithFormat:
                                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                           "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                           "<env:Body>"
                                           "<ns1:LeaveConferenceRequest>"
                                           "<ns1:conferenceID>%@</ns1:conferenceID>"
                                           "<ns1:participantID>%@</ns1:participantID>"
                                           "</ns1:LeaveConferenceRequest>"
                                           "</env:Body>"
                                           "</env:Envelope>",self.myCountID,[_sArray objectAtIndex:i]];
        [self leaveConfenceByEntityID:soapLeaveOtherMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopClick" object:nil];
//    for (int i = 0; i < [_inviteArray count]; i++) {
//        NSString *soapLeaveOtherMessage = [NSString stringWithFormat:
//                                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
//                                           "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns2=\"http://portal.vidyo.com/user\">"
//                                           "<env:Body>"
//                                           "<ns2:LeaveConferenceRequest>"
//                                           "<ns2:conferenceID>%@</ns2:conferenceID>"
//                                           "<ns2:participantID>%@</ns2:participantID>"
//                                           "</ns2:LeaveConferenceRequest>"
//                                           "</env:Body>"
//                                           "</env:Envelope>",self.myCountID,[_inviteArray objectAtIndex:i]];
//        [self leaveConfenceByEntityID:soapLeaveOtherMessage];
//    }
//    
//    if ([_inviteArray count] > 0) {
//        [_inviteArray removeAllObjects];
//    }
}


- (void)leaveConfenceByEntityID:(NSString *)soapMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *potalString = [defaults objectForKey:@"potal"];
    NSString *nameString = [defaults objectForKey:@"username"];
    NSString *passwordString = [defaults objectForKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/services/VidyoPortalUserService?wsdl", potalString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    NSString *base64 = [[NSString stringWithFormat:@"%@:%@", nameString, passwordString] base64];
    NSString *auth = [NSString stringWithFormat:@"Basic %@", base64];
    //    [theRequest addValue: auth forHTTPHeaderField:@"Authorization"];
    
    [theRequest addRequestHeader:@"Authorization" value:auth];
    [theRequest addRequestHeader:@"Host" value:[url host]];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeOutSeconds:60.0];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [theRequest startSynchronous];
    NSError *error = [theRequest error];
    if (!error) {
//        NSString *responseString = [theRequest responseString];
    }
}



- (IBAction)startClick:(id)sender
{
    for (int i = 0; i < [_inviteArray count]; i++) {
        NSString *soapLeaveOtherMessage = [NSString stringWithFormat:
                                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                           "<env:Envelope xmlns:env=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ns1=\"http://portal.vidyo.com/user\">"
                                           "<env:Body>"
                                           "<ns1:LeaveConferenceRequest>"
                                           "<ns1:conferenceID>%@</ns1:conferenceID>"
                                           "<ns1:participantID>%@</ns1:participantID>"
                                           "</ns1:LeaveConferenceRequest>"
                                           "</env:Body>"
                                           "</env:Envelope>",self.myCountID,[_inviteArray objectAtIndex:i]];
        [self leaveConfenceByEntityID:soapLeaveOtherMessage];
    }
    
    if ([_inviteArray count] > 0) {
        [_inviteArray removeAllObjects];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopClick" object:nil];
}


@end
