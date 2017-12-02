
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 a0 78 10 	movl   $0x801078a0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010005b:	e8 10 42 00 00       	call   80104270 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006c:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100076:	0c 11 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 a7 78 10 	movl   $0x801078a7,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 40 00 00       	call   80104160 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 0d 11 80       	mov    0x80110d10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 75 42 00 00       	call   80104360 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f1:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100161:	e8 ea 42 00 00       	call   80104450 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 40 00 00       	call   801041a0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 12 20 00 00       	call   80102190 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ae 78 10 80 	movl   $0x801078ae,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 8b 40 00 00       	call   80104240 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 c7 1f 00 00       	jmp    80102190 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 bf 78 10 80 	movl   $0x801078bf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 4a 40 00 00       	call   80104240 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3f 00 00       	call   80104200 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100209:	e8 52 41 00 00       	call   80104360 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 fb 41 00 00       	jmp    80104450 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 c6 78 10 80 	movl   $0x801078c6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 79 15 00 00       	call   80101800 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 cd 40 00 00       	call   80104360 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 b3 34 00 00       	call   80103760 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 b5 10 	movl   $0x8010b520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
801002c3:	e8 38 3b 00 00       	call   80103e00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cd:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 3a 41 00 00       	call   80104450 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 02 14 00 00       	call   80101720 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010032f:	e8 1c 41 00 00       	call   80104450 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 e4 13 00 00       	call   80101720 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 55 24 00 00       	call   801027d0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 cd 78 10 80 	movl   $0x801078cd,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 48 79 10 80 	movl   $0x80107948,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 dc 3e 00 00       	call   80104290 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 e1 78 10 80 	movl   $0x801078e1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 a2 57 00 00       	call   80105bb0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 f2 56 00 00       	call   80105bb0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 e6 56 00 00       	call   80105bb0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 da 56 00 00       	call   80105bb0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 40 00 00       	call   80104540 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3f 00 00       	call   801044a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 e5 78 10 80 	movl   $0x801078e5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 10 79 10 80 	movzbl -0x7fef86f0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 f9 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 4d 3d 00 00       	call   80104360 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100636:	e8 15 3e 00 00       	call   80104450 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 da 10 00 00       	call   80101720 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801006f3:	e8 58 3d 00 00       	call   80104450 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 f8 78 10 80       	mov    $0x801078f8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100797:	e8 c4 3b 00 00       	call   80104360 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 ff 78 10 80 	movl   $0x801078ff,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801007c5:	e8 96 3b 00 00       	call   80104360 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801007f7:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100827:	e8 24 3c 00 00       	call   80104450 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 0f 11 80    	mov    0x80110fa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008b2:	e8 e9 36 00 00       	call   80103fa0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008c5:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ec:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 64 37 00 00       	jmp    80104090 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 08 79 10 	movl   $0x80107908,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100965:	e8 06 39 00 00       	call   80104270 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 19 11 80 f0 	movl   $0x801005f0,0x8011196c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 84 19 00 00       	call   80102320 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 af 2d 00 00       	call   80103760 <myproc>
801009b1:	89 c6                	mov    %eax,%esi
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();
801009b3:	e8 c8 21 00 00       	call   80102b80 <begin_op>

  if((ip = namei(path)) == 0){
801009b8:	8b 45 08             	mov    0x8(%ebp),%eax
801009bb:	89 04 24             	mov    %eax,(%esp)
801009be:	e8 ad 15 00 00       	call   80101f70 <namei>
801009c3:	85 c0                	test   %eax,%eax
801009c5:	89 c3                	mov    %eax,%ebx
801009c7:	0f 84 bb 02 00 00    	je     80100c88 <exec+0x2e8>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009cd:	89 04 24             	mov    %eax,(%esp)
801009d0:	e8 4b 0d 00 00       	call   80101720 <ilock>
  pgdir = 0;
	cprintf("exec called by proc pid %d \n", curproc->pid);
801009d5:	8b 46 10             	mov    0x10(%esi),%eax
801009d8:	c7 04 24 2d 79 10 80 	movl   $0x8010792d,(%esp)
801009df:	89 44 24 04          	mov    %eax,0x4(%esp)
801009e3:	e8 68 fc ff ff       	call   80100650 <cprintf>
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009e8:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009ee:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009f5:	00 
801009f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009fd:	00 
801009fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a02:	89 1c 24             	mov    %ebx,(%esp)
80100a05:	e8 c6 0f 00 00       	call   801019d0 <readi>
80100a0a:	83 f8 34             	cmp    $0x34,%eax
80100a0d:	74 21                	je     80100a30 <exec+0x90>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a0f:	89 1c 24             	mov    %ebx,(%esp)
80100a12:	e8 69 0f 00 00       	call   80101980 <iunlockput>
    end_op();
80100a17:	e8 d4 21 00 00       	call   80102bf0 <end_op>
  }
  return -1;
80100a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a21:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a27:	5b                   	pop    %ebx
80100a28:	5e                   	pop    %esi
80100a29:	5f                   	pop    %edi
80100a2a:	5d                   	pop    %ebp
80100a2b:	c3                   	ret    
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;
	cprintf("exec called by proc pid %d \n", curproc->pid);
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a30:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a37:	45 4c 46 
80100a3a:	75 d3                	jne    80100a0f <exec+0x6f>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a3c:	e8 cf 64 00 00       	call   80106f10 <setupkvm>
80100a41:	85 c0                	test   %eax,%eax
80100a43:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a49:	74 c4                	je     80100a0f <exec+0x6f>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a4b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a52:	00 
80100a53:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a59:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a60:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a63:	0f 84 e8 00 00 00    	je     80100b51 <exec+0x1b1>
80100a69:	31 c0                	xor    %eax,%eax
80100a6b:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100a71:	89 c6                	mov    %eax,%esi
80100a73:	eb 18                	jmp    80100a8d <exec+0xed>
80100a75:	8d 76 00             	lea    0x0(%esi),%esi
80100a78:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a7f:	83 c6 01             	add    $0x1,%esi
80100a82:	83 c7 20             	add    $0x20,%edi
80100a85:	39 f0                	cmp    %esi,%eax
80100a87:	0f 8e be 00 00 00    	jle    80100b4b <exec+0x1ab>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a8d:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a93:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a9a:	00 
80100a9b:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100aa3:	89 1c 24             	mov    %ebx,(%esp)
80100aa6:	e8 25 0f 00 00       	call   801019d0 <readi>
80100aab:	83 f8 20             	cmp    $0x20,%eax
80100aae:	0f 85 84 00 00 00    	jne    80100b38 <exec+0x198>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ab4:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100abb:	75 bb                	jne    80100a78 <exec+0xd8>
      continue;
    if(ph.memsz < ph.filesz)
80100abd:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ac3:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ac9:	72 6d                	jb     80100b38 <exec+0x198>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100acb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ad1:	72 65                	jb     80100b38 <exec+0x198>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ad7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100add:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ae1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ae7:	89 04 24             	mov    %eax,(%esp)
80100aea:	e8 61 61 00 00       	call   80106c50 <allocuvm>
80100aef:	85 c0                	test   %eax,%eax
80100af1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100af7:	74 3f                	je     80100b38 <exec+0x198>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100af9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100aff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b04:	75 32                	jne    80100b38 <exec+0x198>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b06:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b16:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b1a:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b1e:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b24:	89 04 24             	mov    %eax,(%esp)
80100b27:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b2b:	e8 50 60 00 00       	call   80106b80 <loaduvm>
80100b30:	85 c0                	test   %eax,%eax
80100b32:	0f 89 40 ff ff ff    	jns    80100a78 <exec+0xd8>
	
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b38:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b3e:	89 04 24             	mov    %eax,(%esp)
80100b41:	e8 4a 63 00 00       	call   80106e90 <freevm>
80100b46:	e9 c4 fe ff ff       	jmp    80100a0f <exec+0x6f>
80100b4b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b51:	89 1c 24             	mov    %ebx,(%esp)
80100b54:	e8 27 0e 00 00       	call   80101980 <iunlockput>
  end_op();
80100b59:	e8 92 20 00 00       	call   80102bf0 <end_op>
  ip = 0;

  sz = PGROUNDUP(sz);
80100b5e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
	clearpteu(pgdir, (char*)sz);
80100b64:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100b6a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b6f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b75:	81 a5 ec fe ff ff 00 	andl   $0xfffff000,-0x114(%ebp)
80100b7c:	f0 ff ff 
	clearpteu(pgdir, (char*)sz);
80100b7f:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b85:	89 3c 24             	mov    %edi,(%esp)
80100b88:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8c:	e8 2f 64 00 00       	call   80106fc0 <clearpteu>
  sp = sz;
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
  if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
80100b91:	c7 44 24 08 00 00 00 	movl   $0x80000000,0x8(%esp)
80100b98:	80 
80100b99:	c7 44 24 04 00 e0 ff 	movl   $0x7fffe000,0x4(%esp)
80100ba0:	7f 
80100ba1:	89 3c 24             	mov    %edi,(%esp)
80100ba4:	e8 a7 60 00 00       	call   80106c50 <allocuvm>
80100ba9:	85 c0                	test   %eax,%eax
80100bab:	0f 84 e4 01 00 00    	je     80100d95 <exec+0x3f5>
		panic("stack allocation failed");
		goto bad;
	}
	sp = tstack+PGSIZE;
  clearpteu(pgdir, (char*)(tstack+PGSIZE));
80100bb1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bb7:	c7 44 24 04 00 f0 ff 	movl   $0x7ffff000,0x4(%esp)
80100bbe:	7f 
80100bbf:	89 04 24             	mov    %eax,(%esp)
80100bc2:	e8 f9 63 00 00       	call   80106fc0 <clearpteu>

	cprintf("stack begins at addr %x \n", sp);
80100bc7:	c7 44 24 04 00 f0 ff 	movl   $0x7ffff000,0x4(%esp)
80100bce:	7f 
80100bcf:	c7 04 24 62 79 10 80 	movl   $0x80107962,(%esp)
80100bd6:	e8 75 fa ff ff       	call   80100650 <cprintf>
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bde:	8b 00                	mov    (%eax),%eax
80100be0:	85 c0                	test   %eax,%eax
80100be2:	0f 84 99 01 00 00    	je     80100d81 <exec+0x3e1>
80100be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	tstack = USEREND - 2*PGSIZE;
  if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
		panic("stack allocation failed");
		goto bad;
	}
	sp = tstack+PGSIZE;
80100beb:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
80100bf0:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100bf6:	8d 51 04             	lea    0x4(%ecx),%edx
  clearpteu(pgdir, (char*)(tstack+PGSIZE));

	cprintf("stack begins at addr %x \n", sp);
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf9:	89 cf                	mov    %ecx,%edi
80100bfb:	31 c9                	xor    %ecx,%ecx
80100bfd:	89 ce                	mov    %ecx,%esi
80100bff:	eb 2d                	jmp    80100c2e <exec+0x28e>
80100c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c0e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c14:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
	sp = tstack+PGSIZE;
  clearpteu(pgdir, (char*)(tstack+PGSIZE));

	cprintf("stack begins at addr %x \n", sp);
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c1b:	83 c6 01             	add    $0x1,%esi
80100c1e:	8b 02                	mov    (%edx),%eax
80100c20:	89 d7                	mov    %edx,%edi
80100c22:	85 c0                	test   %eax,%eax
80100c24:	74 7d                	je     80100ca3 <exec+0x303>
80100c26:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100c29:	83 fe 20             	cmp    $0x20,%esi
80100c2c:	74 42                	je     80100c70 <exec+0x2d0>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	89 95 f0 fe ff ff    	mov    %edx,-0x110(%ebp)
80100c37:	e8 84 3a 00 00       	call   801046c0 <strlen>
80100c3c:	f7 d0                	not    %eax
80100c3e:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c40:	8b 07                	mov    (%edi),%eax
	cprintf("stack begins at addr %x \n", sp);
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c42:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c45:	89 04 24             	mov    %eax,(%esp)
80100c48:	e8 73 3a 00 00       	call   801046c0 <strlen>
80100c4d:	83 c0 01             	add    $0x1,%eax
80100c50:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c54:	8b 07                	mov    (%edi),%eax
80100c56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c64:	89 04 24             	mov    %eax,(%esp)
80100c67:	e8 e4 65 00 00       	call   80107250 <copyout>
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	79 98                	jns    80100c08 <exec+0x268>
	
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c70:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c76:	89 04 24             	mov    %eax,(%esp)
80100c79:	e8 12 62 00 00       	call   80106e90 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c83:	e9 99 fd ff ff       	jmp    80100a21 <exec+0x81>
  struct proc *curproc = myproc();
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c88:	e8 63 1f 00 00       	call   80102bf0 <end_op>
    cprintf("exec: fail\n");
80100c8d:	c7 04 24 21 79 10 80 	movl   $0x80107921,(%esp)
80100c94:	e8 b7 f9 ff ff       	call   80100650 <cprintf>
    return -1;
80100c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c9e:	e9 7e fd ff ff       	jmp    80100a21 <exec+0x81>
80100ca3:	89 cf                	mov    %ecx,%edi
80100ca5:	89 f1                	mov    %esi,%ecx
80100ca7:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi

  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cad:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
80100cb4:	89 da                	mov    %ebx,%edx
80100cb6:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100cb8:	83 c0 0c             	add    $0xc,%eax
80100cbb:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100cc1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cc7:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100ccb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }

  ustack[3+argc] = 0;
80100ccf:	c7 84 8d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ecx,4)
80100cd6:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cda:	89 04 24             	mov    %eax,(%esp)
    ustack[3+argc] = sp;
  }

  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100cdd:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ce4:	ff ff ff 
  ustack[1] = argc;
80100ce7:	89 8d 5c ff ff ff    	mov    %ecx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ced:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cf3:	e8 58 65 00 00       	call   80107250 <copyout>
80100cf8:	85 c0                	test   %eax,%eax
80100cfa:	0f 88 70 ff ff ff    	js     80100c70 <exec+0x2d0>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d00:	8b 45 08             	mov    0x8(%ebp),%eax
80100d03:	0f b6 10             	movzbl (%eax),%edx
80100d06:	84 d2                	test   %dl,%dl
80100d08:	74 19                	je     80100d23 <exec+0x383>
80100d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d0d:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d10:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d13:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d16:	0f 44 c8             	cmove  %eax,%ecx
80100d19:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d1c:	84 d2                	test   %dl,%dl
80100d1e:	75 f0                	jne    80100d10 <exec+0x370>
80100d20:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d23:	8b 45 08             	mov    0x8(%ebp),%eax
80100d26:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100d2d:	00 
80100d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d32:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d35:	89 04 24             	mov    %eax,(%esp)
80100d38:	e8 43 39 00 00       	call   80104680 <safestrcpy>

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
80100d43:	8b 7e 04             	mov    0x4(%esi),%edi
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
80100d46:	c7 46 7c 00 e0 ff 7f 	movl   $0x7fffe000,0x7c(%esi)
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d4d:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d50:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d56:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d58:	8b 46 18             	mov    0x18(%esi),%eax
80100d5b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d61:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d64:	8b 46 18             	mov    0x18(%esi),%eax
80100d67:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d6a:	89 34 24             	mov    %esi,(%esp)
80100d6d:	e8 6e 5c 00 00       	call   801069e0 <switchuvm>
  freevm(oldpgdir);
80100d72:	89 3c 24             	mov    %edi,(%esp)
80100d75:	e8 16 61 00 00       	call   80106e90 <freevm>
	
  return 0;
80100d7a:	31 c0                	xor    %eax,%eax
80100d7c:	e9 a0 fc ff ff       	jmp    80100a21 <exec+0x81>
80100d81:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
	tstack = USEREND - 2*PGSIZE;
  if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
		panic("stack allocation failed");
		goto bad;
	}
	sp = tstack+PGSIZE;
80100d87:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
  clearpteu(pgdir, (char*)(tstack+PGSIZE));

	cprintf("stack begins at addr %x \n", sp);
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8c:	31 c9                	xor    %ecx,%ecx
80100d8e:	89 c7                	mov    %eax,%edi
80100d90:	e9 18 ff ff ff       	jmp    80100cad <exec+0x30d>
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
  if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
		panic("stack allocation failed");
80100d95:	c7 04 24 4a 79 10 80 	movl   $0x8010794a,(%esp)
80100d9c:	e8 bf f5 ff ff       	call   80100360 <panic>
80100da1:	66 90                	xchg   %ax,%ax
80100da3:	66 90                	xchg   %ax,%ax
80100da5:	66 90                	xchg   %ax,%ax
80100da7:	66 90                	xchg   %ax,%ax
80100da9:	66 90                	xchg   %ax,%ax
80100dab:	66 90                	xchg   %ax,%ax
80100dad:	66 90                	xchg   %ax,%ax
80100daf:	90                   	nop

80100db0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100db6:	c7 44 24 04 7c 79 10 	movl   $0x8010797c,0x4(%esp)
80100dbd:	80 
80100dbe:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100dc5:	e8 a6 34 00 00       	call   80104270 <initlock>
}
80100dca:	c9                   	leave  
80100dcb:	c3                   	ret    
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100dd0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dd9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ddc:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100de3:	e8 78 35 00 00       	call   80104360 <acquire>
80100de8:	eb 11                	jmp    80100dfb <filealloc+0x2b>
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df0:	83 c3 18             	add    $0x18,%ebx
80100df3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100df9:	74 25                	je     80100e20 <filealloc+0x50>
    if(f->ref == 0){
80100dfb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dfe:	85 c0                	test   %eax,%eax
80100e00:	75 ee                	jne    80100df0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e02:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e09:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e10:	e8 3b 36 00 00       	call   80104450 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e15:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100e18:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e1a:	5b                   	pop    %ebx
80100e1b:	5d                   	pop    %ebp
80100e1c:	c3                   	ret    
80100e1d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e20:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e27:	e8 24 36 00 00       	call   80104450 <release>
  return 0;
}
80100e2c:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100e2f:	31 c0                	xor    %eax,%eax
}
80100e31:	5b                   	pop    %ebx
80100e32:	5d                   	pop    %ebp
80100e33:	c3                   	ret    
80100e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e40 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
80100e44:	83 ec 14             	sub    $0x14,%esp
80100e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e4a:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e51:	e8 0a 35 00 00       	call   80104360 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	85 c0                	test   %eax,%eax
80100e5b:	7e 1a                	jle    80100e77 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e5d:	83 c0 01             	add    $0x1,%eax
80100e60:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e63:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e6a:	e8 e1 35 00 00       	call   80104450 <release>
  return f;
}
80100e6f:	83 c4 14             	add    $0x14,%esp
80100e72:	89 d8                	mov    %ebx,%eax
80100e74:	5b                   	pop    %ebx
80100e75:	5d                   	pop    %ebp
80100e76:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e77:	c7 04 24 83 79 10 80 	movl   $0x80107983,(%esp)
80100e7e:	e8 dd f4 ff ff       	call   80100360 <panic>
80100e83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e90 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	57                   	push   %edi
80100e94:	56                   	push   %esi
80100e95:	53                   	push   %ebx
80100e96:	83 ec 1c             	sub    $0x1c,%esp
80100e99:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e9c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100ea3:	e8 b8 34 00 00       	call   80104360 <acquire>
  if(f->ref < 1)
80100ea8:	8b 57 04             	mov    0x4(%edi),%edx
80100eab:	85 d2                	test   %edx,%edx
80100ead:	0f 8e 89 00 00 00    	jle    80100f3c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100eb3:	83 ea 01             	sub    $0x1,%edx
80100eb6:	85 d2                	test   %edx,%edx
80100eb8:	89 57 04             	mov    %edx,0x4(%edi)
80100ebb:	74 13                	je     80100ed0 <fileclose+0x40>
    release(&ftable.lock);
80100ebd:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ec4:	83 c4 1c             	add    $0x1c,%esp
80100ec7:	5b                   	pop    %ebx
80100ec8:	5e                   	pop    %esi
80100ec9:	5f                   	pop    %edi
80100eca:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100ecb:	e9 80 35 00 00       	jmp    80104450 <release>
    return;
  }
  ff = *f;
80100ed0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100ed4:	8b 37                	mov    (%edi),%esi
80100ed6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100ed9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100edf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ee2:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ee5:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eef:	e8 5c 35 00 00       	call   80104450 <release>

  if(ff.type == FD_PIPE)
80100ef4:	83 fe 01             	cmp    $0x1,%esi
80100ef7:	74 0f                	je     80100f08 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ef9:	83 fe 02             	cmp    $0x2,%esi
80100efc:	74 22                	je     80100f20 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100efe:	83 c4 1c             	add    $0x1c,%esp
80100f01:	5b                   	pop    %ebx
80100f02:	5e                   	pop    %esi
80100f03:	5f                   	pop    %edi
80100f04:	5d                   	pop    %ebp
80100f05:	c3                   	ret    
80100f06:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f08:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100f0c:	89 1c 24             	mov    %ebx,(%esp)
80100f0f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f13:	e8 b8 23 00 00       	call   801032d0 <pipeclose>
80100f18:	eb e4                	jmp    80100efe <fileclose+0x6e>
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f20:	e8 5b 1c 00 00       	call   80102b80 <begin_op>
    iput(ff.ip);
80100f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f28:	89 04 24             	mov    %eax,(%esp)
80100f2b:	e8 10 09 00 00       	call   80101840 <iput>
    end_op();
  }
}
80100f30:	83 c4 1c             	add    $0x1c,%esp
80100f33:	5b                   	pop    %ebx
80100f34:	5e                   	pop    %esi
80100f35:	5f                   	pop    %edi
80100f36:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f37:	e9 b4 1c 00 00       	jmp    80102bf0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f3c:	c7 04 24 8b 79 10 80 	movl   $0x8010798b,(%esp)
80100f43:	e8 18 f4 ff ff       	call   80100360 <panic>
80100f48:	90                   	nop
80100f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f50 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
80100f54:	83 ec 14             	sub    $0x14,%esp
80100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f5a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f5d:	75 31                	jne    80100f90 <filestat+0x40>
    ilock(f->ip);
80100f5f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f62:	89 04 24             	mov    %eax,(%esp)
80100f65:	e8 b6 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f71:	8b 43 10             	mov    0x10(%ebx),%eax
80100f74:	89 04 24             	mov    %eax,(%esp)
80100f77:	e8 24 0a 00 00       	call   801019a0 <stati>
    iunlock(f->ip);
80100f7c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f7f:	89 04 24             	mov    %eax,(%esp)
80100f82:	e8 79 08 00 00       	call   80101800 <iunlock>
    return 0;
  }
  return -1;
}
80100f87:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f8a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f8c:	5b                   	pop    %ebx
80100f8d:	5d                   	pop    %ebp
80100f8e:	c3                   	ret    
80100f8f:	90                   	nop
80100f90:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f98:	5b                   	pop    %ebx
80100f99:	5d                   	pop    %ebp
80100f9a:	c3                   	ret    
80100f9b:	90                   	nop
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 1c             	sub    $0x1c,%esp
80100fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fb6:	74 68                	je     80101020 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100fb8:	8b 03                	mov    (%ebx),%eax
80100fba:	83 f8 01             	cmp    $0x1,%eax
80100fbd:	74 49                	je     80101008 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fbf:	83 f8 02             	cmp    $0x2,%eax
80100fc2:	75 63                	jne    80101027 <fileread+0x87>
    ilock(f->ip);
80100fc4:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc7:	89 04 24             	mov    %eax,(%esp)
80100fca:	e8 51 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fd3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100fda:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fde:	8b 43 10             	mov    0x10(%ebx),%eax
80100fe1:	89 04 24             	mov    %eax,(%esp)
80100fe4:	e8 e7 09 00 00       	call   801019d0 <readi>
80100fe9:	85 c0                	test   %eax,%eax
80100feb:	89 c6                	mov    %eax,%esi
80100fed:	7e 03                	jle    80100ff2 <fileread+0x52>
      f->off += r;
80100fef:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ff2:	8b 43 10             	mov    0x10(%ebx),%eax
80100ff5:	89 04 24             	mov    %eax,(%esp)
80100ff8:	e8 03 08 00 00       	call   80101800 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ffd:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fff:	83 c4 1c             	add    $0x1c,%esp
80101002:	5b                   	pop    %ebx
80101003:	5e                   	pop    %esi
80101004:	5f                   	pop    %edi
80101005:	5d                   	pop    %ebp
80101006:	c3                   	ret    
80101007:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101008:	8b 43 0c             	mov    0xc(%ebx),%eax
8010100b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
8010100e:	83 c4 1c             	add    $0x1c,%esp
80101011:	5b                   	pop    %ebx
80101012:	5e                   	pop    %esi
80101013:	5f                   	pop    %edi
80101014:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101015:	e9 36 24 00 00       	jmp    80103450 <piperead>
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101025:	eb d8                	jmp    80100fff <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80101027:	c7 04 24 95 79 10 80 	movl   $0x80107995,(%esp)
8010102e:	e8 2d f3 ff ff       	call   80100360 <panic>
80101033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 2c             	sub    $0x2c,%esp
80101049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010104c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010104f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101052:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101055:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010105c:	0f 84 ae 00 00 00    	je     80101110 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101062:	8b 07                	mov    (%edi),%eax
80101064:	83 f8 01             	cmp    $0x1,%eax
80101067:	0f 84 c2 00 00 00    	je     8010112f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010106d:	83 f8 02             	cmp    $0x2,%eax
80101070:	0f 85 d7 00 00 00    	jne    8010114d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101079:	31 db                	xor    %ebx,%ebx
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 31                	jg     801010b0 <filewrite+0x70>
8010107f:	e9 9c 00 00 00       	jmp    80101120 <filewrite+0xe0>
80101084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101088:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010108b:	01 47 14             	add    %eax,0x14(%edi)
8010108e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101091:	89 0c 24             	mov    %ecx,(%esp)
80101094:	e8 67 07 00 00       	call   80101800 <iunlock>
      end_op();
80101099:	e8 52 1b 00 00       	call   80102bf0 <end_op>
8010109e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
801010a1:	39 f0                	cmp    %esi,%eax
801010a3:	0f 85 98 00 00 00    	jne    80101141 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801010a9:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ab:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801010ae:	7e 70                	jle    80101120 <filewrite+0xe0>
      int n1 = n - i;
801010b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010b3:	b8 00 1a 00 00       	mov    $0x1a00,%eax
801010b8:	29 de                	sub    %ebx,%esi
801010ba:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
801010c0:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
801010c3:	e8 b8 1a 00 00       	call   80102b80 <begin_op>
      ilock(f->ip);
801010c8:	8b 47 10             	mov    0x10(%edi),%eax
801010cb:	89 04 24             	mov    %eax,(%esp)
801010ce:	e8 4d 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010d7:	8b 47 14             	mov    0x14(%edi),%eax
801010da:	89 44 24 08          	mov    %eax,0x8(%esp)
801010de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010e1:	01 d8                	add    %ebx,%eax
801010e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010e7:	8b 47 10             	mov    0x10(%edi),%eax
801010ea:	89 04 24             	mov    %eax,(%esp)
801010ed:	e8 de 09 00 00       	call   80101ad0 <writei>
801010f2:	85 c0                	test   %eax,%eax
801010f4:	7f 92                	jg     80101088 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010f6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010fc:	89 0c 24             	mov    %ecx,(%esp)
801010ff:	e8 fc 06 00 00       	call   80101800 <iunlock>
      end_op();
80101104:	e8 e7 1a 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80101109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010110c:	85 c0                	test   %eax,%eax
8010110e:	74 91                	je     801010a1 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101110:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80101113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101118:	5b                   	pop    %ebx
80101119:	5e                   	pop    %esi
8010111a:	5f                   	pop    %edi
8010111b:	5d                   	pop    %ebp
8010111c:	c3                   	ret    
8010111d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101120:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101123:	89 d8                	mov    %ebx,%eax
80101125:	75 e9                	jne    80101110 <filewrite+0xd0>
  }
  panic("filewrite");
}
80101127:	83 c4 2c             	add    $0x2c,%esp
8010112a:	5b                   	pop    %ebx
8010112b:	5e                   	pop    %esi
8010112c:	5f                   	pop    %edi
8010112d:	5d                   	pop    %ebp
8010112e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010112f:	8b 47 0c             	mov    0xc(%edi),%eax
80101132:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101135:	83 c4 2c             	add    $0x2c,%esp
80101138:	5b                   	pop    %ebx
80101139:	5e                   	pop    %esi
8010113a:	5f                   	pop    %edi
8010113b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010113c:	e9 1f 22 00 00       	jmp    80103360 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101141:	c7 04 24 9e 79 10 80 	movl   $0x8010799e,(%esp)
80101148:	e8 13 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010114d:	c7 04 24 a4 79 10 80 	movl   $0x801079a4,(%esp)
80101154:	e8 07 f2 ff ff       	call   80100360 <panic>
80101159:	66 90                	xchg   %ax,%ax
8010115b:	66 90                	xchg   %ax,%ax
8010115d:	66 90                	xchg   %ax,%ax
8010115f:	90                   	nop

80101160 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	57                   	push   %edi
80101164:	56                   	push   %esi
80101165:	53                   	push   %ebx
80101166:	83 ec 2c             	sub    $0x2c,%esp
80101169:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116c:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	0f 84 8c 00 00 00    	je     80101205 <balloc+0xa5>
80101179:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101180:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101183:	89 f0                	mov    %esi,%eax
80101185:	c1 f8 0c             	sar    $0xc,%eax
80101188:	03 05 d8 19 11 80    	add    0x801119d8,%eax
8010118e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101192:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101195:	89 04 24             	mov    %eax,(%esp)
80101198:	e8 33 ef ff ff       	call   801000d0 <bread>
8010119d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011a0:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011a8:	31 c0                	xor    %eax,%eax
801011aa:	eb 33                	jmp    801011df <balloc+0x7f>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011b0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011b3:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011b5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011b7:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ba:	83 e1 07             	and    $0x7,%ecx
801011bd:	bf 01 00 00 00       	mov    $0x1,%edi
801011c2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011c9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cb:	0f b6 fb             	movzbl %bl,%edi
801011ce:	85 cf                	test   %ecx,%edi
801011d0:	74 46                	je     80101218 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d2:	83 c0 01             	add    $0x1,%eax
801011d5:	83 c6 01             	add    $0x1,%esi
801011d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011dd:	74 05                	je     801011e4 <balloc+0x84>
801011df:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011e2:	72 cc                	jb     801011b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011e7:	89 04 24             	mov    %eax,(%esp)
801011ea:	e8 f1 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011ef:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011f9:	3b 05 c0 19 11 80    	cmp    0x801119c0,%eax
801011ff:	0f 82 7b ff ff ff    	jb     80101180 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101205:	c7 04 24 ae 79 10 80 	movl   $0x801079ae,(%esp)
8010120c:	e8 4f f1 ff ff       	call   80100360 <panic>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101218:	09 d9                	or     %ebx,%ecx
8010121a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010121d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101221:	89 1c 24             	mov    %ebx,(%esp)
80101224:	e8 f7 1a 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101229:	89 1c 24             	mov    %ebx,(%esp)
8010122c:	e8 af ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101231:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101234:	89 74 24 04          	mov    %esi,0x4(%esp)
80101238:	89 04 24             	mov    %eax,(%esp)
8010123b:	e8 90 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101240:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101247:	00 
80101248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010124f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101250:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101252:	8d 40 5c             	lea    0x5c(%eax),%eax
80101255:	89 04 24             	mov    %eax,(%esp)
80101258:	e8 43 32 00 00       	call   801044a0 <memset>
  log_write(bp);
8010125d:	89 1c 24             	mov    %ebx,(%esp)
80101260:	e8 bb 1a 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101265:	89 1c 24             	mov    %ebx,(%esp)
80101268:	e8 73 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126d:	83 c4 2c             	add    $0x2c,%esp
80101270:	89 f0                	mov    %esi,%eax
80101272:	5b                   	pop    %ebx
80101273:	5e                   	pop    %esi
80101274:	5f                   	pop    %edi
80101275:	5d                   	pop    %ebp
80101276:	c3                   	ret    
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	89 c7                	mov    %eax,%edi
80101286:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101287:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101289:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101292:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101299:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010129c:	e8 bf 30 00 00       	call   80104360 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a4:	eb 14                	jmp    801012ba <iget+0x3a>
801012a6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a8:	85 f6                	test   %esi,%esi
801012aa:	74 3c                	je     801012e8 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ac:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b2:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012b8:	74 46                	je     80101300 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ba:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012bd:	85 c9                	test   %ecx,%ecx
801012bf:	7e e7                	jle    801012a8 <iget+0x28>
801012c1:	39 3b                	cmp    %edi,(%ebx)
801012c3:	75 e3                	jne    801012a8 <iget+0x28>
801012c5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012c8:	75 de                	jne    801012a8 <iget+0x28>
      ip->ref++;
801012ca:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012cd:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012cf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012d9:	e8 72 31 00 00       	call   80104450 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012de:	83 c4 1c             	add    $0x1c,%esp
801012e1:	89 f0                	mov    %esi,%eax
801012e3:	5b                   	pop    %ebx
801012e4:	5e                   	pop    %esi
801012e5:	5f                   	pop    %edi
801012e6:	5d                   	pop    %ebp
801012e7:	c3                   	ret    
801012e8:	85 c9                	test   %ecx,%ecx
801012ea:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ed:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012f9:	75 bf                	jne    801012ba <iget+0x3a>
801012fb:	90                   	nop
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101300:	85 f6                	test   %esi,%esi
80101302:	74 29                	je     8010132d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101304:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101306:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101309:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101310:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101317:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010131e:	e8 2d 31 00 00       	call   80104450 <release>

  return ip;
}
80101323:	83 c4 1c             	add    $0x1c,%esp
80101326:	89 f0                	mov    %esi,%eax
80101328:	5b                   	pop    %ebx
80101329:	5e                   	pop    %esi
8010132a:	5f                   	pop    %edi
8010132b:	5d                   	pop    %ebp
8010132c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010132d:	c7 04 24 c4 79 10 80 	movl   $0x801079c4,(%esp)
80101334:	e8 27 f0 ff ff       	call   80100360 <panic>
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	56                   	push   %esi
80101345:	53                   	push   %ebx
80101346:	89 c3                	mov    %eax,%ebx
80101348:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010134b:	83 fa 0b             	cmp    $0xb,%edx
8010134e:	77 18                	ja     80101368 <bmap+0x28>
80101350:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101353:	8b 46 5c             	mov    0x5c(%esi),%eax
80101356:	85 c0                	test   %eax,%eax
80101358:	74 66                	je     801013c0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101368:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010136b:	83 fe 7f             	cmp    $0x7f,%esi
8010136e:	77 77                	ja     801013e7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101370:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 5e                	je     801013d8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010137a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010137e:	8b 03                	mov    (%ebx),%eax
80101380:	89 04 24             	mov    %eax,(%esp)
80101383:	e8 48 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101388:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010138e:	8b 32                	mov    (%edx),%esi
80101390:	85 f6                	test   %esi,%esi
80101392:	75 19                	jne    801013ad <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101394:	8b 03                	mov    (%ebx),%eax
80101396:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101399:	e8 c2 fd ff ff       	call   80101160 <balloc>
8010139e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013a1:	89 02                	mov    %eax,(%edx)
801013a3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013a5:	89 3c 24             	mov    %edi,(%esp)
801013a8:	e8 73 19 00 00       	call   80102d20 <log_write>
    }
    brelse(bp);
801013ad:	89 3c 24             	mov    %edi,(%esp)
801013b0:	e8 2b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
801013b5:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013b8:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	5b                   	pop    %ebx
801013bb:	5e                   	pop    %esi
801013bc:	5f                   	pop    %edi
801013bd:	5d                   	pop    %ebp
801013be:	c3                   	ret    
801013bf:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013c0:	8b 03                	mov    (%ebx),%eax
801013c2:	e8 99 fd ff ff       	call   80101160 <balloc>
801013c7:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ca:	83 c4 1c             	add    $0x1c,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5f                   	pop    %edi
801013d0:	5d                   	pop    %ebp
801013d1:	c3                   	ret    
801013d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013d8:	8b 03                	mov    (%ebx),%eax
801013da:	e8 81 fd ff ff       	call   80101160 <balloc>
801013df:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013e5:	eb 93                	jmp    8010137a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013e7:	c7 04 24 d4 79 10 80 	movl   $0x801079d4,(%esp)
801013ee:	e8 6d ef ff ff       	call   80100360 <panic>
801013f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101408:	8b 45 08             	mov    0x8(%ebp),%eax
8010140b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101412:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101413:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101416:	89 04 24             	mov    %eax,(%esp)
80101419:	e8 b2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010141e:	89 34 24             	mov    %esi,(%esp)
80101421:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101428:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101429:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010142b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101432:	e8 09 31 00 00       	call   80104540 <memmove>
  brelse(bp);
80101437:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010143a:	83 c4 10             	add    $0x10,%esp
8010143d:	5b                   	pop    %ebx
8010143e:	5e                   	pop    %esi
8010143f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101440:	e9 9b ed ff ff       	jmp    801001e0 <brelse>
80101445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101450 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	89 d7                	mov    %edx,%edi
80101456:	56                   	push   %esi
80101457:	53                   	push   %ebx
80101458:	89 c3                	mov    %eax,%ebx
8010145a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010145d:	89 04 24             	mov    %eax,(%esp)
80101460:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
80101467:	80 
80101468:	e8 93 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010146d:	89 fa                	mov    %edi,%edx
8010146f:	c1 ea 0c             	shr    $0xc,%edx
80101472:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101478:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010147b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101480:	89 54 24 04          	mov    %edx,0x4(%esp)
80101484:	e8 47 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101489:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010148b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101491:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101493:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101496:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101499:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010149b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010149d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014a2:	0f b6 c8             	movzbl %al,%ecx
801014a5:	85 d9                	test   %ebx,%ecx
801014a7:	74 20                	je     801014c9 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014a9:	f7 d3                	not    %ebx
801014ab:	21 c3                	and    %eax,%ebx
801014ad:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
801014b1:	89 34 24             	mov    %esi,(%esp)
801014b4:	e8 67 18 00 00       	call   80102d20 <log_write>
  brelse(bp);
801014b9:	89 34 24             	mov    %esi,(%esp)
801014bc:	e8 1f ed ff ff       	call   801001e0 <brelse>
}
801014c1:	83 c4 1c             	add    $0x1c,%esp
801014c4:	5b                   	pop    %ebx
801014c5:	5e                   	pop    %esi
801014c6:	5f                   	pop    %edi
801014c7:	5d                   	pop    %ebp
801014c8:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801014c9:	c7 04 24 e7 79 10 80 	movl   $0x801079e7,(%esp)
801014d0:	e8 8b ee ff ff       	call   80100360 <panic>
801014d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014e0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	53                   	push   %ebx
801014e4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014e9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ec:	c7 44 24 04 fa 79 10 	movl   $0x801079fa,0x4(%esp)
801014f3:	80 
801014f4:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801014fb:	e8 70 2d 00 00       	call   80104270 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101500:	89 1c 24             	mov    %ebx,(%esp)
80101503:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101509:	c7 44 24 04 01 7a 10 	movl   $0x80107a01,0x4(%esp)
80101510:	80 
80101511:	e8 4a 2c 00 00       	call   80104160 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101516:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010151c:	75 e2                	jne    80101500 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010151e:	8b 45 08             	mov    0x8(%ebp),%eax
80101521:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
80101528:	80 
80101529:	89 04 24             	mov    %eax,(%esp)
8010152c:	e8 cf fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101531:	a1 d8 19 11 80       	mov    0x801119d8,%eax
80101536:	c7 04 24 64 7a 10 80 	movl   $0x80107a64,(%esp)
8010153d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101541:	a1 d4 19 11 80       	mov    0x801119d4,%eax
80101546:	89 44 24 18          	mov    %eax,0x18(%esp)
8010154a:	a1 d0 19 11 80       	mov    0x801119d0,%eax
8010154f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101553:	a1 cc 19 11 80       	mov    0x801119cc,%eax
80101558:	89 44 24 10          	mov    %eax,0x10(%esp)
8010155c:	a1 c8 19 11 80       	mov    0x801119c8,%eax
80101561:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101565:	a1 c4 19 11 80       	mov    0x801119c4,%eax
8010156a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010156e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 d4 f0 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010157c:	83 c4 24             	add    $0x24,%esp
8010157f:	5b                   	pop    %ebx
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret    
80101582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101590 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 2c             	sub    $0x2c,%esp
80101599:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010159c:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801015a3:	8b 7d 08             	mov    0x8(%ebp),%edi
801015a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	0f 86 a2 00 00 00    	jbe    80101651 <ialloc+0xc1>
801015af:	be 01 00 00 00       	mov    $0x1,%esi
801015b4:	bb 01 00 00 00       	mov    $0x1,%ebx
801015b9:	eb 1a                	jmp    801015d5 <ialloc+0x45>
801015bb:	90                   	nop
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c0:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015c3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c6:	e8 15 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015cb:	89 de                	mov    %ebx,%esi
801015cd:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
801015d3:	73 7c                	jae    80101651 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015d5:	89 f0                	mov    %esi,%eax
801015d7:	c1 e8 03             	shr    $0x3,%eax
801015da:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015e0:	89 3c 24             	mov    %edi,(%esp)
801015e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015e7:	e8 e4 ea ff ff       	call   801000d0 <bread>
801015ec:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ee:	89 f0                	mov    %esi,%eax
801015f0:	83 e0 07             	and    $0x7,%eax
801015f3:	c1 e0 06             	shl    $0x6,%eax
801015f6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015fa:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015fe:	75 c0                	jne    801015c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101600:	89 0c 24             	mov    %ecx,(%esp)
80101603:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010160a:	00 
8010160b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101612:	00 
80101613:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	e8 82 2e 00 00       	call   801044a0 <memset>
      dip->type = type;
8010161e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101628:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
8010162b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162e:	89 14 24             	mov    %edx,(%esp)
80101631:	e8 ea 16 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101636:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101639:	89 14 24             	mov    %edx,(%esp)
8010163c:	e8 9f eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101641:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101644:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101646:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101647:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101649:	5e                   	pop    %esi
8010164a:	5f                   	pop    %edi
8010164b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010164c:	e9 2f fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101651:	c7 04 24 07 7a 10 80 	movl   $0x80107a07,(%esp)
80101658:	e8 03 ed ff ff       	call   80100360 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	83 ec 10             	sub    $0x10,%esp
80101668:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010167a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010167e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101681:	89 04 24             	mov    %eax,(%esp)
80101684:	e8 47 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101689:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010168c:	83 e2 07             	and    $0x7,%edx
8010168f:	c1 e2 06             	shl    $0x6,%edx
80101692:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101696:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101698:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010169f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
801016a3:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
801016a7:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
801016ab:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
801016af:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
801016b3:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
801016b7:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
801016bb:	8b 43 fc             	mov    -0x4(%ebx),%eax
801016be:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801016c5:	89 14 24             	mov    %edx,(%esp)
801016c8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801016cf:	00 
801016d0:	e8 6b 2e 00 00       	call   80104540 <memmove>
  log_write(bp);
801016d5:	89 34 24             	mov    %esi,(%esp)
801016d8:	e8 43 16 00 00       	call   80102d20 <log_write>
  brelse(bp);
801016dd:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016e6:	e9 f5 ea ff ff       	jmp    801001e0 <brelse>
801016eb:	90                   	nop
801016ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016f0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 14             	sub    $0x14,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101701:	e8 5a 2c 00 00       	call   80104360 <acquire>
  ip->ref++;
80101706:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010170a:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101711:	e8 3a 2d 00 00       	call   80104450 <release>
  return ip;
}
80101716:	83 c4 14             	add    $0x14,%esp
80101719:	89 d8                	mov    %ebx,%eax
8010171b:	5b                   	pop    %ebx
8010171c:	5d                   	pop    %ebp
8010171d:	c3                   	ret    
8010171e:	66 90                	xchg   %ax,%ax

80101720 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	83 ec 10             	sub    $0x10,%esp
80101728:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010172b:	85 db                	test   %ebx,%ebx
8010172d:	0f 84 b3 00 00 00    	je     801017e6 <ilock+0xc6>
80101733:	8b 53 08             	mov    0x8(%ebx),%edx
80101736:	85 d2                	test   %edx,%edx
80101738:	0f 8e a8 00 00 00    	jle    801017e6 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	89 04 24             	mov    %eax,(%esp)
80101744:	e8 57 2a 00 00       	call   801041a0 <acquiresleep>

  if(ip->valid == 0){
80101749:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174c:	85 c0                	test   %eax,%eax
8010174e:	74 08                	je     80101758 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101750:	83 c4 10             	add    $0x10,%esp
80101753:	5b                   	pop    %ebx
80101754:	5e                   	pop    %esi
80101755:	5d                   	pop    %ebp
80101756:	c3                   	ret    
80101757:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101758:	8b 43 04             	mov    0x4(%ebx),%eax
8010175b:	c1 e8 03             	shr    $0x3,%eax
8010175e:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101764:	89 44 24 04          	mov    %eax,0x4(%esp)
80101768:	8b 03                	mov    (%ebx),%eax
8010176a:	89 04 24             	mov    %eax,(%esp)
8010176d:	e8 5e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101772:	8b 53 04             	mov    0x4(%ebx),%edx
80101775:	83 e2 07             	and    $0x7,%edx
80101778:	c1 e2 06             	shl    $0x6,%edx
8010177b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101781:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101784:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101787:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010178b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010178f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101793:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101797:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010179b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010179f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
801017a3:	8b 42 fc             	mov    -0x4(%edx),%eax
801017a6:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a9:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801017b0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017b7:	00 
801017b8:	89 04 24             	mov    %eax,(%esp)
801017bb:	e8 80 2d 00 00       	call   80104540 <memmove>
    brelse(bp);
801017c0:	89 34 24             	mov    %esi,(%esp)
801017c3:	e8 18 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 76 ff ff ff    	jne    80101750 <ilock+0x30>
      panic("ilock: no type");
801017da:	c7 04 24 1f 7a 10 80 	movl   $0x80107a1f,(%esp)
801017e1:	e8 7a eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017e6:	c7 04 24 19 7a 10 80 	movl   $0x80107a19,(%esp)
801017ed:	e8 6e eb ff ff       	call   80100360 <panic>
801017f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101800 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	83 ec 10             	sub    $0x10,%esp
80101808:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010180b:	85 db                	test   %ebx,%ebx
8010180d:	74 24                	je     80101833 <iunlock+0x33>
8010180f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101812:	89 34 24             	mov    %esi,(%esp)
80101815:	e8 26 2a 00 00       	call   80104240 <holdingsleep>
8010181a:	85 c0                	test   %eax,%eax
8010181c:	74 15                	je     80101833 <iunlock+0x33>
8010181e:	8b 43 08             	mov    0x8(%ebx),%eax
80101821:	85 c0                	test   %eax,%eax
80101823:	7e 0e                	jle    80101833 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
80101825:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	5b                   	pop    %ebx
8010182c:	5e                   	pop    %esi
8010182d:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010182e:	e9 cd 29 00 00       	jmp    80104200 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101833:	c7 04 24 2e 7a 10 80 	movl   $0x80107a2e,(%esp)
8010183a:	e8 21 eb ff ff       	call   80100360 <panic>
8010183f:	90                   	nop

80101840 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 1c             	sub    $0x1c,%esp
80101849:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010184c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010184f:	89 3c 24             	mov    %edi,(%esp)
80101852:	e8 49 29 00 00       	call   801041a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101857:	8b 56 4c             	mov    0x4c(%esi),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 07                	je     80101865 <iput+0x25>
8010185e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101863:	74 2b                	je     80101890 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101865:	89 3c 24             	mov    %edi,(%esp)
80101868:	e8 93 29 00 00       	call   80104200 <releasesleep>

  acquire(&icache.lock);
8010186d:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101874:	e8 e7 2a 00 00       	call   80104360 <acquire>
  ip->ref--;
80101879:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010187d:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101884:	83 c4 1c             	add    $0x1c,%esp
80101887:	5b                   	pop    %ebx
80101888:	5e                   	pop    %esi
80101889:	5f                   	pop    %edi
8010188a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010188b:	e9 c0 2b 00 00       	jmp    80104450 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101890:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101897:	e8 c4 2a 00 00       	call   80104360 <acquire>
    int r = ip->ref;
8010189c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010189f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018a6:	e8 a5 2b 00 00       	call   80104450 <release>
    if(r == 1){
801018ab:	83 fb 01             	cmp    $0x1,%ebx
801018ae:	75 b5                	jne    80101865 <iput+0x25>
801018b0:	8d 4e 30             	lea    0x30(%esi),%ecx
801018b3:	89 f3                	mov    %esi,%ebx
801018b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018b8:	89 cf                	mov    %ecx,%edi
801018ba:	eb 0b                	jmp    801018c7 <iput+0x87>
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018c3:	39 fb                	cmp    %edi,%ebx
801018c5:	74 19                	je     801018e0 <iput+0xa0>
    if(ip->addrs[i]){
801018c7:	8b 53 5c             	mov    0x5c(%ebx),%edx
801018ca:	85 d2                	test   %edx,%edx
801018cc:	74 f2                	je     801018c0 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
801018ce:	8b 06                	mov    (%esi),%eax
801018d0:	e8 7b fb ff ff       	call   80101450 <bfree>
      ip->addrs[i] = 0;
801018d5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018dc:	eb e2                	jmp    801018c0 <iput+0x80>
801018de:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018e0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018e9:	85 c0                	test   %eax,%eax
801018eb:	75 2b                	jne    80101918 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ed:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018f4:	89 34 24             	mov    %esi,(%esp)
801018f7:	e8 64 fd ff ff       	call   80101660 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018fc:	31 c0                	xor    %eax,%eax
801018fe:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101902:	89 34 24             	mov    %esi,(%esp)
80101905:	e8 56 fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
8010190a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101911:	e9 4f ff ff ff       	jmp    80101865 <iput+0x25>
80101916:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010191c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010191e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101920:	89 04 24             	mov    %eax,(%esp)
80101923:	e8 a8 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101928:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
8010192b:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010192e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101931:	89 cf                	mov    %ecx,%edi
80101933:	31 c0                	xor    %eax,%eax
80101935:	eb 0e                	jmp    80101945 <iput+0x105>
80101937:	90                   	nop
80101938:	83 c3 01             	add    $0x1,%ebx
8010193b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101941:	89 d8                	mov    %ebx,%eax
80101943:	74 10                	je     80101955 <iput+0x115>
      if(a[j])
80101945:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101948:	85 d2                	test   %edx,%edx
8010194a:	74 ec                	je     80101938 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010194c:	8b 06                	mov    (%esi),%eax
8010194e:	e8 fd fa ff ff       	call   80101450 <bfree>
80101953:	eb e3                	jmp    80101938 <iput+0xf8>
    }
    brelse(bp);
80101955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101958:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010195b:	89 04 24             	mov    %eax,(%esp)
8010195e:	e8 7d e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101963:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101969:	8b 06                	mov    (%esi),%eax
8010196b:	e8 e0 fa ff ff       	call   80101450 <bfree>
    ip->addrs[NDIRECT] = 0;
80101970:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101977:	00 00 00 
8010197a:	e9 6e ff ff ff       	jmp    801018ed <iput+0xad>
8010197f:	90                   	nop

80101980 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	53                   	push   %ebx
80101984:	83 ec 14             	sub    $0x14,%esp
80101987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010198a:	89 1c 24             	mov    %ebx,(%esp)
8010198d:	e8 6e fe ff ff       	call   80101800 <iunlock>
  iput(ip);
80101992:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101995:	83 c4 14             	add    $0x14,%esp
80101998:	5b                   	pop    %ebx
80101999:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010199a:	e9 a1 fe ff ff       	jmp    80101840 <iput>
8010199f:	90                   	nop

801019a0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	8b 55 08             	mov    0x8(%ebp),%edx
801019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019a9:	8b 0a                	mov    (%edx),%ecx
801019ab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ae:	8b 4a 04             	mov    0x4(%edx),%ecx
801019b1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019b4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019b8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019bb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019bf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019c3:	8b 52 58             	mov    0x58(%edx),%edx
801019c6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019c9:	5d                   	pop    %ebp
801019ca:	c3                   	ret    
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 2c             	sub    $0x2c,%esp
801019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019dc:	8b 7d 08             	mov    0x8(%ebp),%edi
801019df:	8b 75 10             	mov    0x10(%ebp),%esi
801019e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019e5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019e8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f0:	0f 84 aa 00 00 00    	je     80101aa0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019f6:	8b 47 58             	mov    0x58(%edi),%eax
801019f9:	39 f0                	cmp    %esi,%eax
801019fb:	0f 82 c7 00 00 00    	jb     80101ac8 <readi+0xf8>
80101a01:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a04:	89 da                	mov    %ebx,%edx
80101a06:	01 f2                	add    %esi,%edx
80101a08:	0f 82 ba 00 00 00    	jb     80101ac8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a0e:	89 c1                	mov    %eax,%ecx
80101a10:	29 f1                	sub    %esi,%ecx
80101a12:	39 d0                	cmp    %edx,%eax
80101a14:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	31 c0                	xor    %eax,%eax
80101a19:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a1b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1e:	74 70                	je     80101a90 <readi+0xc0>
80101a20:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a23:	89 c7                	mov    %eax,%edi
80101a25:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a28:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a2b:	89 f2                	mov    %esi,%edx
80101a2d:	c1 ea 09             	shr    $0x9,%edx
80101a30:	89 d8                	mov    %ebx,%eax
80101a32:	e8 09 f9 ff ff       	call   80101340 <bmap>
80101a37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a3b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a42:	89 04 24             	mov    %eax,(%esp)
80101a45:	e8 86 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a4d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a51:	89 f0                	mov    %esi,%eax
80101a53:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a58:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a5a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a5e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a60:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a67:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a6a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a6e:	01 df                	add    %ebx,%edi
80101a70:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a72:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a75:	89 04 24             	mov    %eax,(%esp)
80101a78:	e8 c3 2a 00 00       	call   80104540 <memmove>
    brelse(bp);
80101a7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a80:	89 14 24             	mov    %edx,(%esp)
80101a83:	e8 58 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a88:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a8b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a8e:	77 98                	ja     80101a28 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a93:	83 c4 2c             	add    $0x2c,%esp
80101a96:	5b                   	pop    %ebx
80101a97:	5e                   	pop    %esi
80101a98:	5f                   	pop    %edi
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	90                   	nop
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101aa0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101aa4:	66 83 f8 09          	cmp    $0x9,%ax
80101aa8:	77 1e                	ja     80101ac8 <readi+0xf8>
80101aaa:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ab1:	85 c0                	test   %eax,%eax
80101ab3:	74 13                	je     80101ac8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ab5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101ab8:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101abb:	83 c4 2c             	add    $0x2c,%esp
80101abe:	5b                   	pop    %ebx
80101abf:	5e                   	pop    %esi
80101ac0:	5f                   	pop    %edi
80101ac1:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ac2:	ff e0                	jmp    *%eax
80101ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101acd:	eb c4                	jmp    80101a93 <readi+0xc3>
80101acf:	90                   	nop

80101ad0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 2c             	sub    $0x2c,%esp
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101adf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aea:	8b 75 10             	mov    0x10(%ebp),%esi
80101aed:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101af0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af3:	0f 84 b7 00 00 00    	je     80101bb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	39 70 58             	cmp    %esi,0x58(%eax)
80101aff:	0f 82 e3 00 00 00    	jb     80101be8 <writei+0x118>
80101b05:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b08:	89 c8                	mov    %ecx,%eax
80101b0a:	01 f0                	add    %esi,%eax
80101b0c:	0f 82 d6 00 00 00    	jb     80101be8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b12:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b17:	0f 87 cb 00 00 00    	ja     80101be8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b1d:	85 c9                	test   %ecx,%ecx
80101b1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b26:	74 77                	je     80101b9f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b28:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b2b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	c1 ea 09             	shr    $0x9,%edx
80101b35:	89 f8                	mov    %edi,%eax
80101b37:	e8 04 f8 ff ff       	call   80101340 <bmap>
80101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b40:	8b 07                	mov    (%edi),%eax
80101b42:	89 04 24             	mov    %eax,(%esp)
80101b45:	e8 86 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b4a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b4d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b50:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b53:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b55:	89 f0                	mov    %esi,%eax
80101b57:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b5c:	29 c3                	sub    %eax,%ebx
80101b5e:	39 cb                	cmp    %ecx,%ebx
80101b60:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b63:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b67:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b69:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b6d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b71:	89 04 24             	mov    %eax,(%esp)
80101b74:	e8 c7 29 00 00       	call   80104540 <memmove>
    log_write(bp);
80101b79:	89 3c 24             	mov    %edi,(%esp)
80101b7c:	e8 9f 11 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101b81:	89 3c 24             	mov    %edi,(%esp)
80101b84:	e8 57 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b89:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b8f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b92:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b95:	77 91                	ja     80101b28 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b9d:	72 39                	jb     80101bd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ba2:	83 c4 2c             	add    $0x2c,%esp
80101ba5:	5b                   	pop    %ebx
80101ba6:	5e                   	pop    %esi
80101ba7:	5f                   	pop    %edi
80101ba8:	5d                   	pop    %ebp
80101ba9:	c3                   	ret    
80101baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 2e                	ja     80101be8 <writei+0x118>
80101bba:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 23                	je     80101be8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bc5:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bc8:	83 c4 2c             	add    $0x2c,%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bcf:	ff e0                	jmp    *%eax
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bde:	89 04 24             	mov    %eax,(%esp)
80101be1:	e8 7a fa ff ff       	call   80101660 <iupdate>
80101be6:	eb b7                	jmp    80101b9f <writei+0xcf>
  }
  return n;
}
80101be8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bf0:	5b                   	pop    %ebx
80101bf1:	5e                   	pop    %esi
80101bf2:	5f                   	pop    %edi
80101bf3:	5d                   	pop    %ebp
80101bf4:	c3                   	ret    
80101bf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c06:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c09:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c10:	00 
80101c11:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c15:	8b 45 08             	mov    0x8(%ebp),%eax
80101c18:	89 04 24             	mov    %eax,(%esp)
80101c1b:	e8 a0 29 00 00       	call   801045c0 <strncmp>
}
80101c20:	c9                   	leave  
80101c21:	c3                   	ret    
80101c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 2c             	sub    $0x2c,%esp
80101c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c41:	0f 85 97 00 00 00    	jne    80101cde <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c47:	8b 53 58             	mov    0x58(%ebx),%edx
80101c4a:	31 ff                	xor    %edi,%edi
80101c4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c4f:	85 d2                	test   %edx,%edx
80101c51:	75 0d                	jne    80101c60 <dirlookup+0x30>
80101c53:	eb 73                	jmp    80101cc8 <dirlookup+0x98>
80101c55:	8d 76 00             	lea    0x0(%esi),%esi
80101c58:	83 c7 10             	add    $0x10,%edi
80101c5b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c5e:	76 68                	jbe    80101cc8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c60:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c67:	00 
80101c68:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c70:	89 1c 24             	mov    %ebx,(%esp)
80101c73:	e8 58 fd ff ff       	call   801019d0 <readi>
80101c78:	83 f8 10             	cmp    $0x10,%eax
80101c7b:	75 55                	jne    80101cd2 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c7d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c82:	74 d4                	je     80101c58 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c8e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c95:	00 
80101c96:	89 04 24             	mov    %eax,(%esp)
80101c99:	e8 22 29 00 00       	call   801045c0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c9e:	85 c0                	test   %eax,%eax
80101ca0:	75 b6                	jne    80101c58 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101ca2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 05                	je     80101cae <dirlookup+0x7e>
        *poff = off;
80101ca9:	8b 45 10             	mov    0x10(%ebp),%eax
80101cac:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cae:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cb2:	8b 03                	mov    (%ebx),%eax
80101cb4:	e8 c7 f5 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101cb9:	83 c4 2c             	add    $0x2c,%esp
80101cbc:	5b                   	pop    %ebx
80101cbd:	5e                   	pop    %esi
80101cbe:	5f                   	pop    %edi
80101cbf:	5d                   	pop    %ebp
80101cc0:	c3                   	ret    
80101cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cc8:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101ccb:	31 c0                	xor    %eax,%eax
}
80101ccd:	5b                   	pop    %ebx
80101cce:	5e                   	pop    %esi
80101ccf:	5f                   	pop    %edi
80101cd0:	5d                   	pop    %ebp
80101cd1:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101cd2:	c7 04 24 48 7a 10 80 	movl   $0x80107a48,(%esp)
80101cd9:	e8 82 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cde:	c7 04 24 36 7a 10 80 	movl   $0x80107a36,(%esp)
80101ce5:	e8 76 e6 ff ff       	call   80100360 <panic>
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cf0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	89 cf                	mov    %ecx,%edi
80101cf6:	56                   	push   %esi
80101cf7:	53                   	push   %ebx
80101cf8:	89 c3                	mov    %eax,%ebx
80101cfa:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cfd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d03:	0f 84 51 01 00 00    	je     80101e5a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d09:	e8 52 1a 00 00       	call   80103760 <myproc>
80101d0e:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d11:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d18:	e8 43 26 00 00       	call   80104360 <acquire>
  ip->ref++;
80101d1d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d21:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d28:	e8 23 27 00 00       	call   80104450 <release>
80101d2d:	eb 04                	jmp    80101d33 <namex+0x43>
80101d2f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d33:	0f b6 03             	movzbl (%ebx),%eax
80101d36:	3c 2f                	cmp    $0x2f,%al
80101d38:	74 f6                	je     80101d30 <namex+0x40>
    path++;
  if(*path == 0)
80101d3a:	84 c0                	test   %al,%al
80101d3c:	0f 84 ed 00 00 00    	je     80101e2f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d42:	0f b6 03             	movzbl (%ebx),%eax
80101d45:	89 da                	mov    %ebx,%edx
80101d47:	84 c0                	test   %al,%al
80101d49:	0f 84 b1 00 00 00    	je     80101e00 <namex+0x110>
80101d4f:	3c 2f                	cmp    $0x2f,%al
80101d51:	75 0f                	jne    80101d62 <namex+0x72>
80101d53:	e9 a8 00 00 00       	jmp    80101e00 <namex+0x110>
80101d58:	3c 2f                	cmp    $0x2f,%al
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d60:	74 0a                	je     80101d6c <namex+0x7c>
    path++;
80101d62:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d65:	0f b6 02             	movzbl (%edx),%eax
80101d68:	84 c0                	test   %al,%al
80101d6a:	75 ec                	jne    80101d58 <namex+0x68>
80101d6c:	89 d1                	mov    %edx,%ecx
80101d6e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d70:	83 f9 0d             	cmp    $0xd,%ecx
80101d73:	0f 8e 8f 00 00 00    	jle    80101e08 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d79:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d7d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d84:	00 
80101d85:	89 3c 24             	mov    %edi,(%esp)
80101d88:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d8b:	e8 b0 27 00 00       	call   80104540 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d93:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d95:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d98:	75 0e                	jne    80101da8 <namex+0xb8>
80101d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101da0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101da3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101da6:	74 f8                	je     80101da0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101da8:	89 34 24             	mov    %esi,(%esp)
80101dab:	e8 70 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101db0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101db5:	0f 85 85 00 00 00    	jne    80101e40 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dbb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dbe:	85 d2                	test   %edx,%edx
80101dc0:	74 09                	je     80101dcb <namex+0xdb>
80101dc2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dc5:	0f 84 a5 00 00 00    	je     80101e70 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dcb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101dd2:	00 
80101dd3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101dd7:	89 34 24             	mov    %esi,(%esp)
80101dda:	e8 51 fe ff ff       	call   80101c30 <dirlookup>
80101ddf:	85 c0                	test   %eax,%eax
80101de1:	74 5d                	je     80101e40 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101de3:	89 34 24             	mov    %esi,(%esp)
80101de6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101de9:	e8 12 fa ff ff       	call   80101800 <iunlock>
  iput(ip);
80101dee:	89 34 24             	mov    %esi,(%esp)
80101df1:	e8 4a fa ff ff       	call   80101840 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 33 ff ff ff       	jmp    80101d33 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e00:	31 c9                	xor    %ecx,%ecx
80101e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e08:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e0c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e10:	89 3c 24             	mov    %edi,(%esp)
80101e13:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e16:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e19:	e8 22 27 00 00       	call   80104540 <memmove>
    name[len] = 0;
80101e1e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e24:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e28:	89 d3                	mov    %edx,%ebx
80101e2a:	e9 66 ff ff ff       	jmp    80101d95 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e32:	85 c0                	test   %eax,%eax
80101e34:	75 4c                	jne    80101e82 <namex+0x192>
80101e36:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e38:	83 c4 2c             	add    $0x2c,%esp
80101e3b:	5b                   	pop    %ebx
80101e3c:	5e                   	pop    %esi
80101e3d:	5f                   	pop    %edi
80101e3e:	5d                   	pop    %ebp
80101e3f:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e40:	89 34 24             	mov    %esi,(%esp)
80101e43:	e8 b8 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e48:	89 34 24             	mov    %esi,(%esp)
80101e4b:	e8 f0 f9 ff ff       	call   80101840 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e50:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e53:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e55:	5b                   	pop    %ebx
80101e56:	5e                   	pop    %esi
80101e57:	5f                   	pop    %edi
80101e58:	5d                   	pop    %ebp
80101e59:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e5a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e64:	e8 17 f4 ff ff       	call   80101280 <iget>
80101e69:	89 c6                	mov    %eax,%esi
80101e6b:	e9 c3 fe ff ff       	jmp    80101d33 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e70:	89 34 24             	mov    %esi,(%esp)
80101e73:	e8 88 f9 ff ff       	call   80101800 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e78:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e7b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e7d:	5b                   	pop    %ebx
80101e7e:	5e                   	pop    %esi
80101e7f:	5f                   	pop    %edi
80101e80:	5d                   	pop    %ebp
80101e81:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e82:	89 34 24             	mov    %esi,(%esp)
80101e85:	e8 b6 f9 ff ff       	call   80101840 <iput>
    return 0;
80101e8a:	31 c0                	xor    %eax,%eax
80101e8c:	eb aa                	jmp    80101e38 <namex+0x148>
80101e8e:	66 90                	xchg   %ax,%ax

80101e90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 2c             	sub    $0x2c,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101ea6:	00 
80101ea7:	89 1c 24             	mov    %ebx,(%esp)
80101eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80101eae:	e8 7d fd ff ff       	call   80101c30 <dirlookup>
80101eb3:	85 c0                	test   %eax,%eax
80101eb5:	0f 85 8b 00 00 00    	jne    80101f46 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ebb:	8b 43 58             	mov    0x58(%ebx),%eax
80101ebe:	31 ff                	xor    %edi,%edi
80101ec0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	75 13                	jne    80101eda <dirlink+0x4a>
80101ec7:	eb 35                	jmp    80101efe <dirlink+0x6e>
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed0:	8d 57 10             	lea    0x10(%edi),%edx
80101ed3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101ed6:	89 d7                	mov    %edx,%edi
80101ed8:	76 24                	jbe    80101efe <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eda:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ee1:	00 
80101ee2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ee6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eea:	89 1c 24             	mov    %ebx,(%esp)
80101eed:	e8 de fa ff ff       	call   801019d0 <readi>
80101ef2:	83 f8 10             	cmp    $0x10,%eax
80101ef5:	75 5e                	jne    80101f55 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101ef7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101efc:	75 d2                	jne    80101ed0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f01:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101f08:	00 
80101f09:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f0d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f10:	89 04 24             	mov    %eax,(%esp)
80101f13:	e8 18 27 00 00       	call   80104630 <strncpy>
  de.inum = inum;
80101f18:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f1b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f22:	00 
80101f23:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f27:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f2b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f2e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f32:	e8 99 fb ff ff       	call   80101ad0 <writei>
80101f37:	83 f8 10             	cmp    $0x10,%eax
80101f3a:	75 25                	jne    80101f61 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101f3c:	31 c0                	xor    %eax,%eax
}
80101f3e:	83 c4 2c             	add    $0x2c,%esp
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f46:	89 04 24             	mov    %eax,(%esp)
80101f49:	e8 f2 f8 ff ff       	call   80101840 <iput>
    return -1;
80101f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f53:	eb e9                	jmp    80101f3e <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f55:	c7 04 24 57 7a 10 80 	movl   $0x80107a57,(%esp)
80101f5c:	e8 ff e3 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f61:	c7 04 24 46 80 10 80 	movl   $0x80108046,(%esp)
80101f68:	e8 f3 e3 ff ff       	call   80100360 <panic>
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi

80101f70 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f70:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f71:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f73:	89 e5                	mov    %esp,%ebp
80101f75:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f78:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f7e:	e8 6d fd ff ff       	call   80101cf0 <namex>
}
80101f83:	c9                   	leave  
80101f84:	c3                   	ret    
80101f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f90:	55                   	push   %ebp
  return namex(path, 1, name);
80101f91:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f96:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f9e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f9f:	e9 4c fd ff ff       	jmp    80101cf0 <namex>
80101fa4:	66 90                	xchg   %ax,%ax
80101fa6:	66 90                	xchg   %ax,%ax
80101fa8:	66 90                	xchg   %ax,%ax
80101faa:	66 90                	xchg   %ax,%ax
80101fac:	66 90                	xchg   %ax,%ax
80101fae:	66 90                	xchg   %ax,%ax

80101fb0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	56                   	push   %esi
80101fb4:	89 c6                	mov    %eax,%esi
80101fb6:	53                   	push   %ebx
80101fb7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101fba:	85 c0                	test   %eax,%eax
80101fbc:	0f 84 99 00 00 00    	je     8010205b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fc2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fc5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101fcb:	0f 87 7e 00 00 00    	ja     8010204f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd6:	66 90                	xchg   %ax,%ax
80101fd8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fd9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fdc:	3c 40                	cmp    $0x40,%al
80101fde:	75 f8                	jne    80101fd8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fe0:	31 db                	xor    %ebx,%ebx
80101fe2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fe7:	89 d8                	mov    %ebx,%eax
80101fe9:	ee                   	out    %al,(%dx)
80101fea:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fef:	b8 01 00 00 00       	mov    $0x1,%eax
80101ff4:	ee                   	out    %al,(%dx)
80101ff5:	0f b6 c1             	movzbl %cl,%eax
80101ff8:	b2 f3                	mov    $0xf3,%dl
80101ffa:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ffb:	89 c8                	mov    %ecx,%eax
80101ffd:	b2 f4                	mov    $0xf4,%dl
80101fff:	c1 f8 08             	sar    $0x8,%eax
80102002:	ee                   	out    %al,(%dx)
80102003:	b2 f5                	mov    $0xf5,%dl
80102005:	89 d8                	mov    %ebx,%eax
80102007:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102008:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010200c:	b2 f6                	mov    $0xf6,%dl
8010200e:	83 e0 01             	and    $0x1,%eax
80102011:	c1 e0 04             	shl    $0x4,%eax
80102014:	83 c8 e0             	or     $0xffffffe0,%eax
80102017:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102018:	f6 06 04             	testb  $0x4,(%esi)
8010201b:	75 13                	jne    80102030 <idestart+0x80>
8010201d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102022:	b8 20 00 00 00       	mov    $0x20,%eax
80102027:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102028:	83 c4 10             	add    $0x10,%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5d                   	pop    %ebp
8010202e:	c3                   	ret    
8010202f:	90                   	nop
80102030:	b2 f7                	mov    $0xf7,%dl
80102032:	b8 30 00 00 00       	mov    $0x30,%eax
80102037:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102038:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010203d:	83 c6 5c             	add    $0x5c,%esi
80102040:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102045:	fc                   	cld    
80102046:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	5b                   	pop    %ebx
8010204c:	5e                   	pop    %esi
8010204d:	5d                   	pop    %ebp
8010204e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010204f:	c7 04 24 c0 7a 10 80 	movl   $0x80107ac0,(%esp)
80102056:	e8 05 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010205b:	c7 04 24 b7 7a 10 80 	movl   $0x80107ab7,(%esp)
80102062:	e8 f9 e2 ff ff       	call   80100360 <panic>
80102067:	89 f6                	mov    %esi,%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102070 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102076:	c7 44 24 04 d2 7a 10 	movl   $0x80107ad2,0x4(%esp)
8010207d:	80 
8010207e:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102085:	e8 e6 21 00 00       	call   80104270 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010208a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010208f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102096:	83 e8 01             	sub    $0x1,%eax
80102099:	89 44 24 04          	mov    %eax,0x4(%esp)
8010209d:	e8 7e 02 00 00       	call   80102320 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020a7:	90                   	nop
801020a8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a9:	83 e0 c0             	and    $0xffffffc0,%eax
801020ac:	3c 40                	cmp    $0x40,%al
801020ae:	75 f8                	jne    801020a8 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020b0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020ba:	ee                   	out    %al,(%dx)
801020bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	b2 f7                	mov    $0xf7,%dl
801020c2:	eb 09                	jmp    801020cd <ideinit+0x5d>
801020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020c8:	83 e9 01             	sub    $0x1,%ecx
801020cb:	74 0f                	je     801020dc <ideinit+0x6c>
801020cd:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020ce:	84 c0                	test   %al,%al
801020d0:	74 f6                	je     801020c8 <ideinit+0x58>
      havedisk1 = 1;
801020d2:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801020d9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020dc:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020e6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020e7:	c9                   	leave  
801020e8:	c3                   	ret    
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020f0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020f9:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102100:	e8 5b 22 00 00       	call   80104360 <acquire>

  if((b = idequeue) == 0){
80102105:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010210b:	85 db                	test   %ebx,%ebx
8010210d:	74 30                	je     8010213f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010210f:	8b 43 58             	mov    0x58(%ebx),%eax
80102112:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102117:	8b 33                	mov    (%ebx),%esi
80102119:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010211f:	74 37                	je     80102158 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102121:	83 e6 fb             	and    $0xfffffffb,%esi
80102124:	83 ce 02             	or     $0x2,%esi
80102127:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102129:	89 1c 24             	mov    %ebx,(%esp)
8010212c:	e8 6f 1e 00 00       	call   80103fa0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102131:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102136:	85 c0                	test   %eax,%eax
80102138:	74 05                	je     8010213f <ideintr+0x4f>
    idestart(idequeue);
8010213a:	e8 71 fe ff ff       	call   80101fb0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
8010213f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102146:	e8 05 23 00 00       	call   80104450 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010214b:	83 c4 1c             	add    $0x1c,%esp
8010214e:	5b                   	pop    %ebx
8010214f:	5e                   	pop    %esi
80102150:	5f                   	pop    %edi
80102151:	5d                   	pop    %ebp
80102152:	c3                   	ret    
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102158:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010215d:	8d 76 00             	lea    0x0(%esi),%esi
80102160:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102161:	89 c1                	mov    %eax,%ecx
80102163:	83 e1 c0             	and    $0xffffffc0,%ecx
80102166:	80 f9 40             	cmp    $0x40,%cl
80102169:	75 f5                	jne    80102160 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010216b:	a8 21                	test   $0x21,%al
8010216d:	75 b2                	jne    80102121 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010216f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102172:	b9 80 00 00 00       	mov    $0x80,%ecx
80102177:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010217c:	fc                   	cld    
8010217d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010217f:	8b 33                	mov    (%ebx),%esi
80102181:	eb 9e                	jmp    80102121 <ideintr+0x31>
80102183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102190 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	53                   	push   %ebx
80102194:	83 ec 14             	sub    $0x14,%esp
80102197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010219a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010219d:	89 04 24             	mov    %eax,(%esp)
801021a0:	e8 9b 20 00 00       	call   80104240 <holdingsleep>
801021a5:	85 c0                	test   %eax,%eax
801021a7:	0f 84 9e 00 00 00    	je     8010224b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021ad:	8b 03                	mov    (%ebx),%eax
801021af:	83 e0 06             	and    $0x6,%eax
801021b2:	83 f8 02             	cmp    $0x2,%eax
801021b5:	0f 84 a8 00 00 00    	je     80102263 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021bb:	8b 53 04             	mov    0x4(%ebx),%edx
801021be:	85 d2                	test   %edx,%edx
801021c0:	74 0d                	je     801021cf <iderw+0x3f>
801021c2:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801021c7:	85 c0                	test   %eax,%eax
801021c9:	0f 84 88 00 00 00    	je     80102257 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021cf:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801021d6:	e8 85 21 00 00       	call   80104360 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021e0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021e7:	85 c0                	test   %eax,%eax
801021e9:	75 07                	jne    801021f2 <iderw+0x62>
801021eb:	eb 4e                	jmp    8010223b <iderw+0xab>
801021ed:	8d 76 00             	lea    0x0(%esi),%esi
801021f0:	89 d0                	mov    %edx,%eax
801021f2:	8b 50 58             	mov    0x58(%eax),%edx
801021f5:	85 d2                	test   %edx,%edx
801021f7:	75 f7                	jne    801021f0 <iderw+0x60>
801021f9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021fc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021fe:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102204:	74 3c                	je     80102242 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102206:	8b 03                	mov    (%ebx),%eax
80102208:	83 e0 06             	and    $0x6,%eax
8010220b:	83 f8 02             	cmp    $0x2,%eax
8010220e:	74 1a                	je     8010222a <iderw+0x9a>
    sleep(b, &idelock);
80102210:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
80102217:	80 
80102218:	89 1c 24             	mov    %ebx,(%esp)
8010221b:	e8 e0 1b 00 00       	call   80103e00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102220:	8b 13                	mov    (%ebx),%edx
80102222:	83 e2 06             	and    $0x6,%edx
80102225:	83 fa 02             	cmp    $0x2,%edx
80102228:	75 e6                	jne    80102210 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
8010222a:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102231:	83 c4 14             	add    $0x14,%esp
80102234:	5b                   	pop    %ebx
80102235:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102236:	e9 15 22 00 00       	jmp    80104450 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010223b:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
80102240:	eb ba                	jmp    801021fc <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102242:	89 d8                	mov    %ebx,%eax
80102244:	e8 67 fd ff ff       	call   80101fb0 <idestart>
80102249:	eb bb                	jmp    80102206 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010224b:	c7 04 24 d6 7a 10 80 	movl   $0x80107ad6,(%esp)
80102252:	e8 09 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102257:	c7 04 24 01 7b 10 80 	movl   $0x80107b01,(%esp)
8010225e:	e8 fd e0 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102263:	c7 04 24 ec 7a 10 80 	movl   $0x80107aec,(%esp)
8010226a:	e8 f1 e0 ff ff       	call   80100360 <panic>
8010226f:	90                   	nop

80102270 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	56                   	push   %esi
80102274:	53                   	push   %ebx
80102275:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102278:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010227f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102282:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102289:	00 00 00 
  return ioapic->data;
8010228c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102292:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102295:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010229b:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022a1:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022a8:	c1 e8 10             	shr    $0x10,%eax
801022ab:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801022ae:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
801022b1:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022b4:	39 c2                	cmp    %eax,%edx
801022b6:	74 12                	je     801022ca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022b8:	c7 04 24 20 7b 10 80 	movl   $0x80107b20,(%esp)
801022bf:	e8 8c e3 ff ff       	call   80100650 <cprintf>
801022c4:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
801022ca:	ba 10 00 00 00       	mov    $0x10,%edx
801022cf:	31 c0                	xor    %eax,%eax
801022d1:	eb 07                	jmp    801022da <ioapicinit+0x6a>
801022d3:	90                   	nop
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022d8:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022da:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022dc:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
801022e2:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022e5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022eb:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ee:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022f1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022f4:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022f7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022f9:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022ff:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102301:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102308:	7d ce                	jge    801022d8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	5b                   	pop    %ebx
8010230e:	5e                   	pop    %esi
8010230f:	5d                   	pop    %ebp
80102310:	c3                   	ret    
80102311:	eb 0d                	jmp    80102320 <ioapicenable>
80102313:	90                   	nop
80102314:	90                   	nop
80102315:	90                   	nop
80102316:	90                   	nop
80102317:	90                   	nop
80102318:	90                   	nop
80102319:	90                   	nop
8010231a:	90                   	nop
8010231b:	90                   	nop
8010231c:	90                   	nop
8010231d:	90                   	nop
8010231e:	90                   	nop
8010231f:	90                   	nop

80102320 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	8b 55 08             	mov    0x8(%ebp),%edx
80102326:	53                   	push   %ebx
80102327:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010232a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010232d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102331:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102337:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010233a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010233c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102342:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102345:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102348:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010234a:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102350:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102353:	5b                   	pop    %ebx
80102354:	5d                   	pop    %ebp
80102355:	c3                   	ret    
80102356:	66 90                	xchg   %ax,%ax
80102358:	66 90                	xchg   %ax,%ax
8010235a:	66 90                	xchg   %ax,%ax
8010235c:	66 90                	xchg   %ax,%ax
8010235e:	66 90                	xchg   %ax,%ax

80102360 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 14             	sub    $0x14,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010236a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102370:	75 7c                	jne    801023ee <kfree+0x8e>
80102372:	81 fb f4 70 11 80    	cmp    $0x801170f4,%ebx
80102378:	72 74                	jb     801023ee <kfree+0x8e>
8010237a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102380:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102385:	77 67                	ja     801023ee <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102387:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010238e:	00 
8010238f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102396:	00 
80102397:	89 1c 24             	mov    %ebx,(%esp)
8010239a:	e8 01 21 00 00       	call   801044a0 <memset>

  if(kmem.use_lock)
8010239f:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801023a5:	85 d2                	test   %edx,%edx
801023a7:	75 37                	jne    801023e0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023a9:	a1 78 36 11 80       	mov    0x80113678,%eax
801023ae:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023b0:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023b5:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801023bb:	85 c0                	test   %eax,%eax
801023bd:	75 09                	jne    801023c8 <kfree+0x68>
    release(&kmem.lock);
}
801023bf:	83 c4 14             	add    $0x14,%esp
801023c2:	5b                   	pop    %ebx
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023c8:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023cf:	83 c4 14             	add    $0x14,%esp
801023d2:	5b                   	pop    %ebx
801023d3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023d4:	e9 77 20 00 00       	jmp    80104450 <release>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023e0:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801023e7:	e8 74 1f 00 00       	call   80104360 <acquire>
801023ec:	eb bb                	jmp    801023a9 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023ee:	c7 04 24 52 7b 10 80 	movl   $0x80107b52,(%esp)
801023f5:	e8 66 df ff ff       	call   80100360 <panic>
801023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102400 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102408:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010240b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102414:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102420:	39 de                	cmp    %ebx,%esi
80102422:	73 08                	jae    8010242c <freerange+0x2c>
80102424:	eb 18                	jmp    8010243e <freerange+0x3e>
80102426:	66 90                	xchg   %ax,%ax
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 2c ff ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 f0                	cmp    %esi,%eax
8010243c:	76 ea                	jbe    80102428 <freerange+0x28>
    kfree(p);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
80102458:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010245b:	c7 44 24 04 58 7b 10 	movl   $0x80107b58,0x4(%esp)
80102462:	80 
80102463:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
8010246a:	e8 01 1e 00 00       	call   80104270 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102472:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102479:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010247c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102482:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102488:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010248e:	39 de                	cmp    %ebx,%esi
80102490:	73 0a                	jae    8010249c <kinit1+0x4c>
80102492:	eb 1a                	jmp    801024ae <kinit1+0x5e>
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102498:	89 da                	mov    %ebx,%edx
8010249a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010249c:	89 14 24             	mov    %edx,(%esp)
8010249f:	e8 bc fe ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024aa:	39 c6                	cmp    %eax,%esi
801024ac:	73 ea                	jae    80102498 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801024ae:	83 c4 10             	add    $0x10,%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
801024c5:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024cb:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024ce:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024da:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 08                	jae    801024ec <kinit2+0x2c>
801024e4:	eb 18                	jmp    801024fe <kinit2+0x3e>
801024e6:	66 90                	xchg   %ax,%ax
801024e8:	89 da                	mov    %ebx,%edx
801024ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ec:	89 14 24             	mov    %edx,(%esp)
801024ef:	e8 6c fe ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024fa:	39 c6                	cmp    %eax,%esi
801024fc:	73 ea                	jae    801024e8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024fe:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
80102505:	00 00 00 
}
80102508:	83 c4 10             	add    $0x10,%esp
8010250b:	5b                   	pop    %ebx
8010250c:	5e                   	pop    %esi
8010250d:	5d                   	pop    %ebp
8010250e:	c3                   	ret    
8010250f:	90                   	nop

80102510 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102517:	a1 74 36 11 80       	mov    0x80113674,%eax
8010251c:	85 c0                	test   %eax,%eax
8010251e:	75 30                	jne    80102550 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102520:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102526:	85 db                	test   %ebx,%ebx
80102528:	74 08                	je     80102532 <kalloc+0x22>
    kmem.freelist = r->next;
8010252a:	8b 13                	mov    (%ebx),%edx
8010252c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102532:	85 c0                	test   %eax,%eax
80102534:	74 0c                	je     80102542 <kalloc+0x32>
    release(&kmem.lock);
80102536:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
8010253d:	e8 0e 1f 00 00       	call   80104450 <release>
  return (char*)r;
}
80102542:	83 c4 14             	add    $0x14,%esp
80102545:	89 d8                	mov    %ebx,%eax
80102547:	5b                   	pop    %ebx
80102548:	5d                   	pop    %ebp
80102549:	c3                   	ret    
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102550:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
80102557:	e8 04 1e 00 00       	call   80104360 <acquire>
8010255c:	a1 74 36 11 80       	mov    0x80113674,%eax
80102561:	eb bd                	jmp    80102520 <kalloc+0x10>
80102563:	66 90                	xchg   %ax,%ax
80102565:	66 90                	xchg   %ax,%ax
80102567:	66 90                	xchg   %ax,%ax
80102569:	66 90                	xchg   %ax,%ax
8010256b:	66 90                	xchg   %ax,%ax
8010256d:	66 90                	xchg   %ax,%ax
8010256f:	90                   	nop

80102570 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 ba 00 00 00    	je     80102638 <kbdgetc+0xc8>
8010257e:	b2 60                	mov    $0x60,%dl
80102580:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102581:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102584:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010258a:	0f 84 88 00 00 00    	je     80102618 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102590:	84 c0                	test   %al,%al
80102592:	79 2c                	jns    801025c0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102594:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
8010259a:	f6 c2 40             	test   $0x40,%dl
8010259d:	75 05                	jne    801025a4 <kbdgetc+0x34>
8010259f:	89 c1                	mov    %eax,%ecx
801025a1:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801025a4:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
801025ab:	83 c8 40             	or     $0x40,%eax
801025ae:	0f b6 c0             	movzbl %al,%eax
801025b1:	f7 d0                	not    %eax
801025b3:	21 d0                	and    %edx,%eax
801025b5:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801025ba:	31 c0                	xor    %eax,%eax
801025bc:	c3                   	ret    
801025bd:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025ca:	f6 c3 40             	test   $0x40,%bl
801025cd:	74 09                	je     801025d8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025cf:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025d2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025d5:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025d8:	0f b6 91 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%edx
  shift ^= togglecode[data];
801025df:	0f b6 81 80 7b 10 80 	movzbl -0x7fef8480(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025e6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025e8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025ea:	89 d0                	mov    %edx,%eax
801025ec:	83 e0 03             	and    $0x3,%eax
801025ef:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025f6:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025fc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025ff:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102603:	74 0b                	je     80102610 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102605:	8d 50 9f             	lea    -0x61(%eax),%edx
80102608:	83 fa 19             	cmp    $0x19,%edx
8010260b:	77 1b                	ja     80102628 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010260d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102610:	5b                   	pop    %ebx
80102611:	5d                   	pop    %ebp
80102612:	c3                   	ret    
80102613:	90                   	nop
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102618:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
8010261f:	31 c0                	xor    %eax,%eax
80102621:	c3                   	ret    
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
8010262e:	83 f9 19             	cmp    $0x19,%ecx
80102631:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102634:	eb da                	jmp    80102610 <kbdgetc+0xa0>
80102636:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102638:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010263d:	c3                   	ret    
8010263e:	66 90                	xchg   %ax,%ax

80102640 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102646:	c7 04 24 70 25 10 80 	movl   $0x80102570,(%esp)
8010264d:	e8 5e e1 ff ff       	call   801007b0 <consoleintr>
}
80102652:	c9                   	leave  
80102653:	c3                   	ret    
80102654:	66 90                	xchg   %ax,%ax
80102656:	66 90                	xchg   %ax,%ax
80102658:	66 90                	xchg   %ax,%ax
8010265a:	66 90                	xchg   %ax,%ax
8010265c:	66 90                	xchg   %ax,%ax
8010265e:	66 90                	xchg   %ax,%ax

80102660 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102660:	55                   	push   %ebp
80102661:	89 c1                	mov    %eax,%ecx
80102663:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102665:	ba 70 00 00 00       	mov    $0x70,%edx
8010266a:	53                   	push   %ebx
8010266b:	31 c0                	xor    %eax,%eax
8010266d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010266e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102673:	89 da                	mov    %ebx,%edx
80102675:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102676:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102679:	b2 70                	mov    $0x70,%dl
8010267b:	89 01                	mov    %eax,(%ecx)
8010267d:	b8 02 00 00 00       	mov    $0x2,%eax
80102682:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102683:	89 da                	mov    %ebx,%edx
80102685:	ec                   	in     (%dx),%al
80102686:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102689:	b2 70                	mov    $0x70,%dl
8010268b:	89 41 04             	mov    %eax,0x4(%ecx)
8010268e:	b8 04 00 00 00       	mov    $0x4,%eax
80102693:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102694:	89 da                	mov    %ebx,%edx
80102696:	ec                   	in     (%dx),%al
80102697:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269a:	b2 70                	mov    $0x70,%dl
8010269c:	89 41 08             	mov    %eax,0x8(%ecx)
8010269f:	b8 07 00 00 00       	mov    $0x7,%eax
801026a4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a5:	89 da                	mov    %ebx,%edx
801026a7:	ec                   	in     (%dx),%al
801026a8:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ab:	b2 70                	mov    $0x70,%dl
801026ad:	89 41 0c             	mov    %eax,0xc(%ecx)
801026b0:	b8 08 00 00 00       	mov    $0x8,%eax
801026b5:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b6:	89 da                	mov    %ebx,%edx
801026b8:	ec                   	in     (%dx),%al
801026b9:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026bc:	b2 70                	mov    $0x70,%dl
801026be:	89 41 10             	mov    %eax,0x10(%ecx)
801026c1:	b8 09 00 00 00       	mov    $0x9,%eax
801026c6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c7:	89 da                	mov    %ebx,%edx
801026c9:	ec                   	in     (%dx),%al
801026ca:	0f b6 d8             	movzbl %al,%ebx
801026cd:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026d0:	5b                   	pop    %ebx
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026e0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	0f 84 c0 00 00 00    	je     801027b0 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102711:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102717:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010271e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102721:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102724:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010272b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102731:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102738:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010273e:	8b 50 30             	mov    0x30(%eax),%edx
80102741:	c1 ea 10             	shr    $0x10,%edx
80102744:	80 fa 03             	cmp    $0x3,%dl
80102747:	77 6f                	ja     801027b8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102749:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102750:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102753:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102756:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102760:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102770:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102777:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102784:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102787:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102791:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102794:	8b 50 20             	mov    0x20(%eax),%edx
80102797:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102798:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010279e:	80 e6 10             	and    $0x10,%dh
801027a1:	75 f5                	jne    80102798 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ad:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027b0:	5d                   	pop    %ebp
801027b1:	c3                   	ret    
801027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027c2:	8b 50 20             	mov    0x20(%eax),%edx
801027c5:	eb 82                	jmp    80102749 <lapicinit+0x69>
801027c7:	89 f6                	mov    %esi,%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801027d0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 0c                	je     801027e8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801027dc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027df:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801027e0:	c1 e8 18             	shr    $0x18,%eax
}
801027e3:	c3                   	ret    
801027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801027e8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801027ea:	5d                   	pop    %ebp
801027eb:	c3                   	ret    
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	89 e5                	mov    %esp,%ebp
80102828:	b8 0f 00 00 00       	mov    $0xf,%eax
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	b2 71                	mov    $0x71,%dl
8010283c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010283d:	31 c0                	xor    %eax,%eax
8010283f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102845:	89 d8                	mov    %ebx,%eax
80102847:	c1 e8 04             	shr    $0x4,%eax
8010284a:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102855:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102858:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102864:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010286b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102871:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102878:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102887:	89 da                	mov    %ebx,%edx
80102889:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102892:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102895:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028a7:	5b                   	pop    %ebx
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	b2 71                	mov    $0x71,%dl
801028c6:	ec                   	in     (%dx),%al
801028c7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ca:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028cd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028d1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028dd:	89 d8                	mov    %ebx,%eax
801028df:	e8 7c fd ff ff       	call   80102660 <fill_rtcdate>
801028e4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028e9:	89 f2                	mov    %esi,%edx
801028eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	ba 71 00 00 00       	mov    $0x71,%edx
801028f1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f2:	84 c0                	test   %al,%al
801028f4:	78 e7                	js     801028dd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028f6:	89 f8                	mov    %edi,%eax
801028f8:	e8 63 fd ff ff       	call   80102660 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102904:	00 
80102905:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102909:	89 1c 24             	mov    %ebx,(%esp)
8010290c:	e8 df 1b 00 00       	call   801044f0 <memcmp>
80102911:	85 c0                	test   %eax,%eax
80102913:	75 c3                	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102915:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102919:	75 78                	jne    80102993 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010292f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102943:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102946:	89 c2                	mov    %eax,%edx
80102948:	83 e0 0f             	and    $0xf,%eax
8010294b:	c1 ea 04             	shr    $0x4,%edx
8010294e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102951:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 c2                	mov    %eax,%edx
8010295c:	83 e0 0f             	and    $0xf,%eax
8010295f:	c1 ea 04             	shr    $0x4,%edx
80102962:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102965:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102968:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102993:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102996:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102999:	89 01                	mov    %eax,(%ecx)
8010299b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010299e:	89 41 04             	mov    %eax,0x4(%ecx)
801029a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a4:	89 41 08             	mov    %eax,0x8(%ecx)
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 41 10             	mov    %eax,0x10(%ecx)
801029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029b9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029c0:	83 c4 4c             	add    $0x4c,%esp
801029c3:	5b                   	pop    %ebx
801029c4:	5e                   	pop    %esi
801029c5:	5f                   	pop    %edi
801029c6:	5d                   	pop    %ebp
801029c7:	c3                   	ret    
801029c8:	66 90                	xchg   %ax,%ax
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029db:	a1 c8 36 11 80       	mov    0x801136c8,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	7e 78                	jle    80102a5c <install_trans+0x8c>
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029e8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029ed:	01 d8                	add    %ebx,%eax
801029ef:	83 c0 01             	add    $0x1,%eax
801029f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f6:	a1 c4 36 11 80       	mov    0x801136c4,%eax
801029fb:	89 04 24             	mov    %eax,(%esp)
801029fe:	e8 cd d6 ff ff       	call   801000d0 <bread>
80102a03:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a05:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a13:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a18:	89 04 24             	mov    %eax,(%esp)
80102a1b:	e8 b0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a20:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a27:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a28:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a2a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a34:	89 04 24             	mov    %eax,(%esp)
80102a37:	e8 04 1b 00 00       	call   80104540 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a3c:	89 34 24             	mov    %esi,(%esp)
80102a3f:	e8 5c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a44:	89 3c 24             	mov    %edi,(%esp)
80102a47:	e8 94 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 8c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102a5a:	7f 8c                	jg     801029e8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a5c:	83 c4 1c             	add    $0x1c,%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	c3                   	ret    
80102a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	57                   	push   %edi
80102a74:	56                   	push   %esi
80102a75:	53                   	push   %ebx
80102a76:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a79:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a82:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a87:	89 04 24             	mov    %eax,(%esp)
80102a8a:	e8 41 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a8f:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a95:	31 d2                	xor    %edx,%edx
80102a97:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a99:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a9e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102aa1:	7e 17                	jle    80102aba <write_head+0x4a>
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102aaf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ab3:	83 c2 01             	add    $0x1,%edx
80102ab6:	39 da                	cmp    %ebx,%edx
80102ab8:	75 ee                	jne    80102aa8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aba:	89 3c 24             	mov    %edi,(%esp)
80102abd:	e8 de d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ac2:	89 3c 24             	mov    %edi,(%esp)
80102ac5:	e8 16 d7 ff ff       	call   801001e0 <brelse>
}
80102aca:	83 c4 1c             	add    $0x1c,%esp
80102acd:	5b                   	pop    %ebx
80102ace:	5e                   	pop    %esi
80102acf:	5f                   	pop    %edi
80102ad0:	5d                   	pop    %ebp
80102ad1:	c3                   	ret    
80102ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	83 ec 30             	sub    $0x30,%esp
80102ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aeb:	c7 44 24 04 80 7d 10 	movl   $0x80107d80,0x4(%esp)
80102af2:	80 
80102af3:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102afa:	e8 71 17 00 00       	call   80104270 <initlock>
  readsb(dev, &sb);
80102aff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b06:	89 1c 24             	mov    %ebx,(%esp)
80102b09:	e8 f2 e8 ff ff       	call   80101400 <readsb>
  log.start = sb.logstart;
80102b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b11:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b14:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b17:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b21:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b27:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2c:	e8 9f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b31:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b33:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b36:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b39:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b3b:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b41:	7e 17                	jle    80102b5a <initlog+0x7a>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b48:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b4c:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b53:	83 c2 01             	add    $0x1,%edx
80102b56:	39 da                	cmp    %ebx,%edx
80102b58:	75 ee                	jne    80102b48 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b5a:	89 04 24             	mov    %eax,(%esp)
80102b5d:	e8 7e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b62:	e8 69 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b67:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102b6e:	00 00 00 
  write_head(); // clear the log
80102b71:	e8 fa fe ff ff       	call   80102a70 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b76:	83 c4 30             	add    $0x30,%esp
80102b79:	5b                   	pop    %ebx
80102b7a:	5e                   	pop    %esi
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b86:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b8d:	e8 ce 17 00 00       	call   80104360 <acquire>
80102b92:	eb 18                	jmp    80102bac <begin_op+0x2c>
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b98:	c7 44 24 04 80 36 11 	movl   $0x80113680,0x4(%esp)
80102b9f:	80 
80102ba0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ba7:	e8 54 12 00 00       	call   80103e00 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bac:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	75 e3                	jne    80102b98 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bb5:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102bba:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102bc0:	83 c0 01             	add    $0x1,%eax
80102bc3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bc6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bc9:	83 fa 1e             	cmp    $0x1e,%edx
80102bcc:	7f ca                	jg     80102b98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bce:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bd5:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102bda:	e8 71 18 00 00       	call   80104450 <release>
      break;
    }
  }
}
80102bdf:	c9                   	leave  
80102be0:	c3                   	ret    
80102be1:	eb 0d                	jmp    80102bf0 <end_op>
80102be3:	90                   	nop
80102be4:	90                   	nop
80102be5:	90                   	nop
80102be6:	90                   	nop
80102be7:	90                   	nop
80102be8:	90                   	nop
80102be9:	90                   	nop
80102bea:	90                   	nop
80102beb:	90                   	nop
80102bec:	90                   	nop
80102bed:	90                   	nop
80102bee:	90                   	nop
80102bef:	90                   	nop

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102c00:	e8 5b 17 00 00       	call   80104360 <acquire>
  log.outstanding -= 1;
80102c05:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c0a:	8b 15 c0 36 11 80    	mov    0x801136c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c10:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c13:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c15:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102c1a:	0f 85 f3 00 00 00    	jne    80102d13 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c20:	85 c0                	test   %eax,%eax
80102c22:	0f 85 cb 00 00 00    	jne    80102cf3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c28:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c2f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c31:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c38:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c3b:	e8 10 18 00 00       	call   80104450 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c40:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	0f 8e 90 00 00 00    	jle    80102cdd <end_op+0xed>
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c55:	01 d8                	add    %ebx,%eax
80102c57:	83 c0 01             	add    $0x1,%eax
80102c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5e:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c63:	89 04 24             	mov    %eax,(%esp)
80102c66:	e8 65 d4 ff ff       	call   801000d0 <bread>
80102c6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c6d:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c74:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7b:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c80:	89 04 24             	mov    %eax,(%esp)
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c8f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c90:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c92:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c99:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9c:	89 04 24             	mov    %eax,(%esp)
80102c9f:	e8 9c 18 00 00       	call   80104540 <memmove>
    bwrite(to);  // write the log
80102ca4:	89 34 24             	mov    %esi,(%esp)
80102ca7:	e8 f4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cac:	89 3c 24             	mov    %edi,(%esp)
80102caf:	e8 2c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 24 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102cc2:	7c 8c                	jl     80102c50 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc4:	e8 a7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cc9:	e8 02 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cce:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102cd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd8:	e8 93 fd ff ff       	call   80102a70 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ce4:	e8 77 16 00 00       	call   80104360 <acquire>
    log.committing = 0;
80102ce9:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102cf0:	00 00 00 
    wakeup(&log);
80102cf3:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cfa:	e8 a1 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102cff:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d06:	e8 45 17 00 00       	call   80104450 <release>
  }
}
80102d0b:	83 c4 1c             	add    $0x1c,%esp
80102d0e:	5b                   	pop    %ebx
80102d0f:	5e                   	pop    %esi
80102d10:	5f                   	pop    %edi
80102d11:	5d                   	pop    %ebp
80102d12:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d13:	c7 04 24 84 7d 10 80 	movl   $0x80107d84,(%esp)
80102d1a:	e8 41 d6 ff ff       	call   80100360 <panic>
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	a1 c8 36 11 80       	mov    0x801136c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d2f:	83 f8 1d             	cmp    $0x1d,%eax
80102d32:	0f 8f 98 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d38:	8b 0d b8 36 11 80    	mov    0x801136b8,%ecx
80102d3e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d41:	39 d0                	cmp    %edx,%eax
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 86 00 00 00    	jle    80102ddc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d5d:	e8 fe 15 00 00       	call   80104360 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d62:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d68:	83 fa 00             	cmp    $0x0,%edx
80102d6b:	7e 54                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d6d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d70:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d72:	39 0d cc 36 11 80    	cmp    %ecx,0x801136cc
80102d78:	75 0f                	jne    80102d89 <log_write+0x69>
80102d7a:	eb 3c                	jmp    80102db8 <log_write+0x98>
80102d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d80:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102daa:	83 c4 14             	add    $0x14,%esp
80102dad:	5b                   	pop    %ebx
80102dae:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102daf:	e9 9c 16 00 00       	jmp    80104450 <release>
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	c7 04 24 93 7d 10 80 	movl   $0x80107d93,(%esp)
80102dd7:	e8 84 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddc:	c7 04 24 a9 7d 10 80 	movl   $0x80107da9,(%esp)
80102de3:	e8 78 d5 ff ff       	call   80100360 <panic>
80102de8:	66 90                	xchg   %ax,%ax
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102df7:	e8 44 09 00 00       	call   80103740 <cpuid>
80102dfc:	89 c3                	mov    %eax,%ebx
80102dfe:	e8 3d 09 00 00       	call   80103740 <cpuid>
80102e03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e07:	c7 04 24 c4 7d 10 80 	movl   $0x80107dc4,(%esp)
80102e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e12:	e8 39 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e17:	e8 34 29 00 00       	call   80105750 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e1c:	e8 9f 08 00 00       	call   801036c0 <mycpu>
80102e21:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e23:	b8 01 00 00 00       	mov    $0x1,%eax
80102e28:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e2f:	e8 ec 0c 00 00       	call   80103b20 <scheduler>
80102e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 75 3b 00 00       	call   801069c0 <switchkvm>
  seginit();
80102e4b:	e8 e0 38 00 00       	call   80106730 <seginit>
  lapicinit();
80102e50:	e8 8b f8 ff ff       	call   801026e0 <lapicinit>
  mpmain();
80102e55:	e8 96 ff ff ff       	call   80102df0 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e64:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e69:	83 e4 f0             	and    $0xfffffff0,%esp
80102e6c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e6f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e76:	80 
80102e77:	c7 04 24 f4 70 11 80 	movl   $0x801170f4,(%esp)
80102e7e:	e8 cd f5 ff ff       	call   80102450 <kinit1>
  kvmalloc();      // kernel page table
80102e83:	e8 18 41 00 00       	call   80106fa0 <kvmalloc>
  mpinit();        // detect other processors
80102e88:	e8 73 01 00 00       	call   80103000 <mpinit>
80102e8d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e90:	e8 4b f8 ff ff       	call   801026e0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 96 38 00 00       	call   80106730 <seginit>
  picinit();       // disable pic
80102e9a:	e8 21 03 00 00       	call   801031c0 <picinit>
80102e9f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102ea0:	e8 cb f3 ff ff       	call   80102270 <ioapicinit>
  consoleinit();   // console hardware
80102ea5:	e8 a6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102eaa:	e8 51 2d 00 00       	call   80105c00 <uartinit>
80102eaf:	90                   	nop
  pinit();         // process table
80102eb0:	e8 eb 07 00 00       	call   801036a0 <pinit>
  shminit();       // shared memory
80102eb5:	e8 b6 44 00 00       	call   80107370 <shminit>
  tvinit();        // trap vectors
80102eba:	e8 f1 27 00 00       	call   801056b0 <tvinit>
80102ebf:	90                   	nop
  binit();         // buffer cache
80102ec0:	e8 7b d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ec5:	e8 e6 de ff ff       	call   80100db0 <fileinit>
  ideinit();       // disk 
80102eca:	e8 a1 f1 ff ff       	call   80102070 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ecf:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ed6:	00 
80102ed7:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102ede:	80 
80102edf:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ee6:	e8 55 16 00 00       	call   80104540 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eeb:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102ef2:	00 00 00 
80102ef5:	05 80 37 11 80       	add    $0x80113780,%eax
80102efa:	39 d8                	cmp    %ebx,%eax
80102efc:	76 65                	jbe    80102f63 <main+0x103>
80102efe:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102f00:	e8 bb 07 00 00       	call   801036c0 <mycpu>
80102f05:	39 d8                	cmp    %ebx,%eax
80102f07:	74 41                	je     80102f4a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f09:	e8 02 f6 ff ff       	call   80102510 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f0e:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f15:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f18:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f1f:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f22:	05 00 10 00 00       	add    $0x1000,%eax
80102f27:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f2c:	0f b6 03             	movzbl (%ebx),%eax
80102f2f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f36:	00 
80102f37:	89 04 24             	mov    %eax,(%esp)
80102f3a:	e8 e1 f8 ff ff       	call   80102820 <lapicstartap>
80102f3f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f40:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	74 f6                	je     80102f40 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f4a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f51:	00 00 00 
80102f54:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f5a:	05 80 37 11 80       	add    $0x80113780,%eax
80102f5f:	39 c3                	cmp    %eax,%ebx
80102f61:	72 9d                	jb     80102f00 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f63:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f6a:	8e 
80102f6b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f72:	e8 49 f5 ff ff       	call   801024c0 <kinit2>
  userinit();      // first user process
80102f77:	e8 14 08 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102f7c:	e8 6f fe ff ff       	call   80102df0 <mpmain>
80102f81:	66 90                	xchg   %ax,%ax
80102f83:	66 90                	xchg   %ax,%ax
80102f85:	66 90                	xchg   %ax,%ax
80102f87:	66 90                	xchg   %ax,%ax
80102f89:	66 90                	xchg   %ax,%ax
80102f8b:	66 90                	xchg   %ax,%ax
80102f8d:	66 90                	xchg   %ax,%ax
80102f8f:	90                   	nop

80102f90 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f94:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f9b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fa1:	39 de                	cmp    %ebx,%esi
80102fa3:	73 3c                	jae    80102fe1 <mpsearch1+0x51>
80102fa5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102faf:	00 
80102fb0:	c7 44 24 04 d8 7d 10 	movl   $0x80107dd8,0x4(%esp)
80102fb7:	80 
80102fb8:	89 34 24             	mov    %esi,(%esp)
80102fbb:	e8 30 15 00 00       	call   801044f0 <memcmp>
80102fc0:	85 c0                	test   %eax,%eax
80102fc2:	75 16                	jne    80102fda <mpsearch1+0x4a>
80102fc4:	31 c9                	xor    %ecx,%ecx
80102fc6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fc8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fcc:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fcf:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd1:	83 fa 10             	cmp    $0x10,%edx
80102fd4:	75 f2                	jne    80102fc8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fd6:	84 c9                	test   %cl,%cl
80102fd8:	74 10                	je     80102fea <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fda:	83 c6 10             	add    $0x10,%esi
80102fdd:	39 f3                	cmp    %esi,%ebx
80102fdf:	77 c7                	ja     80102fa8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fe1:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fe4:	31 c0                	xor    %eax,%eax
}
80102fe6:	5b                   	pop    %ebx
80102fe7:	5e                   	pop    %esi
80102fe8:	5d                   	pop    %ebp
80102fe9:	c3                   	ret    
80102fea:	83 c4 10             	add    $0x10,%esp
80102fed:	89 f0                	mov    %esi,%eax
80102fef:	5b                   	pop    %ebx
80102ff0:	5e                   	pop    %esi
80102ff1:	5d                   	pop    %ebp
80102ff2:	c3                   	ret    
80102ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103009:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103010:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103017:	c1 e0 08             	shl    $0x8,%eax
8010301a:	09 d0                	or     %edx,%eax
8010301c:	c1 e0 04             	shl    $0x4,%eax
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 1b                	jne    8010303e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103023:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010302a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103031:	c1 e0 08             	shl    $0x8,%eax
80103034:	09 d0                	or     %edx,%eax
80103036:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103039:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010303e:	ba 00 04 00 00       	mov    $0x400,%edx
80103043:	e8 48 ff ff ff       	call   80102f90 <mpsearch1>
80103048:	85 c0                	test   %eax,%eax
8010304a:	89 c7                	mov    %eax,%edi
8010304c:	0f 84 22 01 00 00    	je     80103174 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103052:	8b 77 04             	mov    0x4(%edi),%esi
80103055:	85 f6                	test   %esi,%esi
80103057:	0f 84 30 01 00 00    	je     8010318d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010305d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103063:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010306a:	00 
8010306b:	c7 44 24 04 dd 7d 10 	movl   $0x80107ddd,0x4(%esp)
80103072:	80 
80103073:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103076:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103079:	e8 72 14 00 00       	call   801044f0 <memcmp>
8010307e:	85 c0                	test   %eax,%eax
80103080:	0f 85 07 01 00 00    	jne    8010318d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103086:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010308d:	3c 04                	cmp    $0x4,%al
8010308f:	0f 85 0b 01 00 00    	jne    801031a0 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103095:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010309c:	85 c0                	test   %eax,%eax
8010309e:	74 21                	je     801030c1 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030a0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030a2:	31 d2                	xor    %edx,%edx
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030a8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030af:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030b3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b5:	39 d0                	cmp    %edx,%eax
801030b7:	7f ef                	jg     801030a8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b9:	84 c9                	test   %cl,%cl
801030bb:	0f 85 cc 00 00 00    	jne    8010318d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c4:	85 c0                	test   %eax,%eax
801030c6:	0f 84 c1 00 00 00    	je     8010318d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030cc:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030d2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030d7:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030dc:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030e3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030e9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030f0:	39 c2                	cmp    %eax,%edx
801030f2:	76 1b                	jbe    8010310f <mpinit+0x10f>
801030f4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030f7:	80 f9 04             	cmp    $0x4,%cl
801030fa:	77 74                	ja     80103170 <mpinit+0x170>
801030fc:	ff 24 8d 1c 7e 10 80 	jmp    *-0x7fef81e4(,%ecx,4)
80103103:	90                   	nop
80103104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103108:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010310b:	39 c2                	cmp    %eax,%edx
8010310d:	77 e5                	ja     801030f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010310f:	85 db                	test   %ebx,%ebx
80103111:	0f 84 93 00 00 00    	je     801031aa <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103117:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010311b:	74 12                	je     8010312f <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311d:	ba 22 00 00 00       	mov    $0x22,%edx
80103122:	b8 70 00 00 00       	mov    $0x70,%eax
80103127:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103128:	b2 23                	mov    $0x23,%dl
8010312a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010312b:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312e:	ee                   	out    %al,(%dx)
  }
}
8010312f:	83 c4 1c             	add    $0x1c,%esp
80103132:	5b                   	pop    %ebx
80103133:	5e                   	pop    %esi
80103134:	5f                   	pop    %edi
80103135:	5d                   	pop    %ebp
80103136:	c3                   	ret    
80103137:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103138:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
8010313e:	83 fe 07             	cmp    $0x7,%esi
80103141:	7f 17                	jg     8010315a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103143:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103147:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010314d:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103154:	88 8e 80 37 11 80    	mov    %cl,-0x7feec880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010315a:	83 c0 14             	add    $0x14,%eax
      continue;
8010315d:	eb 91                	jmp    801030f0 <mpinit+0xf0>
8010315f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103160:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103164:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103167:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
8010316d:	eb 81                	jmp    801030f0 <mpinit+0xf0>
8010316f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103170:	31 db                	xor    %ebx,%ebx
80103172:	eb 83                	jmp    801030f7 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103174:	ba 00 00 01 00       	mov    $0x10000,%edx
80103179:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010317e:	e8 0d fe ff ff       	call   80102f90 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103183:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103185:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103187:	0f 85 c5 fe ff ff    	jne    80103052 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010318d:	c7 04 24 e2 7d 10 80 	movl   $0x80107de2,(%esp)
80103194:	e8 c7 d1 ff ff       	call   80100360 <panic>
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031a0:	3c 01                	cmp    $0x1,%al
801031a2:	0f 84 ed fe ff ff    	je     80103095 <mpinit+0x95>
801031a8:	eb e3                	jmp    8010318d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031aa:	c7 04 24 fc 7d 10 80 	movl   $0x80107dfc,(%esp)
801031b1:	e8 aa d1 ff ff       	call   80100360 <panic>
801031b6:	66 90                	xchg   %ax,%ax
801031b8:	66 90                	xchg   %ax,%ax
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	ba 21 00 00 00       	mov    $0x21,%edx
801031c6:	89 e5                	mov    %esp,%ebp
801031c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031cd:	ee                   	out    %al,(%dx)
801031ce:	b2 a1                	mov    $0xa1,%dl
801031d0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031d1:	5d                   	pop    %ebp
801031d2:	c3                   	ret    
801031d3:	66 90                	xchg   %ax,%ax
801031d5:	66 90                	xchg   %ax,%ax
801031d7:	66 90                	xchg   %ax,%ax
801031d9:	66 90                	xchg   %ax,%ax
801031db:	66 90                	xchg   %ax,%ax
801031dd:	66 90                	xchg   %ax,%ax
801031df:	90                   	nop

801031e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
801031e9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031fb:	e8 d0 db ff ff       	call   80100dd0 <filealloc>
80103200:	85 c0                	test   %eax,%eax
80103202:	89 06                	mov    %eax,(%esi)
80103204:	0f 84 a4 00 00 00    	je     801032ae <pipealloc+0xce>
8010320a:	e8 c1 db ff ff       	call   80100dd0 <filealloc>
8010320f:	85 c0                	test   %eax,%eax
80103211:	89 03                	mov    %eax,(%ebx)
80103213:	0f 84 87 00 00 00    	je     801032a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103219:	e8 f2 f2 ff ff       	call   80102510 <kalloc>
8010321e:	85 c0                	test   %eax,%eax
80103220:	89 c7                	mov    %eax,%edi
80103222:	74 7c                	je     801032a0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103224:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010322b:	00 00 00 
  p->writeopen = 1;
8010322e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103235:	00 00 00 
  p->nwrite = 0;
80103238:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010323f:	00 00 00 
  p->nread = 0;
80103242:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103249:	00 00 00 
  initlock(&p->lock, "pipe");
8010324c:	89 04 24             	mov    %eax,(%esp)
8010324f:	c7 44 24 04 30 7e 10 	movl   $0x80107e30,0x4(%esp)
80103256:	80 
80103257:	e8 14 10 00 00       	call   80104270 <initlock>
  (*f0)->type = FD_PIPE;
8010325c:	8b 06                	mov    (%esi),%eax
8010325e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103264:	8b 06                	mov    (%esi),%eax
80103266:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010326a:	8b 06                	mov    (%esi),%eax
8010326c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103270:	8b 06                	mov    (%esi),%eax
80103272:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103275:	8b 03                	mov    (%ebx),%eax
80103277:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010327d:	8b 03                	mov    (%ebx),%eax
8010327f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103283:	8b 03                	mov    (%ebx),%eax
80103285:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103289:	8b 03                	mov    (%ebx),%eax
  return 0;
8010328b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010328d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103290:	83 c4 1c             	add    $0x1c,%esp
80103293:	89 d8                	mov    %ebx,%eax
80103295:	5b                   	pop    %ebx
80103296:	5e                   	pop    %esi
80103297:	5f                   	pop    %edi
80103298:	5d                   	pop    %ebp
80103299:	c3                   	ret    
8010329a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a0:	8b 06                	mov    (%esi),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 08                	je     801032ae <pipealloc+0xce>
    fileclose(*f0);
801032a6:	89 04 24             	mov    %eax,(%esp)
801032a9:	e8 e2 db ff ff       	call   80100e90 <fileclose>
  if(*f1)
801032ae:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801032b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801032b5:	85 c0                	test   %eax,%eax
801032b7:	74 d7                	je     80103290 <pipealloc+0xb0>
    fileclose(*f1);
801032b9:	89 04 24             	mov    %eax,(%esp)
801032bc:	e8 cf db ff ff       	call   80100e90 <fileclose>
  return -1;
}
801032c1:	83 c4 1c             	add    $0x1c,%esp
801032c4:	89 d8                	mov    %ebx,%eax
801032c6:	5b                   	pop    %ebx
801032c7:	5e                   	pop    %esi
801032c8:	5f                   	pop    %edi
801032c9:	5d                   	pop    %ebp
801032ca:	c3                   	ret    
801032cb:	90                   	nop
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	56                   	push   %esi
801032d4:	53                   	push   %ebx
801032d5:	83 ec 10             	sub    $0x10,%esp
801032d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032db:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032de:	89 1c 24             	mov    %ebx,(%esp)
801032e1:	e8 7a 10 00 00       	call   80104360 <acquire>
  if(writable){
801032e6:	85 f6                	test   %esi,%esi
801032e8:	74 3e                	je     80103328 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032ea:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032f0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032f7:	00 00 00 
    wakeup(&p->nread);
801032fa:	89 04 24             	mov    %eax,(%esp)
801032fd:	e8 9e 0c 00 00       	call   80103fa0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103302:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103308:	85 d2                	test   %edx,%edx
8010330a:	75 0a                	jne    80103316 <pipeclose+0x46>
8010330c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103312:	85 c0                	test   %eax,%eax
80103314:	74 32                	je     80103348 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103316:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103319:	83 c4 10             	add    $0x10,%esp
8010331c:	5b                   	pop    %ebx
8010331d:	5e                   	pop    %esi
8010331e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010331f:	e9 2c 11 00 00       	jmp    80104450 <release>
80103324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103328:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010332e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103335:	00 00 00 
    wakeup(&p->nwrite);
80103338:	89 04 24             	mov    %eax,(%esp)
8010333b:	e8 60 0c 00 00       	call   80103fa0 <wakeup>
80103340:	eb c0                	jmp    80103302 <pipeclose+0x32>
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103348:	89 1c 24             	mov    %ebx,(%esp)
8010334b:	e8 00 11 00 00       	call   80104450 <release>
    kfree((char*)p);
80103350:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103353:	83 c4 10             	add    $0x10,%esp
80103356:	5b                   	pop    %ebx
80103357:	5e                   	pop    %esi
80103358:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103359:	e9 02 f0 ff ff       	jmp    80102360 <kfree>
8010335e:	66 90                	xchg   %ax,%ax

80103360 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 1c             	sub    $0x1c,%esp
80103369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010336c:	89 1c 24             	mov    %ebx,(%esp)
8010336f:	e8 ec 0f 00 00       	call   80104360 <acquire>
  for(i = 0; i < n; i++){
80103374:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103377:	85 c9                	test   %ecx,%ecx
80103379:	0f 8e b2 00 00 00    	jle    80103431 <pipewrite+0xd1>
8010337f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103382:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103388:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010338e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103394:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103397:	03 4d 10             	add    0x10(%ebp),%ecx
8010339a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010339d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033a3:	81 c1 00 02 00 00    	add    $0x200,%ecx
801033a9:	39 c8                	cmp    %ecx,%eax
801033ab:	74 38                	je     801033e5 <pipewrite+0x85>
801033ad:	eb 55                	jmp    80103404 <pipewrite+0xa4>
801033af:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801033b0:	e8 ab 03 00 00       	call   80103760 <myproc>
801033b5:	8b 40 24             	mov    0x24(%eax),%eax
801033b8:	85 c0                	test   %eax,%eax
801033ba:	75 33                	jne    801033ef <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033bc:	89 3c 24             	mov    %edi,(%esp)
801033bf:	e8 dc 0b 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033c8:	89 34 24             	mov    %esi,(%esp)
801033cb:	e8 30 0a 00 00       	call   80103e00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033d0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033d6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033dc:	05 00 02 00 00       	add    $0x200,%eax
801033e1:	39 c2                	cmp    %eax,%edx
801033e3:	75 23                	jne    80103408 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033e5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033eb:	85 d2                	test   %edx,%edx
801033ed:	75 c1                	jne    801033b0 <pipewrite+0x50>
        release(&p->lock);
801033ef:	89 1c 24             	mov    %ebx,(%esp)
801033f2:	e8 59 10 00 00       	call   80104450 <release>
        return -1;
801033f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033fc:	83 c4 1c             	add    $0x1c,%esp
801033ff:	5b                   	pop    %ebx
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103404:	89 c2                	mov    %eax,%edx
80103406:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103408:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010340b:	8d 42 01             	lea    0x1(%edx),%eax
8010340e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103414:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010341a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010341e:	0f b6 09             	movzbl (%ecx),%ecx
80103421:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103425:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103428:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010342b:	0f 85 6c ff ff ff    	jne    8010339d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103431:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103437:	89 04 24             	mov    %eax,(%esp)
8010343a:	e8 61 0b 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
8010343f:	89 1c 24             	mov    %ebx,(%esp)
80103442:	e8 09 10 00 00       	call   80104450 <release>
  return n;
80103447:	8b 45 10             	mov    0x10(%ebp),%eax
8010344a:	eb b0                	jmp    801033fc <pipewrite+0x9c>
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103450 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 1c             	sub    $0x1c,%esp
80103459:	8b 75 08             	mov    0x8(%ebp),%esi
8010345c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010345f:	89 34 24             	mov    %esi,(%esp)
80103462:	e8 f9 0e 00 00       	call   80104360 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103467:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010346d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103473:	75 5b                	jne    801034d0 <piperead+0x80>
80103475:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010347b:	85 db                	test   %ebx,%ebx
8010347d:	74 51                	je     801034d0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010347f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103485:	eb 25                	jmp    801034ac <piperead+0x5c>
80103487:	90                   	nop
80103488:	89 74 24 04          	mov    %esi,0x4(%esp)
8010348c:	89 1c 24             	mov    %ebx,(%esp)
8010348f:	e8 6c 09 00 00       	call   80103e00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103494:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010349a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034a0:	75 2e                	jne    801034d0 <piperead+0x80>
801034a2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801034a8:	85 d2                	test   %edx,%edx
801034aa:	74 24                	je     801034d0 <piperead+0x80>
    if(myproc()->killed){
801034ac:	e8 af 02 00 00       	call   80103760 <myproc>
801034b1:	8b 48 24             	mov    0x24(%eax),%ecx
801034b4:	85 c9                	test   %ecx,%ecx
801034b6:	74 d0                	je     80103488 <piperead+0x38>
      release(&p->lock);
801034b8:	89 34 24             	mov    %esi,(%esp)
801034bb:	e8 90 0f 00 00       	call   80104450 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034c0:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034c8:	5b                   	pop    %ebx
801034c9:	5e                   	pop    %esi
801034ca:	5f                   	pop    %edi
801034cb:	5d                   	pop    %ebp
801034cc:	c3                   	ret    
801034cd:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034d0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034d3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034d5:	85 d2                	test   %edx,%edx
801034d7:	7f 2b                	jg     80103504 <piperead+0xb4>
801034d9:	eb 31                	jmp    8010350c <piperead+0xbc>
801034db:	90                   	nop
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034e0:	8d 48 01             	lea    0x1(%eax),%ecx
801034e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034f6:	83 c3 01             	add    $0x1,%ebx
801034f9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034fc:	74 0e                	je     8010350c <piperead+0xbc>
    if(p->nread == p->nwrite)
801034fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103504:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010350a:	75 d4                	jne    801034e0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010350c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103512:	89 04 24             	mov    %eax,(%esp)
80103515:	e8 86 0a 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
8010351a:	89 34 24             	mov    %esi,(%esp)
8010351d:	e8 2e 0f 00 00       	call   80104450 <release>
  return i;
}
80103522:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103525:	89 d8                	mov    %ebx,%eax
}
80103527:	5b                   	pop    %ebx
80103528:	5e                   	pop    %esi
80103529:	5f                   	pop    %edi
8010352a:	5d                   	pop    %ebp
8010352b:	c3                   	ret    
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	53                   	push   %ebx
  struct proc *p;
  char *sp;
	int page_id;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103534:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103539:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;
	int page_id;
  acquire(&ptable.lock);
8010353c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103543:	e8 18 0e 00 00       	call   80104360 <acquire>
80103548:	eb 18                	jmp    80103562 <allocproc+0x32>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103550:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103556:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010355c:	0f 84 ce 00 00 00    	je     80103630 <allocproc+0x100>
    if(p->state == UNUSED)
80103562:	8b 43 0c             	mov    0xc(%ebx),%eax
80103565:	85 c0                	test   %eax,%eax
80103567:	75 e7                	jne    80103550 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103569:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010356e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103575:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010357c:	8d 50 01             	lea    0x1(%eax),%edx
8010357f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103585:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103588:	e8 c3 0e 00 00       	call   80104450 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010358d:	e8 7e ef ff ff       	call   80102510 <kalloc>
80103592:	85 c0                	test   %eax,%eax
80103594:	89 43 08             	mov    %eax,0x8(%ebx)
80103597:	0f 84 a7 00 00 00    	je     80103644 <allocproc+0x114>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010359d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035a3:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035a8:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801035ab:	c7 40 14 a5 56 10 80 	movl   $0x801056a5,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035b2:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801035b9:	00 
801035ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035c1:	00 
801035c2:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801035c5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801035c8:	e8 d3 0e 00 00       	call   801044a0 <memset>
  p->context->eip = (uint)forkret;
801035cd:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035d0:	c7 40 10 50 36 10 80 	movl   $0x80103650,0x10(%eax)
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
801035d7:	89 d8                	mov    %ebx,%eax
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801035d9:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801035e0:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801035e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801035ea:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801035ed:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
801035f4:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801035f7:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801035fe:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103601:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
80103608:	ff ff ff 
		p->pages[page_id].vaddr = 0;
8010360b:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103612:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103615:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
8010361c:	ff ff ff 
		p->pages[page_id].vaddr = 0;
8010361f:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80103626:	00 00 00 
	}
  return p;
}
80103629:	83 c4 14             	add    $0x14,%esp
8010362c:	5b                   	pop    %ebx
8010362d:	5d                   	pop    %ebp
8010362e:	c3                   	ret    
8010362f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103630:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103637:	e8 14 0e 00 00       	call   80104450 <release>
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  return p;
}
8010363c:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
8010363f:	31 c0                	xor    %eax,%eax
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  return p;
}
80103641:	5b                   	pop    %ebx
80103642:	5d                   	pop    %ebp
80103643:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103644:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010364b:	eb dc                	jmp    80103629 <allocproc+0xf9>
8010364d:	8d 76 00             	lea    0x0(%esi),%esi

80103650 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103656:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010365d:	e8 ee 0d 00 00       	call   80104450 <release>

  if (first) {
80103662:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103667:	85 c0                	test   %eax,%eax
80103669:	75 05                	jne    80103670 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010366b:	c9                   	leave  
8010366c:	c3                   	ret    
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103670:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103677:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010367e:	00 00 00 
    iinit(ROOTDEV);
80103681:	e8 5a de ff ff       	call   801014e0 <iinit>
    initlog(ROOTDEV);
80103686:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010368d:	e8 4e f4 ff ff       	call   80102ae0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103692:	c9                   	leave  
80103693:	c3                   	ret    
80103694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010369a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036a0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801036a6:	c7 44 24 04 35 7e 10 	movl   $0x80107e35,0x4(%esp)
801036ad:	80 
801036ae:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801036b5:	e8 b6 0b 00 00       	call   80104270 <initlock>
}
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c8:	9c                   	pushf  
801036c9:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036ca:	f6 c4 02             	test   $0x2,%ah
801036cd:	75 57                	jne    80103726 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036cf:	e8 fc f0 ff ff       	call   801027d0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036d4:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
801036da:	85 f6                	test   %esi,%esi
801036dc:	7e 3c                	jle    8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036de:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
801036e5:	39 c2                	cmp    %eax,%edx
801036e7:	74 2d                	je     80103716 <mycpu+0x56>
801036e9:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036ee:	31 d2                	xor    %edx,%edx
801036f0:	83 c2 01             	add    $0x1,%edx
801036f3:	39 f2                	cmp    %esi,%edx
801036f5:	74 23                	je     8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036f7:	0f b6 19             	movzbl (%ecx),%ebx
801036fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103700:	39 c3                	cmp    %eax,%ebx
80103702:	75 ec                	jne    801036f0 <mycpu+0x30>
      return &cpus[i];
80103704:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	5b                   	pop    %ebx
8010370e:	5e                   	pop    %esi
8010370f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103710:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103715:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103716:	31 d2                	xor    %edx,%edx
80103718:	eb ea                	jmp    80103704 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010371a:	c7 04 24 3c 7e 10 80 	movl   $0x80107e3c,(%esp)
80103721:	e8 3a cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103726:	c7 04 24 18 7f 10 80 	movl   $0x80107f18,(%esp)
8010372d:	e8 2e cc ff ff       	call   80100360 <panic>
80103732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103746:	e8 75 ff ff ff       	call   801036c0 <mycpu>
}
8010374b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010374c:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103751:	c1 f8 04             	sar    $0x4,%eax
80103754:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010375a:	c3                   	ret    
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103760 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
80103764:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103767:	e8 b4 0b 00 00       	call   80104320 <pushcli>
  c = mycpu();
8010376c:	e8 4f ff ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103771:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103777:	e8 64 0c 00 00       	call   801043e0 <popcli>
  return p;
}
8010377c:	83 c4 04             	add    $0x4,%esp
8010377f:	89 d8                	mov    %ebx,%eax
80103781:	5b                   	pop    %ebx
80103782:	5d                   	pop    %ebp
80103783:	c3                   	ret    
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
	int page_id;
  extern char _binary_initcode_start[], _binary_initcode_size[];
	
  p = allocproc();
80103797:	e8 94 fd ff ff       	call   80103530 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010379e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 68 37 00 00       	call   80106f10 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 04             	mov    %eax,0x4(%ebx)
801037ad:	0f 84 2b 01 00 00    	je     801038de <userinit+0x14e>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037bd:	00 
801037be:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
801037c5:	80 
801037c6:	e8 25 33 00 00       	call   80106af0 <inituvm>
  p->sz = PGSIZE;
801037cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->tstack = 0; // For CS153 lab2 part 1
801037d1:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037d8:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037df:	00 
801037e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037e7:	00 
801037e8:	8b 43 18             	mov    0x18(%ebx),%eax
801037eb:	89 04 24             	mov    %eax,(%esp)
801037ee:	e8 ad 0c 00 00       	call   801044a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037f3:	8b 43 18             	mov    0x18(%ebx),%eax
801037f6:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037fb:	b9 23 00 00 00       	mov    $0x23,%ecx
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->tstack = 0; // For CS153 lab2 part 1
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103800:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103804:	8b 43 18             	mov    0x18(%ebx),%eax
80103807:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010380b:	8b 43 18             	mov    0x18(%ebx),%eax
8010380e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103812:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103816:	8b 43 18             	mov    0x18(%ebx),%eax
80103819:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010381d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103821:	8b 43 18             	mov    0x18(%ebx),%eax
80103824:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010382b:	8b 43 18             	mov    0x18(%ebx),%eax
8010382e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103835:	8b 43 18             	mov    0x18(%ebx),%eax
80103838:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010383f:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103842:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
80103849:	ff ff ff 
		p->pages[page_id].vaddr = 0;
8010384c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103853:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103856:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
8010385d:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103860:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103867:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
8010386a:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
80103871:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103874:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010387b:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
8010387e:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
80103885:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103888:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010388f:	00 00 00 
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103892:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103899:	00 
8010389a:	c7 44 24 04 65 7e 10 	movl   $0x80107e65,0x4(%esp)
801038a1:	80 
801038a2:	89 04 24             	mov    %eax,(%esp)
801038a5:	e8 d6 0d 00 00       	call   80104680 <safestrcpy>
  p->cwd = namei("/");
801038aa:	c7 04 24 6e 7e 10 80 	movl   $0x80107e6e,(%esp)
801038b1:	e8 ba e6 ff ff       	call   80101f70 <namei>
801038b6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038b9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038c0:	e8 9b 0a 00 00       	call   80104360 <acquire>

  p->state = RUNNABLE;
801038c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038cc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038d3:	e8 78 0b 00 00       	call   80104450 <release>
}
801038d8:	83 c4 14             	add    $0x14,%esp
801038db:	5b                   	pop    %ebx
801038dc:	5d                   	pop    %ebp
801038dd:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
	
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038de:	c7 04 24 4c 7e 10 80 	movl   $0x80107e4c,(%esp)
801038e5:	e8 76 ca ff ff       	call   80100360 <panic>
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <growproc>:
// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.

int
growproc(int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 1c             	sub    $0x1c,%esp
  uint sz;
  struct proc *curproc = myproc();
801038f9:	e8 62 fe ff ff       	call   80103760 <myproc>
801038fe:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103900:	8b 30                	mov    (%eax),%esi
  if(curproc->tstack != 0)
80103902:	8b 40 7c             	mov    0x7c(%eax),%eax
80103905:	85 c0                	test   %eax,%eax
80103907:	74 12                	je     8010391b <growproc+0x2b>
   {
	  if(sz + n >= curproc->tstack-PGSIZE)
80103909:	8b 55 08             	mov    0x8(%ebp),%edx
8010390c:	2d 00 10 00 00       	sub    $0x1000,%eax
80103911:	01 f2                	add    %esi,%edx
80103913:	39 c2                	cmp    %eax,%edx
80103915:	0f 83 9d 00 00 00    	jae    801039b8 <growproc+0xc8>
		  return -1;
   }
	resetpteu(curproc->pgdir,(char *)PGROUNDUP(sz));
8010391b:	8d be ff 0f 00 00    	lea    0xfff(%esi),%edi
80103921:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80103927:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010392b:	8b 53 04             	mov    0x4(%ebx),%edx
8010392e:	89 14 24             	mov    %edx,(%esp)
80103931:	e8 ca 36 00 00       	call   80107000 <resetpteu>
  if(n > 0){
80103936:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010393a:	7e 5c                	jle    80103998 <growproc+0xa8>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010393c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010393f:	89 74 24 04          	mov    %esi,0x4(%esp)
80103943:	01 f7                	add    %esi,%edi
80103945:	89 7c 24 08          	mov    %edi,0x8(%esp)
80103949:	8b 43 04             	mov    0x4(%ebx),%eax
8010394c:	89 04 24             	mov    %eax,(%esp)
8010394f:	e8 fc 32 00 00       	call   80106c50 <allocuvm>
80103954:	85 c0                	test   %eax,%eax
80103956:	89 c6                	mov    %eax,%esi
80103958:	74 5e                	je     801039b8 <growproc+0xc8>
      return -1;
		if(sz+PGSIZE >= curproc->tstack) return -1;
8010395a:	8d 80 00 10 00 00    	lea    0x1000(%eax),%eax
80103960:	3b 43 7c             	cmp    0x7c(%ebx),%eax
80103963:	73 53                	jae    801039b8 <growproc+0xc8>
80103965:	8d be ff 0f 00 00    	lea    0xfff(%esi),%edi
8010396b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
	clearpteu(curproc->pgdir,(char *)PGROUNDUP(sz));
80103971:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103975:	8b 43 04             	mov    0x4(%ebx),%eax
80103978:	89 04 24             	mov    %eax,(%esp)
8010397b:	e8 40 36 00 00       	call   80106fc0 <clearpteu>
  curproc->sz = sz;
80103980:	89 33                	mov    %esi,(%ebx)
  switchuvm(curproc);
80103982:	89 1c 24             	mov    %ebx,(%esp)
80103985:	e8 56 30 00 00       	call   801069e0 <switchuvm>
  return 0;
8010398a:	31 c0                	xor    %eax,%eax
}
8010398c:	83 c4 1c             	add    $0x1c,%esp
8010398f:	5b                   	pop    %ebx
80103990:	5e                   	pop    %esi
80103991:	5f                   	pop    %edi
80103992:	5d                   	pop    %ebp
80103993:	c3                   	ret    
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	resetpteu(curproc->pgdir,(char *)PGROUNDUP(sz));
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
		if(sz+PGSIZE >= curproc->tstack) return -1;
  } else if(n < 0){
80103998:	74 d7                	je     80103971 <growproc+0x81>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010399a:	8b 7d 08             	mov    0x8(%ebp),%edi
8010399d:	89 74 24 04          	mov    %esi,0x4(%esp)
801039a1:	01 f7                	add    %esi,%edi
801039a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
801039a7:	8b 43 04             	mov    0x4(%ebx),%eax
801039aa:	89 04 24             	mov    %eax,(%esp)
801039ad:	e8 be 34 00 00       	call   80106e70 <deallocuvm>
801039b2:	85 c0                	test   %eax,%eax
801039b4:	89 c6                	mov    %eax,%esi
801039b6:	75 ad                	jne    80103965 <growproc+0x75>
  struct proc *curproc = myproc();
  sz = curproc->sz;
  if(curproc->tstack != 0)
   {
	  if(sz + n >= curproc->tstack-PGSIZE)
		  return -1;
801039b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039bd:	eb cd                	jmp    8010398c <growproc+0x9c>
801039bf:	90                   	nop

801039c0 <fork>:
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.

int
fork(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801039c9:	e8 92 fd ff ff       	call   80103760 <myproc>
801039ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int page_id;
  // Allocate process.
  if((np = allocproc()) == 0){
801039d1:	e8 5a fb ff ff       	call   80103530 <allocproc>
801039d6:	85 c0                	test   %eax,%eax
801039d8:	89 c3                	mov    %eax,%ebx
801039da:	0f 84 14 01 00 00    	je     80103af4 <fork+0x134>
    return -1;
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039e3:	8b 02                	mov    (%edx),%eax
801039e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801039e9:	8b 42 04             	mov    0x4(%edx),%eax
801039ec:	89 04 24             	mov    %eax,(%esp)
801039ef:	e8 4c 36 00 00       	call   80107040 <copyuvm>
801039f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039f7:	85 c0                	test   %eax,%eax
801039f9:	89 43 04             	mov    %eax,0x4(%ebx)
801039fc:	0f 84 f9 00 00 00    	je     80103afb <fork+0x13b>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
80103a02:	8b 42 7c             	mov    0x7c(%edx),%eax
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103a05:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a0a:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
80103a0d:	89 43 7c             	mov    %eax,0x7c(%ebx)
  np->sz = curproc->sz;
80103a10:	8b 02                	mov    (%edx),%eax
  np->parent = curproc;
80103a12:	89 53 14             	mov    %edx,0x14(%ebx)
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
80103a15:	89 03                	mov    %eax,(%ebx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103a17:	8b 72 18             	mov    0x18(%edx),%esi
80103a1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		np->pages[page_id].vaddr = 0;
	}
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a1c:	31 f6                	xor    %esi,%esi
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		np->pages[page_id].id = -1;
80103a1e:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
80103a25:	ff ff ff 
		np->pages[page_id].vaddr = 0;
80103a28:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a2f:	00 00 00 
	}
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a32:	8b 43 18             	mov    0x18(%ebx),%eax
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		np->pages[page_id].id = -1;
80103a35:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
80103a3c:	ff ff ff 
		np->pages[page_id].vaddr = 0;
80103a3f:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103a46:	00 00 00 
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		np->pages[page_id].id = -1;
80103a49:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
80103a50:	ff ff ff 
		np->pages[page_id].vaddr = 0;
80103a53:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103a5a:	00 00 00 
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		np->pages[page_id].id = -1;
80103a5d:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
80103a64:	ff ff ff 
		np->pages[page_id].vaddr = 0;
80103a67:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80103a6e:	00 00 00 
	}
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a71:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a78:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a7c:	85 c0                	test   %eax,%eax
80103a7e:	74 12                	je     80103a92 <fork+0xd2>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a80:	89 04 24             	mov    %eax,(%esp)
80103a83:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103a86:	e8 b5 d3 ff ff       	call   80100e40 <filedup>
80103a8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a8e:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
		np->pages[page_id].vaddr = 0;
	}
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a92:	83 c6 01             	add    $0x1,%esi
80103a95:	83 fe 10             	cmp    $0x10,%esi
80103a98:	75 de                	jne    80103a78 <fork+0xb8>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a9a:	8b 42 68             	mov    0x68(%edx),%eax
80103a9d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103aa0:	89 04 24             	mov    %eax,(%esp)
80103aa3:	e8 48 dc ff ff       	call   801016f0 <idup>

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aa8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103aab:	83 c2 6c             	add    $0x6c,%edx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103aae:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ab1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ab4:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ab8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103abf:	00 
80103ac0:	89 04 24             	mov    %eax,(%esp)
80103ac3:	e8 b8 0b 00 00       	call   80104680 <safestrcpy>

  pid = np->pid;
80103ac8:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103acb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ad2:	e8 89 08 00 00       	call   80104360 <acquire>

  np->state = RUNNABLE;
80103ad7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103ade:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ae5:	e8 66 09 00 00       	call   80104450 <release>
  return pid;
80103aea:	89 f0                	mov    %esi,%eax
}
80103aec:	83 c4 1c             	add    $0x1c,%esp
80103aef:	5b                   	pop    %ebx
80103af0:	5e                   	pop    %esi
80103af1:	5f                   	pop    %edi
80103af2:	5d                   	pop    %ebp
80103af3:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();
	int page_id;
  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103af4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103af9:	eb f1                	jmp    80103aec <fork+0x12c>
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103afb:	8b 43 08             	mov    0x8(%ebx),%eax
80103afe:	89 04 24             	mov    %eax,(%esp)
80103b01:	e8 5a e8 ff ff       	call   80102360 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103b0b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b12:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b19:	eb d1                	jmp    80103aec <fork+0x12c>
80103b1b:	90                   	nop
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103b29:	e8 92 fb ff ff       	call   801036c0 <mycpu>
80103b2e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b30:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b37:	00 00 00 
80103b3a:	8d 78 04             	lea    0x4(%eax),%edi
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b41:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b48:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b4d:	e8 0e 08 00 00       	call   80104360 <acquire>
80103b52:	eb 12                	jmp    80103b66 <scheduler+0x46>
80103b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b58:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103b5e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103b64:	74 52                	je     80103bb8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103b66:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b6a:	75 ec                	jne    80103b58 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103b6c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b72:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b75:	81 c3 a0 00 00 00    	add    $0xa0,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b7b:	e8 60 2e 00 00       	call   801069e0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b80:	8b 83 7c ff ff ff    	mov    -0x84(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b86:	c7 83 6c ff ff ff 04 	movl   $0x4,-0x94(%ebx)
80103b8d:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103b90:	89 3c 24             	mov    %edi,(%esp)
80103b93:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b97:	e8 3f 0b 00 00       	call   801046db <swtch>
      switchkvm();
80103b9c:	e8 1f 2e 00 00       	call   801069c0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba1:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ba7:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103bae:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb1:	75 b3                	jne    80103b66 <scheduler+0x46>
80103bb3:	90                   	nop
80103bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103bb8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bbf:	e8 8c 08 00 00       	call   80104450 <release>

  }
80103bc4:	e9 77 ff ff ff       	jmp    80103b40 <scheduler+0x20>
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103bd8:	e8 83 fb ff ff       	call   80103760 <myproc>

  if(!holding(&ptable.lock))
80103bdd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103be4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103be6:	e8 05 07 00 00       	call   801042f0 <holding>
80103beb:	85 c0                	test   %eax,%eax
80103bed:	74 4f                	je     80103c3e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103bef:	e8 cc fa ff ff       	call   801036c0 <mycpu>
80103bf4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bfb:	75 65                	jne    80103c62 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103bfd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c01:	74 53                	je     80103c56 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c03:	9c                   	pushf  
80103c04:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103c05:	f6 c4 02             	test   $0x2,%ah
80103c08:	75 40                	jne    80103c4a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c0a:	e8 b1 fa ff ff       	call   801036c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c0f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c12:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c18:	e8 a3 fa ff ff       	call   801036c0 <mycpu>
80103c1d:	8b 40 04             	mov    0x4(%eax),%eax
80103c20:	89 1c 24             	mov    %ebx,(%esp)
80103c23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c27:	e8 af 0a 00 00       	call   801046db <swtch>
  mycpu()->intena = intena;
80103c2c:	e8 8f fa ff ff       	call   801036c0 <mycpu>
80103c31:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c37:	83 c4 10             	add    $0x10,%esp
80103c3a:	5b                   	pop    %ebx
80103c3b:	5e                   	pop    %esi
80103c3c:	5d                   	pop    %ebp
80103c3d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c3e:	c7 04 24 70 7e 10 80 	movl   $0x80107e70,(%esp)
80103c45:	e8 16 c7 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c4a:	c7 04 24 9c 7e 10 80 	movl   $0x80107e9c,(%esp)
80103c51:	e8 0a c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103c56:	c7 04 24 8e 7e 10 80 	movl   $0x80107e8e,(%esp)
80103c5d:	e8 fe c6 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c62:	c7 04 24 82 7e 10 80 	movl   $0x80107e82,(%esp)
80103c69:	e8 f2 c6 ff ff       	call   80100360 <panic>
80103c6e:	66 90                	xchg   %ax,%ax

80103c70 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
	int page_id;
  if(curproc == initproc)
80103c74:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c76:	53                   	push   %ebx
80103c77:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103c7a:	e8 e1 fa ff ff       	call   80103760 <myproc>
  struct proc *p;
  int fd;
	int page_id;
  if(curproc == initproc)
80103c7f:	3b 05 b8 b5 10 80    	cmp    0x8010b5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103c85:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;
	int page_id;
  if(curproc == initproc)
80103c87:	0f 84 1b 01 00 00    	je     80103da8 <exit+0x138>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c94:	85 c0                	test   %eax,%eax
80103c96:	74 10                	je     80103ca8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103c98:	89 04 24             	mov    %eax,(%esp)
80103c9b:	e8 f0 d1 ff ff       	call   80100e90 <fileclose>
      curproc->ofile[fd] = 0;
80103ca0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ca7:	00 
	int page_id;
  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ca8:	83 c6 01             	add    $0x1,%esi
80103cab:	83 fe 10             	cmp    $0x10,%esi
80103cae:	75 e0                	jne    80103c90 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cb0:	e8 cb ee ff ff       	call   80102b80 <begin_op>
  iput(curproc->cwd);
80103cb5:	8b 43 68             	mov    0x68(%ebx),%eax
80103cb8:	89 04 24             	mov    %eax,(%esp)
80103cbb:	e8 80 db ff ff       	call   80101840 <iput>
  end_op();
80103cc0:	e8 2b ef ff ff       	call   80102bf0 <end_op>
  curproc->cwd = 0;
80103cc5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103ccc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cd3:	e8 88 06 00 00       	call   80104360 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103cd8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cdb:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103ce0:	eb 14                	jmp    80103cf6 <exit+0x86>
80103ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ce8:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103cee:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103cf4:	74 20                	je     80103d16 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103cf6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103cfa:	75 ec                	jne    80103ce8 <exit+0x78>
80103cfc:	3b 42 20             	cmp    0x20(%edx),%eax
80103cff:	75 e7                	jne    80103ce8 <exit+0x78>
      p->state = RUNNABLE;
80103d01:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d08:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103d0e:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103d14:	75 e0                	jne    80103cf6 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d16:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103d1b:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
80103d20:	eb 14                	jmp    80103d36 <exit+0xc6>
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d28:	81 c1 a0 00 00 00    	add    $0xa0,%ecx
80103d2e:	81 f9 54 65 11 80    	cmp    $0x80116554,%ecx
80103d34:	74 3c                	je     80103d72 <exit+0x102>
    if(p->parent == curproc){
80103d36:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103d39:	75 ed                	jne    80103d28 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d3b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d3f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103d42:	75 e4                	jne    80103d28 <exit+0xb8>
80103d44:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103d49:	eb 13                	jmp    80103d5e <exit+0xee>
80103d4b:	90                   	nop
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d50:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103d56:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103d5c:	74 ca                	je     80103d28 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103d5e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103d62:	75 ec                	jne    80103d50 <exit+0xe0>
80103d64:	3b 42 20             	cmp    0x20(%edx),%eax
80103d67:	75 e7                	jne    80103d50 <exit+0xe0>
      p->state = RUNNABLE;
80103d69:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103d70:	eb de                	jmp    80103d50 <exit+0xe0>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d72:	31 f6                	xor    %esi,%esi
        wakeup1(initproc);
    }
  }
	
	for(page_id = 0; page_id < MAXPPP; page_id++){
		if(curproc->pages[page_id].id != -1) shm_close(curproc->pages[page_id].id);
80103d74:	8b 84 f3 80 00 00 00 	mov    0x80(%ebx,%esi,8),%eax
80103d7b:	83 f8 ff             	cmp    $0xffffffff,%eax
80103d7e:	74 08                	je     80103d88 <exit+0x118>
80103d80:	89 04 24             	mov    %eax,(%esp)
80103d83:	e8 48 39 00 00       	call   801076d0 <shm_close>
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
	
	for(page_id = 0; page_id < MAXPPP; page_id++){
80103d88:	83 c6 01             	add    $0x1,%esi
80103d8b:	83 fe 04             	cmp    $0x4,%esi
80103d8e:	75 e4                	jne    80103d74 <exit+0x104>
		if(curproc->pages[page_id].id != -1) shm_close(curproc->pages[page_id].id);
	}

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d90:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103d97:	e8 34 fe ff ff       	call   80103bd0 <sched>
  panic("zombie exit");
80103d9c:	c7 04 24 bd 7e 10 80 	movl   $0x80107ebd,(%esp)
80103da3:	e8 b8 c5 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
	int page_id;
  if(curproc == initproc)
    panic("init exiting");
80103da8:	c7 04 24 b0 7e 10 80 	movl   $0x80107eb0,(%esp)
80103daf:	e8 ac c5 ff ff       	call   80100360 <panic>
80103db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103dc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103dc6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dcd:	e8 8e 05 00 00       	call   80104360 <acquire>
  myproc()->state = RUNNABLE;
80103dd2:	e8 89 f9 ff ff       	call   80103760 <myproc>
80103dd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103dde:	e8 ed fd ff ff       	call   80103bd0 <sched>
  release(&ptable.lock);
80103de3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dea:	e8 61 06 00 00       	call   80104450 <release>
}
80103def:	c9                   	leave  
80103df0:	c3                   	ret    
80103df1:	eb 0d                	jmp    80103e00 <sleep>
80103df3:	90                   	nop
80103df4:	90                   	nop
80103df5:	90                   	nop
80103df6:	90                   	nop
80103df7:	90                   	nop
80103df8:	90                   	nop
80103df9:	90                   	nop
80103dfa:	90                   	nop
80103dfb:	90                   	nop
80103dfc:	90                   	nop
80103dfd:	90                   	nop
80103dfe:	90                   	nop
80103dff:	90                   	nop

80103e00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
80103e09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103e0f:	e8 4c f9 ff ff       	call   80103760 <myproc>
  
  if(p == 0)
80103e14:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103e16:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103e18:	0f 84 7c 00 00 00    	je     80103e9a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103e1e:	85 f6                	test   %esi,%esi
80103e20:	74 6c                	je     80103e8e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e22:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103e28:	74 46                	je     80103e70 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e2a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e31:	e8 2a 05 00 00       	call   80104360 <acquire>
    release(lk);
80103e36:	89 34 24             	mov    %esi,(%esp)
80103e39:	e8 12 06 00 00       	call   80104450 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103e3e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e41:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e48:	e8 83 fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  p->chan = 0;
80103e4d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e54:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e5b:	e8 f0 05 00 00       	call   80104450 <release>
    acquire(lk);
80103e60:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103e63:	83 c4 1c             	add    $0x1c,%esp
80103e66:	5b                   	pop    %ebx
80103e67:	5e                   	pop    %esi
80103e68:	5f                   	pop    %edi
80103e69:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e6a:	e9 f1 04 00 00       	jmp    80104360 <acquire>
80103e6f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e70:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103e73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103e7a:	e8 51 fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  p->chan = 0;
80103e7f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e86:	83 c4 1c             	add    $0x1c,%esp
80103e89:	5b                   	pop    %ebx
80103e8a:	5e                   	pop    %esi
80103e8b:	5f                   	pop    %edi
80103e8c:	5d                   	pop    %ebp
80103e8d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e8e:	c7 04 24 cf 7e 10 80 	movl   $0x80107ecf,(%esp)
80103e95:	e8 c6 c4 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e9a:	c7 04 24 c9 7e 10 80 	movl   $0x80107ec9,(%esp)
80103ea1:	e8 ba c4 ff ff       	call   80100360 <panic>
80103ea6:	8d 76 00             	lea    0x0(%esi),%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
80103eb5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103eb8:	e8 a3 f8 ff ff       	call   80103760 <myproc>
  
  acquire(&ptable.lock);
80103ebd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103ec4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103ec6:	e8 95 04 00 00       	call   80104360 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ecb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecd:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103ed2:	eb 12                	jmp    80103ee6 <wait+0x36>
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ede:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103ee4:	74 22                	je     80103f08 <wait+0x58>
      if(p->parent != curproc)
80103ee6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ee9:	75 ed                	jne    80103ed8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103eeb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eef:	74 34                	je     80103f25 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103f02:	75 e2                	jne    80103ee6 <wait+0x36>
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103f08:	85 c0                	test   %eax,%eax
80103f0a:	74 6e                	je     80103f7a <wait+0xca>
80103f0c:	8b 46 24             	mov    0x24(%esi),%eax
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	75 67                	jne    80103f7a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f13:	c7 44 24 04 20 3d 11 	movl   $0x80113d20,0x4(%esp)
80103f1a:	80 
80103f1b:	89 34 24             	mov    %esi,(%esp)
80103f1e:	e8 dd fe ff ff       	call   80103e00 <sleep>
  }
80103f23:	eb a6                	jmp    80103ecb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f25:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f28:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f2b:	89 04 24             	mov    %eax,(%esp)
80103f2e:	e8 2d e4 ff ff       	call   80102360 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f33:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f36:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f3d:	89 04 24             	mov    %eax,(%esp)
80103f40:	e8 4b 2f 00 00       	call   80106e90 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103f45:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103f4c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f53:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f5a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f5e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f6c:	e8 df 04 00 00       	call   80104450 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f71:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f74:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f76:	5b                   	pop    %ebx
80103f77:	5e                   	pop    %esi
80103f78:	5d                   	pop    %ebp
80103f79:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f7a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f81:	e8 ca 04 00 00       	call   80104450 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f86:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f8e:	5b                   	pop    %ebx
80103f8f:	5e                   	pop    %esi
80103f90:	5d                   	pop    %ebp
80103f91:	c3                   	ret    
80103f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 14             	sub    $0x14,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fb1:	e8 aa 03 00 00       	call   80104360 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb6:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fbb:	eb 0f                	jmp    80103fcc <wakeup+0x2c>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
80103fc0:	05 a0 00 00 00       	add    $0xa0,%eax
80103fc5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103fca:	74 24                	je     80103ff0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103fcc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fd0:	75 ee                	jne    80103fc0 <wakeup+0x20>
80103fd2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd5:	75 e9                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fde:	05 a0 00 00 00       	add    $0xa0,%eax
80103fe3:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103fe8:	75 e2                	jne    80103fcc <wakeup+0x2c>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff0:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103ff7:	83 c4 14             	add    $0x14,%esp
80103ffa:	5b                   	pop    %ebx
80103ffb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ffc:	e9 4f 04 00 00       	jmp    80104450 <release>
80104001:	eb 0d                	jmp    80104010 <kill>
80104003:	90                   	nop
80104004:	90                   	nop
80104005:	90                   	nop
80104006:	90                   	nop
80104007:	90                   	nop
80104008:	90                   	nop
80104009:	90                   	nop
8010400a:	90                   	nop
8010400b:	90                   	nop
8010400c:	90                   	nop
8010400d:	90                   	nop
8010400e:	90                   	nop
8010400f:	90                   	nop

80104010 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 14             	sub    $0x14,%esp
80104017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010401a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104021:	e8 3a 03 00 00       	call   80104360 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104026:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010402b:	eb 0f                	jmp    8010403c <kill+0x2c>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
80104030:	05 a0 00 00 00       	add    $0xa0,%eax
80104035:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010403a:	74 3c                	je     80104078 <kill+0x68>
    if(p->pid == pid){
8010403c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010403f:	75 ef                	jne    80104030 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104041:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104045:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010404c:	74 1a                	je     80104068 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010404e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104055:	e8 f6 03 00 00       	call   80104450 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010405a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
8010405d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010405f:	5b                   	pop    %ebx
80104060:	5d                   	pop    %ebp
80104061:	c3                   	ret    
80104062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104068:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010406f:	eb dd                	jmp    8010404e <kill+0x3e>
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104078:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010407f:	e8 cc 03 00 00       	call   80104450 <release>
  return -1;
}
80104084:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80104087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010408c:	5b                   	pop    %ebx
8010408d:	5d                   	pop    %ebp
8010408e:	c3                   	ret    
8010408f:	90                   	nop

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010409b:	83 ec 4c             	sub    $0x4c,%esp
8010409e:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040a1:	eb 23                	jmp    801040c6 <procdump+0x36>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	c7 04 24 48 79 10 80 	movl   $0x80107948,(%esp)
801040af:	e8 9c c5 ff ff       	call   80100650 <cprintf>
801040b4:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ba:	81 fb c0 65 11 80    	cmp    $0x801165c0,%ebx
801040c0:	0f 84 8a 00 00 00    	je     80104150 <procdump+0xc0>
    if(p->state == UNUSED)
801040c6:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040c9:	85 c0                	test   %eax,%eax
801040cb:	74 e7                	je     801040b4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040cd:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040d0:	ba e0 7e 10 80       	mov    $0x80107ee0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d5:	77 11                	ja     801040e8 <procdump+0x58>
801040d7:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040de:	b8 e0 7e 10 80       	mov    $0x80107ee0,%eax
801040e3:	85 d2                	test   %edx,%edx
801040e5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040e8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801040eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801040ef:	89 54 24 08          	mov    %edx,0x8(%esp)
801040f3:	c7 04 24 e4 7e 10 80 	movl   $0x80107ee4,(%esp)
801040fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801040fe:	e8 4d c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104103:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104107:	75 9f                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104109:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010410c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104110:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104113:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104116:	8b 40 0c             	mov    0xc(%eax),%eax
80104119:	83 c0 08             	add    $0x8,%eax
8010411c:	89 04 24             	mov    %eax,(%esp)
8010411f:	e8 6c 01 00 00       	call   80104290 <getcallerpcs>
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104128:	8b 17                	mov    (%edi),%edx
8010412a:	85 d2                	test   %edx,%edx
8010412c:	0f 84 76 ff ff ff    	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104132:	89 54 24 04          	mov    %edx,0x4(%esp)
80104136:	83 c7 04             	add    $0x4,%edi
80104139:	c7 04 24 e1 78 10 80 	movl   $0x801078e1,(%esp)
80104140:	e8 0b c5 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104145:	39 f7                	cmp    %esi,%edi
80104147:	75 df                	jne    80104128 <procdump+0x98>
80104149:	e9 5a ff ff ff       	jmp    801040a8 <procdump+0x18>
8010414e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104150:	83 c4 4c             	add    $0x4c,%esp
80104153:	5b                   	pop    %ebx
80104154:	5e                   	pop    %esi
80104155:	5f                   	pop    %edi
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
80104158:	66 90                	xchg   %ax,%ax
8010415a:	66 90                	xchg   %ax,%ax
8010415c:	66 90                	xchg   %ax,%ax
8010415e:	66 90                	xchg   %ax,%ax

80104160 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010416a:	c7 44 24 04 58 7f 10 	movl   $0x80107f58,0x4(%esp)
80104171:	80 
80104172:	8d 43 04             	lea    0x4(%ebx),%eax
80104175:	89 04 24             	mov    %eax,(%esp)
80104178:	e8 f3 00 00 00       	call   80104270 <initlock>
  lk->name = name;
8010417d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104180:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104186:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010418d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104190:	83 c4 14             	add    $0x14,%esp
80104193:	5b                   	pop    %ebx
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
80104196:	8d 76 00             	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	83 ec 10             	sub    $0x10,%esp
801041a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041ab:	8d 73 04             	lea    0x4(%ebx),%esi
801041ae:	89 34 24             	mov    %esi,(%esp)
801041b1:	e8 aa 01 00 00       	call   80104360 <acquire>
  while (lk->locked) {
801041b6:	8b 13                	mov    (%ebx),%edx
801041b8:	85 d2                	test   %edx,%edx
801041ba:	74 16                	je     801041d2 <acquiresleep+0x32>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801041c0:	89 74 24 04          	mov    %esi,0x4(%esp)
801041c4:	89 1c 24             	mov    %ebx,(%esp)
801041c7:	e8 34 fc ff ff       	call   80103e00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041cc:	8b 03                	mov    (%ebx),%eax
801041ce:	85 c0                	test   %eax,%eax
801041d0:	75 ee                	jne    801041c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041d2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041d8:	e8 83 f5 ff ff       	call   80103760 <myproc>
801041dd:	8b 40 10             	mov    0x10(%eax),%eax
801041e0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041e3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041e6:	83 c4 10             	add    $0x10,%esp
801041e9:	5b                   	pop    %ebx
801041ea:	5e                   	pop    %esi
801041eb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801041ec:	e9 5f 02 00 00       	jmp    80104450 <release>
801041f1:	eb 0d                	jmp    80104200 <releasesleep>
801041f3:	90                   	nop
801041f4:	90                   	nop
801041f5:	90                   	nop
801041f6:	90                   	nop
801041f7:	90                   	nop
801041f8:	90                   	nop
801041f9:	90                   	nop
801041fa:	90                   	nop
801041fb:	90                   	nop
801041fc:	90                   	nop
801041fd:	90                   	nop
801041fe:	90                   	nop
801041ff:	90                   	nop

80104200 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	56                   	push   %esi
80104204:	53                   	push   %ebx
80104205:	83 ec 10             	sub    $0x10,%esp
80104208:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010420b:	8d 73 04             	lea    0x4(%ebx),%esi
8010420e:	89 34 24             	mov    %esi,(%esp)
80104211:	e8 4a 01 00 00       	call   80104360 <acquire>
  lk->locked = 0;
80104216:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010421c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104223:	89 1c 24             	mov    %ebx,(%esp)
80104226:	e8 75 fd ff ff       	call   80103fa0 <wakeup>
  release(&lk->lk);
8010422b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010422e:	83 c4 10             	add    $0x10,%esp
80104231:	5b                   	pop    %ebx
80104232:	5e                   	pop    %esi
80104233:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104234:	e9 17 02 00 00       	jmp    80104450 <release>
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104240 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	83 ec 10             	sub    $0x10,%esp
80104248:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010424b:	8d 73 04             	lea    0x4(%ebx),%esi
8010424e:	89 34 24             	mov    %esi,(%esp)
80104251:	e8 0a 01 00 00       	call   80104360 <acquire>
  r = lk->locked;
80104256:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104258:	89 34 24             	mov    %esi,(%esp)
8010425b:	e8 f0 01 00 00       	call   80104450 <release>
  return r;
}
80104260:	83 c4 10             	add    $0x10,%esp
80104263:	89 d8                	mov    %ebx,%eax
80104265:	5b                   	pop    %ebx
80104266:	5e                   	pop    %esi
80104267:	5d                   	pop    %ebp
80104268:	c3                   	ret    
80104269:	66 90                	xchg   %ax,%ax
8010426b:	66 90                	xchg   %ax,%ax
8010426d:	66 90                	xchg   %ax,%ax
8010426f:	90                   	nop

80104270 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104276:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010427f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104282:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104289:	5d                   	pop    %ebp
8010428a:	c3                   	ret    
8010428b:	90                   	nop
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104293:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104299:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010429a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010429d:	31 c0                	xor    %eax,%eax
8010429f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042ac:	77 1a                	ja     801042c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801042b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042b9:	83 f8 0a             	cmp    $0xa,%eax
801042bc:	75 e2                	jne    801042a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042be:	5b                   	pop    %ebx
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042cf:	83 c0 01             	add    $0x1,%eax
801042d2:	83 f8 0a             	cmp    $0xa,%eax
801042d5:	74 e7                	je     801042be <getcallerpcs+0x2e>
    pcs[i] = 0;
801042d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042de:	83 c0 01             	add    $0x1,%eax
801042e1:	83 f8 0a             	cmp    $0xa,%eax
801042e4:	75 e2                	jne    801042c8 <getcallerpcs+0x38>
801042e6:	eb d6                	jmp    801042be <getcallerpcs+0x2e>
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042f0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801042f1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042f3:	89 e5                	mov    %esp,%ebp
801042f5:	53                   	push   %ebx
801042f6:	83 ec 04             	sub    $0x4,%esp
801042f9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042fc:	8b 0a                	mov    (%edx),%ecx
801042fe:	85 c9                	test   %ecx,%ecx
80104300:	74 10                	je     80104312 <holding+0x22>
80104302:	8b 5a 08             	mov    0x8(%edx),%ebx
80104305:	e8 b6 f3 ff ff       	call   801036c0 <mycpu>
8010430a:	39 c3                	cmp    %eax,%ebx
8010430c:	0f 94 c0             	sete   %al
8010430f:	0f b6 c0             	movzbl %al,%eax
}
80104312:	83 c4 04             	add    $0x4,%esp
80104315:	5b                   	pop    %ebx
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	90                   	nop
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104320 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 04             	sub    $0x4,%esp
80104327:	9c                   	pushf  
80104328:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104329:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010432a:	e8 91 f3 ff ff       	call   801036c0 <mycpu>
8010432f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104335:	85 c0                	test   %eax,%eax
80104337:	75 11                	jne    8010434a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104339:	e8 82 f3 ff ff       	call   801036c0 <mycpu>
8010433e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104344:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010434a:	e8 71 f3 ff ff       	call   801036c0 <mycpu>
8010434f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104356:	83 c4 04             	add    $0x4,%esp
80104359:	5b                   	pop    %ebx
8010435a:	5d                   	pop    %ebp
8010435b:	c3                   	ret    
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104360 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104367:	e8 b4 ff ff ff       	call   80104320 <pushcli>
  if(holding(lk))
8010436c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010436f:	8b 02                	mov    (%edx),%eax
80104371:	85 c0                	test   %eax,%eax
80104373:	75 43                	jne    801043b8 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104375:	b9 01 00 00 00       	mov    $0x1,%ecx
8010437a:	eb 07                	jmp    80104383 <acquire+0x23>
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104380:	8b 55 08             	mov    0x8(%ebp),%edx
80104383:	89 c8                	mov    %ecx,%eax
80104385:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104388:	85 c0                	test   %eax,%eax
8010438a:	75 f4                	jne    80104380 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010438c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104391:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104394:	e8 27 f3 ff ff       	call   801036c0 <mycpu>
80104399:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010439c:	8b 45 08             	mov    0x8(%ebp),%eax
8010439f:	83 c0 0c             	add    $0xc,%eax
801043a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801043a6:	8d 45 08             	lea    0x8(%ebp),%eax
801043a9:	89 04 24             	mov    %eax,(%esp)
801043ac:	e8 df fe ff ff       	call   80104290 <getcallerpcs>
}
801043b1:	83 c4 14             	add    $0x14,%esp
801043b4:	5b                   	pop    %ebx
801043b5:	5d                   	pop    %ebp
801043b6:	c3                   	ret    
801043b7:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043b8:	8b 5a 08             	mov    0x8(%edx),%ebx
801043bb:	e8 00 f3 ff ff       	call   801036c0 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801043c0:	39 c3                	cmp    %eax,%ebx
801043c2:	74 05                	je     801043c9 <acquire+0x69>
801043c4:	8b 55 08             	mov    0x8(%ebp),%edx
801043c7:	eb ac                	jmp    80104375 <acquire+0x15>
    panic("acquire");
801043c9:	c7 04 24 63 7f 10 80 	movl   $0x80107f63,(%esp)
801043d0:	e8 8b bf ff ff       	call   80100360 <panic>
801043d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e6:	9c                   	pushf  
801043e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043e8:	f6 c4 02             	test   $0x2,%ah
801043eb:	75 49                	jne    80104436 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801043ed:	e8 ce f2 ff ff       	call   801036c0 <mycpu>
801043f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801043f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801043fb:	85 d2                	test   %edx,%edx
801043fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104403:	78 25                	js     8010442a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104405:	e8 b6 f2 ff ff       	call   801036c0 <mycpu>
8010440a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104410:	85 d2                	test   %edx,%edx
80104412:	74 04                	je     80104418 <popcli+0x38>
    sti();
}
80104414:	c9                   	leave  
80104415:	c3                   	ret    
80104416:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104418:	e8 a3 f2 ff ff       	call   801036c0 <mycpu>
8010441d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104423:	85 c0                	test   %eax,%eax
80104425:	74 ed                	je     80104414 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104427:	fb                   	sti    
    sti();
}
80104428:	c9                   	leave  
80104429:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010442a:	c7 04 24 82 7f 10 80 	movl   $0x80107f82,(%esp)
80104431:	e8 2a bf ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104436:	c7 04 24 6b 7f 10 80 	movl   $0x80107f6b,(%esp)
8010443d:	e8 1e bf ff ff       	call   80100360 <panic>
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	83 ec 10             	sub    $0x10,%esp
80104458:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010445b:	8b 03                	mov    (%ebx),%eax
8010445d:	85 c0                	test   %eax,%eax
8010445f:	75 0f                	jne    80104470 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104461:	c7 04 24 89 7f 10 80 	movl   $0x80107f89,(%esp)
80104468:	e8 f3 be ff ff       	call   80100360 <panic>
8010446d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104470:	8b 73 08             	mov    0x8(%ebx),%esi
80104473:	e8 48 f2 ff ff       	call   801036c0 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104478:	39 c6                	cmp    %eax,%esi
8010447a:	75 e5                	jne    80104461 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010447c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104483:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010448a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010448f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104495:	83 c4 10             	add    $0x10,%esp
80104498:	5b                   	pop    %ebx
80104499:	5e                   	pop    %esi
8010449a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010449b:	e9 40 ff ff ff       	jmp    801043e0 <popcli>

801044a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 55 08             	mov    0x8(%ebp),%edx
801044a6:	57                   	push   %edi
801044a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801044ab:	f6 c2 03             	test   $0x3,%dl
801044ae:	75 05                	jne    801044b5 <memset+0x15>
801044b0:	f6 c1 03             	test   $0x3,%cl
801044b3:	74 13                	je     801044c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044b5:	89 d7                	mov    %edx,%edi
801044b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ba:	fc                   	cld    
801044bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044bd:	5b                   	pop    %ebx
801044be:	89 d0                	mov    %edx,%eax
801044c0:	5f                   	pop    %edi
801044c1:	5d                   	pop    %ebp
801044c2:	c3                   	ret    
801044c3:	90                   	nop
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044cc:	c1 e9 02             	shr    $0x2,%ecx
801044cf:	89 f8                	mov    %edi,%eax
801044d1:	89 fb                	mov    %edi,%ebx
801044d3:	c1 e0 18             	shl    $0x18,%eax
801044d6:	c1 e3 10             	shl    $0x10,%ebx
801044d9:	09 d8                	or     %ebx,%eax
801044db:	09 f8                	or     %edi,%eax
801044dd:	c1 e7 08             	shl    $0x8,%edi
801044e0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044e2:	89 d7                	mov    %edx,%edi
801044e4:	fc                   	cld    
801044e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801044e7:	5b                   	pop    %ebx
801044e8:	89 d0                	mov    %edx,%eax
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
801044ec:	c3                   	ret    
801044ed:	8d 76 00             	lea    0x0(%esi),%esi

801044f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	8b 45 10             	mov    0x10(%ebp),%eax
801044f6:	57                   	push   %edi
801044f7:	56                   	push   %esi
801044f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044fb:	53                   	push   %ebx
801044fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044ff:	85 c0                	test   %eax,%eax
80104501:	8d 78 ff             	lea    -0x1(%eax),%edi
80104504:	74 26                	je     8010452c <memcmp+0x3c>
    if(*s1 != *s2)
80104506:	0f b6 03             	movzbl (%ebx),%eax
80104509:	31 d2                	xor    %edx,%edx
8010450b:	0f b6 0e             	movzbl (%esi),%ecx
8010450e:	38 c8                	cmp    %cl,%al
80104510:	74 16                	je     80104528 <memcmp+0x38>
80104512:	eb 24                	jmp    80104538 <memcmp+0x48>
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104518:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010451d:	83 c2 01             	add    $0x1,%edx
80104520:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104524:	38 c8                	cmp    %cl,%al
80104526:	75 10                	jne    80104538 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104528:	39 fa                	cmp    %edi,%edx
8010452a:	75 ec                	jne    80104518 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010452c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010452d:	31 c0                	xor    %eax,%eax
}
8010452f:	5e                   	pop    %esi
80104530:	5f                   	pop    %edi
80104531:	5d                   	pop    %ebp
80104532:	c3                   	ret    
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104539:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010453b:	5e                   	pop    %esi
8010453c:	5f                   	pop    %edi
8010453d:	5d                   	pop    %ebp
8010453e:	c3                   	ret    
8010453f:	90                   	nop

80104540 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	8b 45 08             	mov    0x8(%ebp),%eax
80104547:	56                   	push   %esi
80104548:	8b 75 0c             	mov    0xc(%ebp),%esi
8010454b:	53                   	push   %ebx
8010454c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010454f:	39 c6                	cmp    %eax,%esi
80104551:	73 35                	jae    80104588 <memmove+0x48>
80104553:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104556:	39 c8                	cmp    %ecx,%eax
80104558:	73 2e                	jae    80104588 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010455a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010455c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010455f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104562:	74 1b                	je     8010457f <memmove+0x3f>
80104564:	f7 db                	neg    %ebx
80104566:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104569:	01 fb                	add    %edi,%ebx
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104570:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104574:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104577:	83 ea 01             	sub    $0x1,%edx
8010457a:	83 fa ff             	cmp    $0xffffffff,%edx
8010457d:	75 f1                	jne    80104570 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010457f:	5b                   	pop    %ebx
80104580:	5e                   	pop    %esi
80104581:	5f                   	pop    %edi
80104582:	5d                   	pop    %ebp
80104583:	c3                   	ret    
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104588:	31 d2                	xor    %edx,%edx
8010458a:	85 db                	test   %ebx,%ebx
8010458c:	74 f1                	je     8010457f <memmove+0x3f>
8010458e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104590:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104594:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104597:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010459a:	39 da                	cmp    %ebx,%edx
8010459c:	75 f2                	jne    80104590 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010459e:	5b                   	pop    %ebx
8010459f:	5e                   	pop    %esi
801045a0:	5f                   	pop    %edi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045b3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045b4:	e9 87 ff ff ff       	jmp    80104540 <memmove>
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	8b 75 10             	mov    0x10(%ebp),%esi
801045c7:	53                   	push   %ebx
801045c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801045ce:	85 f6                	test   %esi,%esi
801045d0:	74 30                	je     80104602 <strncmp+0x42>
801045d2:	0f b6 01             	movzbl (%ecx),%eax
801045d5:	84 c0                	test   %al,%al
801045d7:	74 2f                	je     80104608 <strncmp+0x48>
801045d9:	0f b6 13             	movzbl (%ebx),%edx
801045dc:	38 d0                	cmp    %dl,%al
801045de:	75 46                	jne    80104626 <strncmp+0x66>
801045e0:	8d 51 01             	lea    0x1(%ecx),%edx
801045e3:	01 ce                	add    %ecx,%esi
801045e5:	eb 14                	jmp    801045fb <strncmp+0x3b>
801045e7:	90                   	nop
801045e8:	0f b6 02             	movzbl (%edx),%eax
801045eb:	84 c0                	test   %al,%al
801045ed:	74 31                	je     80104620 <strncmp+0x60>
801045ef:	0f b6 19             	movzbl (%ecx),%ebx
801045f2:	83 c2 01             	add    $0x1,%edx
801045f5:	38 d8                	cmp    %bl,%al
801045f7:	75 17                	jne    80104610 <strncmp+0x50>
    n--, p++, q++;
801045f9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801045fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104600:	75 e6                	jne    801045e8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104602:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104603:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104605:	5e                   	pop    %esi
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret    
80104608:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010460b:	31 c0                	xor    %eax,%eax
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104610:	0f b6 d3             	movzbl %bl,%edx
80104613:	29 d0                	sub    %edx,%eax
}
80104615:	5b                   	pop    %ebx
80104616:	5e                   	pop    %esi
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104620:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104624:	eb ea                	jmp    80104610 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104626:	89 d3                	mov    %edx,%ebx
80104628:	eb e6                	jmp    80104610 <strncmp+0x50>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	8b 45 08             	mov    0x8(%ebp),%eax
80104636:	56                   	push   %esi
80104637:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010463a:	53                   	push   %ebx
8010463b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010463e:	89 c2                	mov    %eax,%edx
80104640:	eb 19                	jmp    8010465b <strncpy+0x2b>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104648:	83 c3 01             	add    $0x1,%ebx
8010464b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010464f:	83 c2 01             	add    $0x1,%edx
80104652:	84 c9                	test   %cl,%cl
80104654:	88 4a ff             	mov    %cl,-0x1(%edx)
80104657:	74 09                	je     80104662 <strncpy+0x32>
80104659:	89 f1                	mov    %esi,%ecx
8010465b:	85 c9                	test   %ecx,%ecx
8010465d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104660:	7f e6                	jg     80104648 <strncpy+0x18>
    ;
  while(n-- > 0)
80104662:	31 c9                	xor    %ecx,%ecx
80104664:	85 f6                	test   %esi,%esi
80104666:	7e 0f                	jle    80104677 <strncpy+0x47>
    *s++ = 0;
80104668:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010466c:	89 f3                	mov    %esi,%ebx
8010466e:	83 c1 01             	add    $0x1,%ecx
80104671:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104673:	85 db                	test   %ebx,%ebx
80104675:	7f f1                	jg     80104668 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104677:	5b                   	pop    %ebx
80104678:	5e                   	pop    %esi
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104686:	56                   	push   %esi
80104687:	8b 45 08             	mov    0x8(%ebp),%eax
8010468a:	53                   	push   %ebx
8010468b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010468e:	85 c9                	test   %ecx,%ecx
80104690:	7e 26                	jle    801046b8 <safestrcpy+0x38>
80104692:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104696:	89 c1                	mov    %eax,%ecx
80104698:	eb 17                	jmp    801046b1 <safestrcpy+0x31>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046a0:	83 c2 01             	add    $0x1,%edx
801046a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046a7:	83 c1 01             	add    $0x1,%ecx
801046aa:	84 db                	test   %bl,%bl
801046ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046af:	74 04                	je     801046b5 <safestrcpy+0x35>
801046b1:	39 f2                	cmp    %esi,%edx
801046b3:	75 eb                	jne    801046a0 <safestrcpy+0x20>
    ;
  *s = 0;
801046b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046b8:	5b                   	pop    %ebx
801046b9:	5e                   	pop    %esi
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <strlen>:

int
strlen(const char *s)
{
801046c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046c3:	89 e5                	mov    %esp,%ebp
801046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046c8:	80 3a 00             	cmpb   $0x0,(%edx)
801046cb:	74 0c                	je     801046d9 <strlen+0x19>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
801046d0:	83 c0 01             	add    $0x1,%eax
801046d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046d7:	75 f7                	jne    801046d0 <strlen+0x10>
    ;
  return n;
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    

801046db <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801046e3:	55                   	push   %ebp
  pushl %ebx
801046e4:	53                   	push   %ebx
  pushl %esi
801046e5:	56                   	push   %esi
  pushl %edi
801046e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801046eb:	5f                   	pop    %edi
  popl %esi
801046ec:	5e                   	pop    %esi
  popl %ebx
801046ed:	5b                   	pop    %ebx
  popl %ebp
801046ee:	5d                   	pop    %ebp
  ret
801046ef:	c3                   	ret    

801046f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
801046fa:	e8 61 f0 ff ff       	call   80103760 <myproc>
  if( ((addr >= curproc->sz)&&(addr < curproc->tstack)) || ((addr+4 > curproc->sz)&&(addr+4 < curproc->tstack))|| addr==0)
801046ff:	8b 10                	mov    (%eax),%edx
80104701:	39 da                	cmp    %ebx,%edx
80104703:	77 05                	ja     8010470a <fetchint+0x1a>
80104705:	3b 58 7c             	cmp    0x7c(%eax),%ebx
80104708:	72 23                	jb     8010472d <fetchint+0x3d>
8010470a:	8d 4b 04             	lea    0x4(%ebx),%ecx
8010470d:	39 ca                	cmp    %ecx,%edx
8010470f:	72 17                	jb     80104728 <fetchint+0x38>
80104711:	85 db                	test   %ebx,%ebx
80104713:	74 18                	je     8010472d <fetchint+0x3d>
    return -1;
  *ip = *(int*)(addr);
80104715:	8b 45 0c             	mov    0xc(%ebp),%eax
80104718:	8b 13                	mov    (%ebx),%edx
8010471a:	89 10                	mov    %edx,(%eax)
  return 0;
8010471c:	31 c0                	xor    %eax,%eax
}
8010471e:	83 c4 04             	add    $0x4,%esp
80104721:	5b                   	pop    %ebx
80104722:	5d                   	pop    %ebp
80104723:	c3                   	ret    
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
	struct proc *curproc = myproc();
  if( ((addr >= curproc->sz)&&(addr < curproc->tstack)) || ((addr+4 > curproc->sz)&&(addr+4 < curproc->tstack))|| addr==0)
80104728:	3b 48 7c             	cmp    0x7c(%eax),%ecx
8010472b:	73 e4                	jae    80104711 <fetchint+0x21>
    return -1;
8010472d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104732:	eb ea                	jmp    8010471e <fetchint+0x2e>
80104734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010473a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104740 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010474a:	e8 11 f0 ff ff       	call   80103760 <myproc>
  if(((addr >= curproc->sz) && (addr < curproc->tstack)) || addr==0)
8010474f:	39 18                	cmp    %ebx,(%eax)
80104751:	77 05                	ja     80104758 <fetchstr+0x18>
80104753:	3b 58 7c             	cmp    0x7c(%eax),%ebx
80104756:	72 34                	jb     8010478c <fetchstr+0x4c>
80104758:	85 db                	test   %ebx,%ebx
8010475a:	74 30                	je     8010478c <fetchstr+0x4c>
    return -1;
  *pp = (char*)addr;
8010475c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010475f:	89 da                	mov    %ebx,%edx
80104761:	89 19                	mov    %ebx,(%ecx)
  if (addr < curproc->sz) 
80104763:	8b 08                	mov    (%eax),%ecx
    ep = (char*)curproc->sz;
80104765:	b8 00 f0 ff 7f       	mov    $0x7ffff000,%eax
8010476a:	39 cb                	cmp    %ecx,%ebx
8010476c:	0f 42 c1             	cmovb  %ecx,%eax
  else
    ep = (char*)(USEREND-PGSIZE);
  for(s = *pp; s < ep; s++){
8010476f:	39 d8                	cmp    %ebx,%eax
80104771:	76 19                	jbe    8010478c <fetchstr+0x4c>
    if(*s == 0)
80104773:	80 3b 00             	cmpb   $0x0,(%ebx)
80104776:	75 0d                	jne    80104785 <fetchstr+0x45>
80104778:	eb 1e                	jmp    80104798 <fetchstr+0x58>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104780:	80 3a 00             	cmpb   $0x0,(%edx)
80104783:	74 13                	je     80104798 <fetchstr+0x58>
  *pp = (char*)addr;
  if (addr < curproc->sz) 
    ep = (char*)curproc->sz;
  else
    ep = (char*)(USEREND-PGSIZE);
  for(s = *pp; s < ep; s++){
80104785:	83 c2 01             	add    $0x1,%edx
80104788:	39 d0                	cmp    %edx,%eax
8010478a:	77 f4                	ja     80104780 <fetchstr+0x40>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010478c:	83 c4 04             	add    $0x4,%esp
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
  if(((addr >= curproc->sz) && (addr < curproc->tstack)) || addr==0)
    return -1;
8010478f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104794:	5b                   	pop    %ebx
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	90                   	nop
80104798:	83 c4 04             	add    $0x4,%esp
    ep = (char*)curproc->sz;
  else
    ep = (char*)(USEREND-PGSIZE);
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
8010479b:	89 d0                	mov    %edx,%eax
8010479d:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
8010479f:	5b                   	pop    %ebx
801047a0:	5d                   	pop    %ebp
801047a1:	c3                   	ret    
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	8b 75 0c             	mov    0xc(%ebp),%esi
801047b7:	53                   	push   %ebx
801047b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047bb:	e8 a0 ef ff ff       	call   80103760 <myproc>
801047c0:	89 75 0c             	mov    %esi,0xc(%ebp)
801047c3:	8b 40 18             	mov    0x18(%eax),%eax
801047c6:	8b 40 44             	mov    0x44(%eax),%eax
801047c9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801047cd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801047d0:	5b                   	pop    %ebx
801047d1:	5e                   	pop    %esi
801047d2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047d3:	e9 18 ff ff ff       	jmp    801046f0 <fetchint>
801047d8:	90                   	nop
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	83 ec 20             	sub    $0x20,%esp
801047e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047eb:	e8 70 ef ff ff       	call   80103760 <myproc>
  if(size < 0 || argint(n, &i) < 0)
801047f0:	85 db                	test   %ebx,%ebx
801047f2:	78 4c                	js     80104840 <argptr+0x60>
801047f4:	89 c6                	mov    %eax,%esi
801047f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801047fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104800:	89 04 24             	mov    %eax,(%esp)
80104803:	e8 a8 ff ff ff       	call   801047b0 <argint>
80104808:	85 c0                	test   %eax,%eax
8010480a:	78 34                	js     80104840 <argptr+0x60>
    return -1;
  if((((uint)i >= curproc->sz)&&((uint)i < curproc->tstack)) || (((uint)i+size > curproc->sz)&&((uint)i+size < curproc->tstack)) ||
8010480c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010480f:	8b 06                	mov    (%esi),%eax
80104811:	39 c2                	cmp    %eax,%edx
80104813:	72 05                	jb     8010481a <argptr+0x3a>
80104815:	3b 56 7c             	cmp    0x7c(%esi),%edx
80104818:	72 26                	jb     80104840 <argptr+0x60>
8010481a:	01 d3                	add    %edx,%ebx
8010481c:	39 d8                	cmp    %ebx,%eax
8010481e:	72 18                	jb     80104838 <argptr+0x58>
80104820:	85 d2                	test   %edx,%edx
80104822:	74 1c                	je     80104840 <argptr+0x60>
     (uint)i == 0)
    return -1;
  *pp = (char*)i;
80104824:	8b 45 0c             	mov    0xc(%ebp),%eax
80104827:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104829:	83 c4 20             	add    $0x20,%esp
    return -1;
  if((((uint)i >= curproc->sz)&&((uint)i < curproc->tstack)) || (((uint)i+size > curproc->sz)&&((uint)i+size < curproc->tstack)) ||
     (uint)i == 0)
    return -1;
  *pp = (char*)i;
  return 0;
8010482c:	31 c0                	xor    %eax,%eax
}
8010482e:	5b                   	pop    %ebx
8010482f:	5e                   	pop    %esi
80104830:	5d                   	pop    %ebp
80104831:	c3                   	ret    
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
  if((((uint)i >= curproc->sz)&&((uint)i < curproc->tstack)) || (((uint)i+size > curproc->sz)&&((uint)i+size < curproc->tstack)) ||
80104838:	3b 5e 7c             	cmp    0x7c(%esi),%ebx
8010483b:	73 e3                	jae    80104820 <argptr+0x40>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
     (uint)i == 0)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104840:	83 c4 20             	add    $0x20,%esp
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
80104843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((((uint)i >= curproc->sz)&&((uint)i < curproc->tstack)) || (((uint)i+size > curproc->sz)&&((uint)i+size < curproc->tstack)) ||
     (uint)i == 0)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104848:	5b                   	pop    %ebx
80104849:	5e                   	pop    %esi
8010484a:	5d                   	pop    %ebp
8010484b:	c3                   	ret    
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104856:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104859:	89 44 24 04          	mov    %eax,0x4(%esp)
8010485d:	8b 45 08             	mov    0x8(%ebp),%eax
80104860:	89 04 24             	mov    %eax,(%esp)
80104863:	e8 48 ff ff ff       	call   801047b0 <argint>
80104868:	85 c0                	test   %eax,%eax
8010486a:	78 14                	js     80104880 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010486c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104876:	89 04 24             	mov    %eax,(%esp)
80104879:	e8 c2 fe ff ff       	call   80104740 <fetchstr>
}
8010487e:	c9                   	leave  
8010487f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104885:	c9                   	leave  
80104886:	c3                   	ret    
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104898:	e8 c3 ee ff ff       	call   80103760 <myproc>

  num = curproc->tf->eax;
8010489d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801048a0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048a2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048a5:	8d 50 ff             	lea    -0x1(%eax),%edx
801048a8:	83 fa 16             	cmp    $0x16,%edx
801048ab:	77 1b                	ja     801048c8 <syscall+0x38>
801048ad:	8b 14 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%edx
801048b4:	85 d2                	test   %edx,%edx
801048b6:	74 10                	je     801048c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048b8:	ff d2                	call   *%edx
801048ba:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048bd:	83 c4 10             	add    $0x10,%esp
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5d                   	pop    %ebp
801048c3:	c3                   	ret    
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801048cc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048cf:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048d3:	8b 43 10             	mov    0x10(%ebx),%eax
801048d6:	c7 04 24 91 7f 10 80 	movl   $0x80107f91,(%esp)
801048dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e1:	e8 6a bd ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801048e6:	8b 43 18             	mov    0x18(%ebx),%eax
801048e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5d                   	pop    %ebp
801048f6:	c3                   	ret    
801048f7:	66 90                	xchg   %ax,%ax
801048f9:	66 90                	xchg   %ax,%ax
801048fb:	66 90                	xchg   %ax,%ax
801048fd:	66 90                	xchg   %ax,%ax
801048ff:	90                   	nop

80104900 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	89 c3                	mov    %eax,%ebx
80104906:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104909:	e8 52 ee ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010490e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104910:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104914:	85 c9                	test   %ecx,%ecx
80104916:	74 18                	je     80104930 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104918:	83 c2 01             	add    $0x1,%edx
8010491b:	83 fa 10             	cmp    $0x10,%edx
8010491e:	75 f0                	jne    80104910 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104920:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104928:	5b                   	pop    %ebx
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	90                   	nop
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104930:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104934:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104937:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104939:	5b                   	pop    %ebx
8010493a:	5d                   	pop    %ebp
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
80104946:	83 ec 4c             	sub    $0x4c,%esp
80104949:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010494c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010494f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104952:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104956:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104959:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010495c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010495f:	e8 2c d6 ff ff       	call   80101f90 <nameiparent>
80104964:	85 c0                	test   %eax,%eax
80104966:	89 c7                	mov    %eax,%edi
80104968:	0f 84 da 00 00 00    	je     80104a48 <create+0x108>
    return 0;
  ilock(dp);
8010496e:	89 04 24             	mov    %eax,(%esp)
80104971:	e8 aa cd ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104976:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104979:	89 44 24 08          	mov    %eax,0x8(%esp)
8010497d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104981:	89 3c 24             	mov    %edi,(%esp)
80104984:	e8 a7 d2 ff ff       	call   80101c30 <dirlookup>
80104989:	85 c0                	test   %eax,%eax
8010498b:	89 c6                	mov    %eax,%esi
8010498d:	74 41                	je     801049d0 <create+0x90>
    iunlockput(dp);
8010498f:	89 3c 24             	mov    %edi,(%esp)
80104992:	e8 e9 cf ff ff       	call   80101980 <iunlockput>
    ilock(ip);
80104997:	89 34 24             	mov    %esi,(%esp)
8010499a:	e8 81 cd ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010499f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049a4:	75 12                	jne    801049b8 <create+0x78>
801049a6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801049ab:	89 f0                	mov    %esi,%eax
801049ad:	75 09                	jne    801049b8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049af:	83 c4 4c             	add    $0x4c,%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5f                   	pop    %edi
801049b5:	5d                   	pop    %ebp
801049b6:	c3                   	ret    
801049b7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049b8:	89 34 24             	mov    %esi,(%esp)
801049bb:	e8 c0 cf ff ff       	call   80101980 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049c0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049c3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5f                   	pop    %edi
801049c8:	5d                   	pop    %ebp
801049c9:	c3                   	ret    
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049d0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d8:	8b 07                	mov    (%edi),%eax
801049da:	89 04 24             	mov    %eax,(%esp)
801049dd:	e8 ae cb ff ff       	call   80101590 <ialloc>
801049e2:	85 c0                	test   %eax,%eax
801049e4:	89 c6                	mov    %eax,%esi
801049e6:	0f 84 bf 00 00 00    	je     80104aab <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801049ec:	89 04 24             	mov    %eax,(%esp)
801049ef:	e8 2c cd ff ff       	call   80101720 <ilock>
  ip->major = major;
801049f4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049f8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801049fc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a00:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104a04:	b8 01 00 00 00       	mov    $0x1,%eax
80104a09:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104a0d:	89 34 24             	mov    %esi,(%esp)
80104a10:	e8 4b cc ff ff       	call   80101660 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a15:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a1a:	74 34                	je     80104a50 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a1c:	8b 46 04             	mov    0x4(%esi),%eax
80104a1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104a23:	89 3c 24             	mov    %edi,(%esp)
80104a26:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a2a:	e8 61 d4 ff ff       	call   80101e90 <dirlink>
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	78 6c                	js     80104a9f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104a33:	89 3c 24             	mov    %edi,(%esp)
80104a36:	e8 45 cf ff ff       	call   80101980 <iunlockput>

  return ip;
}
80104a3b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a3e:	89 f0                	mov    %esi,%eax
}
80104a40:	5b                   	pop    %ebx
80104a41:	5e                   	pop    %esi
80104a42:	5f                   	pop    %edi
80104a43:	5d                   	pop    %ebp
80104a44:	c3                   	ret    
80104a45:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a48:	31 c0                	xor    %eax,%eax
80104a4a:	e9 60 ff ff ff       	jmp    801049af <create+0x6f>
80104a4f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a55:	89 3c 24             	mov    %edi,(%esp)
80104a58:	e8 03 cc ff ff       	call   80101660 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a5d:	8b 46 04             	mov    0x4(%esi),%eax
80104a60:	c7 44 24 04 3c 80 10 	movl   $0x8010803c,0x4(%esp)
80104a67:	80 
80104a68:	89 34 24             	mov    %esi,(%esp)
80104a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a6f:	e8 1c d4 ff ff       	call   80101e90 <dirlink>
80104a74:	85 c0                	test   %eax,%eax
80104a76:	78 1b                	js     80104a93 <create+0x153>
80104a78:	8b 47 04             	mov    0x4(%edi),%eax
80104a7b:	c7 44 24 04 3b 80 10 	movl   $0x8010803b,0x4(%esp)
80104a82:	80 
80104a83:	89 34 24             	mov    %esi,(%esp)
80104a86:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a8a:	e8 01 d4 ff ff       	call   80101e90 <dirlink>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	79 89                	jns    80104a1c <create+0xdc>
      panic("create dots");
80104a93:	c7 04 24 2f 80 10 80 	movl   $0x8010802f,(%esp)
80104a9a:	e8 c1 b8 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a9f:	c7 04 24 3e 80 10 80 	movl   $0x8010803e,(%esp)
80104aa6:	e8 b5 b8 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104aab:	c7 04 24 20 80 10 80 	movl   $0x80108020,(%esp)
80104ab2:	e8 a9 b8 ff ff       	call   80100360 <panic>
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	89 c6                	mov    %eax,%esi
80104ac6:	53                   	push   %ebx
80104ac7:	89 d3                	mov    %edx,%ebx
80104ac9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104acf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ada:	e8 d1 fc ff ff       	call   801047b0 <argint>
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	78 2d                	js     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ae3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ae7:	77 27                	ja     80104b10 <argfd.constprop.0+0x50>
80104ae9:	e8 72 ec ff ff       	call   80103760 <myproc>
80104aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104af1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	74 17                	je     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104af9:	85 f6                	test   %esi,%esi
80104afb:	74 02                	je     80104aff <argfd.constprop.0+0x3f>
    *pfd = fd;
80104afd:	89 16                	mov    %edx,(%esi)
  if(pf)
80104aff:	85 db                	test   %ebx,%ebx
80104b01:	74 1d                	je     80104b20 <argfd.constprop.0+0x60>
    *pf = f;
80104b03:	89 03                	mov    %eax,(%ebx)
  return 0;
80104b05:	31 c0                	xor    %eax,%eax
}
80104b07:	83 c4 20             	add    $0x20,%esp
80104b0a:	5b                   	pop    %ebx
80104b0b:	5e                   	pop    %esi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret    
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b20:	31 c0                	xor    %eax,%eax
80104b22:	eb e3                	jmp    80104b07 <argfd.constprop.0+0x47>
80104b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b30 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	53                   	push   %ebx
80104b36:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b39:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b3c:	e8 7f ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 23                	js     80104b68 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b48:	e8 b3 fd ff ff       	call   80104900 <fdalloc>
80104b4d:	85 c0                	test   %eax,%eax
80104b4f:	89 c3                	mov    %eax,%ebx
80104b51:	78 15                	js     80104b68 <sys_dup+0x38>
    return -1;
  filedup(f);
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	89 04 24             	mov    %eax,(%esp)
80104b59:	e8 e2 c2 ff ff       	call   80100e40 <filedup>
  return fd;
80104b5e:	89 d8                	mov    %ebx,%eax
}
80104b60:	83 c4 24             	add    $0x24,%esp
80104b63:	5b                   	pop    %ebx
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b6d:	eb f1                	jmp    80104b60 <sys_dup+0x30>
80104b6f:	90                   	nop

80104b70 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104b70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b71:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b7b:	e8 40 ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 54                	js     80104bd8 <sys_read+0x68>
80104b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b8b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b92:	e8 19 fc ff ff       	call   801047b0 <argint>
80104b97:	85 c0                	test   %eax,%eax
80104b99:	78 3d                	js     80104bd8 <sys_read+0x68>
80104b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ba9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bb0:	e8 2b fc ff ff       	call   801047e0 <argptr>
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 1f                	js     80104bd8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bca:	89 04 24             	mov    %eax,(%esp)
80104bcd:	e8 ce c3 ff ff       	call   80100fa0 <fileread>
}
80104bd2:	c9                   	leave  
80104bd3:	c3                   	ret    
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104bdd:	c9                   	leave  
80104bde:	c3                   	ret    
80104bdf:	90                   	nop

80104be0 <sys_write>:

int
sys_write(void)
{
80104be0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 d0 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 54                	js     80104c48 <sys_write+0x68>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104c02:	e8 a9 fb ff ff       	call   801047b0 <argint>
80104c07:	85 c0                	test   %eax,%eax
80104c09:	78 3d                	js     80104c48 <sys_write+0x68>
80104c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c20:	e8 bb fb ff ff       	call   801047e0 <argptr>
80104c25:	85 c0                	test   %eax,%eax
80104c27:	78 1f                	js     80104c48 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3a:	89 04 24             	mov    %eax,(%esp)
80104c3d:	e8 fe c3 ff ff       	call   80101040 <filewrite>
}
80104c42:	c9                   	leave  
80104c43:	c3                   	ret    
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c4d:	c9                   	leave  
80104c4e:	c3                   	ret    
80104c4f:	90                   	nop

80104c50 <sys_close>:

int
sys_close(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5c:	e8 5f fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c61:	85 c0                	test   %eax,%eax
80104c63:	78 23                	js     80104c88 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104c65:	e8 f6 ea ff ff       	call   80103760 <myproc>
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c74:	00 
  fileclose(f);
80104c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c78:	89 04 24             	mov    %eax,(%esp)
80104c7b:	e8 10 c2 ff ff       	call   80100e90 <fileclose>
  return 0;
80104c80:	31 c0                	xor    %eax,%eax
}
80104c82:	c9                   	leave  
80104c83:	c3                   	ret    
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    
80104c8f:	90                   	nop

80104c90 <sys_fstat>:

int
sys_fstat(void)
{
80104c90:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c91:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c9b:	e8 20 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	78 34                	js     80104cd8 <sys_fstat+0x48>
80104ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104cae:	00 
80104caf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cba:	e8 21 fb ff ff       	call   801047e0 <argptr>
80104cbf:	85 c0                	test   %eax,%eax
80104cc1:	78 15                	js     80104cd8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ccd:	89 04 24             	mov    %eax,(%esp)
80104cd0:	e8 7b c2 ff ff       	call   80100f50 <filestat>
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104cdd:	c9                   	leave  
80104cde:	c3                   	ret    
80104cdf:	90                   	nop

80104ce0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ce9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cf7:	e8 54 fb ff ff       	call   80104850 <argstr>
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	0f 88 e6 00 00 00    	js     80104dea <sys_link+0x10a>
80104d04:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d12:	e8 39 fb ff ff       	call   80104850 <argstr>
80104d17:	85 c0                	test   %eax,%eax
80104d19:	0f 88 cb 00 00 00    	js     80104dea <sys_link+0x10a>
    return -1;

  begin_op();
80104d1f:	e8 5c de ff ff       	call   80102b80 <begin_op>
  if((ip = namei(old)) == 0){
80104d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104d27:	89 04 24             	mov    %eax,(%esp)
80104d2a:	e8 41 d2 ff ff       	call   80101f70 <namei>
80104d2f:	85 c0                	test   %eax,%eax
80104d31:	89 c3                	mov    %eax,%ebx
80104d33:	0f 84 ac 00 00 00    	je     80104de5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104d39:	89 04 24             	mov    %eax,(%esp)
80104d3c:	e8 df c9 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104d41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d46:	0f 84 91 00 00 00    	je     80104ddd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d4c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d51:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d54:	89 1c 24             	mov    %ebx,(%esp)
80104d57:	e8 04 c9 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104d5c:	89 1c 24             	mov    %ebx,(%esp)
80104d5f:	e8 9c ca ff ff       	call   80101800 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d64:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104d67:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d6b:	89 04 24             	mov    %eax,(%esp)
80104d6e:	e8 1d d2 ff ff       	call   80101f90 <nameiparent>
80104d73:	85 c0                	test   %eax,%eax
80104d75:	89 c6                	mov    %eax,%esi
80104d77:	74 4f                	je     80104dc8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104d79:	89 04 24             	mov    %eax,(%esp)
80104d7c:	e8 9f c9 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d81:	8b 03                	mov    (%ebx),%eax
80104d83:	39 06                	cmp    %eax,(%esi)
80104d85:	75 39                	jne    80104dc0 <sys_link+0xe0>
80104d87:	8b 43 04             	mov    0x4(%ebx),%eax
80104d8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d8e:	89 34 24             	mov    %esi,(%esp)
80104d91:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d95:	e8 f6 d0 ff ff       	call   80101e90 <dirlink>
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	78 22                	js     80104dc0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d9e:	89 34 24             	mov    %esi,(%esp)
80104da1:	e8 da cb ff ff       	call   80101980 <iunlockput>
  iput(ip);
80104da6:	89 1c 24             	mov    %ebx,(%esp)
80104da9:	e8 92 ca ff ff       	call   80101840 <iput>

  end_op();
80104dae:	e8 3d de ff ff       	call   80102bf0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104db3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104db6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104db8:	5b                   	pop    %ebx
80104db9:	5e                   	pop    %esi
80104dba:	5f                   	pop    %edi
80104dbb:	5d                   	pop    %ebp
80104dbc:	c3                   	ret    
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104dc0:	89 34 24             	mov    %esi,(%esp)
80104dc3:	e8 b8 cb ff ff       	call   80101980 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104dc8:	89 1c 24             	mov    %ebx,(%esp)
80104dcb:	e8 50 c9 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104dd0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104dd5:	89 1c 24             	mov    %ebx,(%esp)
80104dd8:	e8 83 c8 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104ddd:	89 1c 24             	mov    %ebx,(%esp)
80104de0:	e8 9b cb ff ff       	call   80101980 <iunlockput>
  end_op();
80104de5:	e8 06 de ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104dea:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
80104e06:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e09:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e17:	e8 34 fa ff ff       	call   80104850 <argstr>
80104e1c:	85 c0                	test   %eax,%eax
80104e1e:	0f 88 76 01 00 00    	js     80104f9a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104e24:	e8 57 dd ff ff       	call   80102b80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e29:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104e2c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104e2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e33:	89 04 24             	mov    %eax,(%esp)
80104e36:	e8 55 d1 ff ff       	call   80101f90 <nameiparent>
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e40:	0f 84 4f 01 00 00    	je     80104f95 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104e46:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e49:	89 34 24             	mov    %esi,(%esp)
80104e4c:	e8 cf c8 ff ff       	call   80101720 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e51:	c7 44 24 04 3c 80 10 	movl   $0x8010803c,0x4(%esp)
80104e58:	80 
80104e59:	89 1c 24             	mov    %ebx,(%esp)
80104e5c:	e8 9f cd ff ff       	call   80101c00 <namecmp>
80104e61:	85 c0                	test   %eax,%eax
80104e63:	0f 84 21 01 00 00    	je     80104f8a <sys_unlink+0x18a>
80104e69:	c7 44 24 04 3b 80 10 	movl   $0x8010803b,0x4(%esp)
80104e70:	80 
80104e71:	89 1c 24             	mov    %ebx,(%esp)
80104e74:	e8 87 cd ff ff       	call   80101c00 <namecmp>
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	0f 84 09 01 00 00    	je     80104f8a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e81:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e88:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e8c:	89 34 24             	mov    %esi,(%esp)
80104e8f:	e8 9c cd ff ff       	call   80101c30 <dirlookup>
80104e94:	85 c0                	test   %eax,%eax
80104e96:	89 c3                	mov    %eax,%ebx
80104e98:	0f 84 ec 00 00 00    	je     80104f8a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104e9e:	89 04 24             	mov    %eax,(%esp)
80104ea1:	e8 7a c8 ff ff       	call   80101720 <ilock>

  if(ip->nlink < 1)
80104ea6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104eab:	0f 8e 24 01 00 00    	jle    80104fd5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104eb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eb6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104eb9:	74 7d                	je     80104f38 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104ebb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ec2:	00 
80104ec3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104eca:	00 
80104ecb:	89 34 24             	mov    %esi,(%esp)
80104ece:	e8 cd f5 ff ff       	call   801044a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ed3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104ed6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104edd:	00 
80104ede:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ee6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ee9:	89 04 24             	mov    %eax,(%esp)
80104eec:	e8 df cb ff ff       	call   80101ad0 <writei>
80104ef1:	83 f8 10             	cmp    $0x10,%eax
80104ef4:	0f 85 cf 00 00 00    	jne    80104fc9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104efa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eff:	0f 84 a3 00 00 00    	je     80104fa8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f08:	89 04 24             	mov    %eax,(%esp)
80104f0b:	e8 70 ca ff ff       	call   80101980 <iunlockput>

  ip->nlink--;
80104f10:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f15:	89 1c 24             	mov    %ebx,(%esp)
80104f18:	e8 43 c7 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104f1d:	89 1c 24             	mov    %ebx,(%esp)
80104f20:	e8 5b ca ff ff       	call   80101980 <iunlockput>

  end_op();
80104f25:	e8 c6 dc ff ff       	call   80102bf0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f2a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104f2d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5f                   	pop    %edi
80104f32:	5d                   	pop    %ebp
80104f33:	c3                   	ret    
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f38:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f3c:	0f 86 79 ff ff ff    	jbe    80104ebb <sys_unlink+0xbb>
80104f42:	bf 20 00 00 00       	mov    $0x20,%edi
80104f47:	eb 15                	jmp    80104f5e <sys_unlink+0x15e>
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f50:	8d 57 10             	lea    0x10(%edi),%edx
80104f53:	3b 53 58             	cmp    0x58(%ebx),%edx
80104f56:	0f 83 5f ff ff ff    	jae    80104ebb <sys_unlink+0xbb>
80104f5c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f5e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104f65:	00 
80104f66:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104f6a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104f6e:	89 1c 24             	mov    %ebx,(%esp)
80104f71:	e8 5a ca ff ff       	call   801019d0 <readi>
80104f76:	83 f8 10             	cmp    $0x10,%eax
80104f79:	75 42                	jne    80104fbd <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f7b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f80:	74 ce                	je     80104f50 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f82:	89 1c 24             	mov    %ebx,(%esp)
80104f85:	e8 f6 c9 ff ff       	call   80101980 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f8a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f8d:	89 04 24             	mov    %eax,(%esp)
80104f90:	e8 eb c9 ff ff       	call   80101980 <iunlockput>
  end_op();
80104f95:	e8 56 dc ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104f9a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa2:	5b                   	pop    %ebx
80104fa3:	5e                   	pop    %esi
80104fa4:	5f                   	pop    %edi
80104fa5:	5d                   	pop    %ebp
80104fa6:	c3                   	ret    
80104fa7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fa8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104fab:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fb0:	89 04 24             	mov    %eax,(%esp)
80104fb3:	e8 a8 c6 ff ff       	call   80101660 <iupdate>
80104fb8:	e9 48 ff ff ff       	jmp    80104f05 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104fbd:	c7 04 24 60 80 10 80 	movl   $0x80108060,(%esp)
80104fc4:	e8 97 b3 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104fc9:	c7 04 24 72 80 10 80 	movl   $0x80108072,(%esp)
80104fd0:	e8 8b b3 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104fd5:	c7 04 24 4e 80 10 80 	movl   $0x8010804e,(%esp)
80104fdc:	e8 7f b3 ff ff       	call   80100360 <panic>
80104fe1:	eb 0d                	jmp    80104ff0 <sys_open>
80104fe3:	90                   	nop
80104fe4:	90                   	nop
80104fe5:	90                   	nop
80104fe6:	90                   	nop
80104fe7:	90                   	nop
80104fe8:	90                   	nop
80104fe9:	90                   	nop
80104fea:	90                   	nop
80104feb:	90                   	nop
80104fec:	90                   	nop
80104fed:	90                   	nop
80104fee:	90                   	nop
80104fef:	90                   	nop

80104ff0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ff9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105007:	e8 44 f8 ff ff       	call   80104850 <argstr>
8010500c:	85 c0                	test   %eax,%eax
8010500e:	0f 88 d1 00 00 00    	js     801050e5 <sys_open+0xf5>
80105014:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105017:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105022:	e8 89 f7 ff ff       	call   801047b0 <argint>
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 b6 00 00 00    	js     801050e5 <sys_open+0xf5>
    return -1;

  begin_op();
8010502f:	e8 4c db ff ff       	call   80102b80 <begin_op>

  if(omode & O_CREATE){
80105034:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105038:	0f 85 82 00 00 00    	jne    801050c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010503e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105041:	89 04 24             	mov    %eax,(%esp)
80105044:	e8 27 cf ff ff       	call   80101f70 <namei>
80105049:	85 c0                	test   %eax,%eax
8010504b:	89 c6                	mov    %eax,%esi
8010504d:	0f 84 8d 00 00 00    	je     801050e0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105053:	89 04 24             	mov    %eax,(%esp)
80105056:	e8 c5 c6 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010505b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105060:	0f 84 92 00 00 00    	je     801050f8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105066:	e8 65 bd ff ff       	call   80100dd0 <filealloc>
8010506b:	85 c0                	test   %eax,%eax
8010506d:	89 c3                	mov    %eax,%ebx
8010506f:	0f 84 93 00 00 00    	je     80105108 <sys_open+0x118>
80105075:	e8 86 f8 ff ff       	call   80104900 <fdalloc>
8010507a:	85 c0                	test   %eax,%eax
8010507c:	89 c7                	mov    %eax,%edi
8010507e:	0f 88 94 00 00 00    	js     80105118 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105084:	89 34 24             	mov    %esi,(%esp)
80105087:	e8 74 c7 ff ff       	call   80101800 <iunlock>
  end_op();
8010508c:	e8 5f db ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80105091:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010509a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010509d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801050a4:	89 c2                	mov    %eax,%edx
801050a6:	83 e2 01             	and    $0x1,%edx
801050a9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050ac:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801050ae:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
801050b1:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050b3:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801050b7:	83 c4 2c             	add    $0x2c,%esp
801050ba:	5b                   	pop    %ebx
801050bb:	5e                   	pop    %esi
801050bc:	5f                   	pop    %edi
801050bd:	5d                   	pop    %ebp
801050be:	c3                   	ret    
801050bf:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050c3:	31 c9                	xor    %ecx,%ecx
801050c5:	ba 02 00 00 00       	mov    $0x2,%edx
801050ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050d1:	e8 6a f8 ff ff       	call   80104940 <create>
    if(ip == 0){
801050d6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050d8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801050da:	75 8a                	jne    80105066 <sys_open+0x76>
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
801050e0:	e8 0b db ff ff       	call   80102bf0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050e5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5f                   	pop    %edi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	0f 84 63 ff ff ff    	je     80105066 <sys_open+0x76>
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80105108:	89 34 24             	mov    %esi,(%esp)
8010510b:	e8 70 c8 ff ff       	call   80101980 <iunlockput>
80105110:	eb ce                	jmp    801050e0 <sys_open+0xf0>
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105118:	89 1c 24             	mov    %ebx,(%esp)
8010511b:	e8 70 bd ff ff       	call   80100e90 <fileclose>
80105120:	eb e6                	jmp    80105108 <sys_open+0x118>
80105122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105136:	e8 45 da ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010513b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105149:	e8 02 f7 ff ff       	call   80104850 <argstr>
8010514e:	85 c0                	test   %eax,%eax
80105150:	78 2e                	js     80105180 <sys_mkdir+0x50>
80105152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105155:	31 c9                	xor    %ecx,%ecx
80105157:	ba 01 00 00 00       	mov    $0x1,%edx
8010515c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105163:	e8 d8 f7 ff ff       	call   80104940 <create>
80105168:	85 c0                	test   %eax,%eax
8010516a:	74 14                	je     80105180 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010516c:	89 04 24             	mov    %eax,(%esp)
8010516f:	e8 0c c8 ff ff       	call   80101980 <iunlockput>
  end_op();
80105174:	e8 77 da ff ff       	call   80102bf0 <end_op>
  return 0;
80105179:	31 c0                	xor    %eax,%eax
}
8010517b:	c9                   	leave  
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105180:	e8 6b da ff ff       	call   80102bf0 <end_op>
    return -1;
80105185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <sys_mknod>:

int
sys_mknod(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105196:	e8 e5 d9 ff ff       	call   80102b80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010519b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010519e:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051a9:	e8 a2 f6 ff ff       	call   80104850 <argstr>
801051ae:	85 c0                	test   %eax,%eax
801051b0:	78 5e                	js     80105210 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051c0:	e8 eb f5 ff ff       	call   801047b0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801051c5:	85 c0                	test   %eax,%eax
801051c7:	78 47                	js     80105210 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801051c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801051d7:	e8 d4 f5 ff ff       	call   801047b0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 30                	js     80105210 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801051e0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801051e4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801051e9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801051ed:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801051f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051f3:	e8 48 f7 ff ff       	call   80104940 <create>
801051f8:	85 c0                	test   %eax,%eax
801051fa:	74 14                	je     80105210 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801051fc:	89 04 24             	mov    %eax,(%esp)
801051ff:	e8 7c c7 ff ff       	call   80101980 <iunlockput>
  end_op();
80105204:	e8 e7 d9 ff ff       	call   80102bf0 <end_op>
  return 0;
80105209:	31 c0                	xor    %eax,%eax
}
8010520b:	c9                   	leave  
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105210:	e8 db d9 ff ff       	call   80102bf0 <end_op>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010521a:	c9                   	leave  
8010521b:	c3                   	ret    
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_chdir>:

int
sys_chdir(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
80105225:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105228:	e8 33 e5 ff ff       	call   80103760 <myproc>
8010522d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010522f:	e8 4c d9 ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105234:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105237:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105242:	e8 09 f6 ff ff       	call   80104850 <argstr>
80105247:	85 c0                	test   %eax,%eax
80105249:	78 4a                	js     80105295 <sys_chdir+0x75>
8010524b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524e:	89 04 24             	mov    %eax,(%esp)
80105251:	e8 1a cd ff ff       	call   80101f70 <namei>
80105256:	85 c0                	test   %eax,%eax
80105258:	89 c3                	mov    %eax,%ebx
8010525a:	74 39                	je     80105295 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010525c:	89 04 24             	mov    %eax,(%esp)
8010525f:	e8 bc c4 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
80105264:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105269:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010526c:	75 22                	jne    80105290 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010526e:	e8 8d c5 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
80105273:	8b 46 68             	mov    0x68(%esi),%eax
80105276:	89 04 24             	mov    %eax,(%esp)
80105279:	e8 c2 c5 ff ff       	call   80101840 <iput>
  end_op();
8010527e:	e8 6d d9 ff ff       	call   80102bf0 <end_op>
  curproc->cwd = ip;
  return 0;
80105283:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105285:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105288:	83 c4 20             	add    $0x20,%esp
8010528b:	5b                   	pop    %ebx
8010528c:	5e                   	pop    %esi
8010528d:	5d                   	pop    %ebp
8010528e:	c3                   	ret    
8010528f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105290:	e8 eb c6 ff ff       	call   80101980 <iunlockput>
    end_op();
80105295:	e8 56 d9 ff ff       	call   80102bf0 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010529a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010529d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5d                   	pop    %ebp
801052a5:	c3                   	ret    
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_exec>:

int
sys_exec(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
801052b6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801052bc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801052c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801052c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052cd:	e8 7e f5 ff ff       	call   80104850 <argstr>
801052d2:	85 c0                	test   %eax,%eax
801052d4:	0f 88 84 00 00 00    	js     8010535e <sys_exec+0xae>
801052da:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801052e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052eb:	e8 c0 f4 ff ff       	call   801047b0 <argint>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 6a                	js     8010535e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801052fa:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052fc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105303:	00 
80105304:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010530a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105311:	00 
80105312:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105318:	89 04 24             	mov    %eax,(%esp)
8010531b:	e8 80 f1 ff ff       	call   801044a0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105320:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105326:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010532a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010532d:	89 04 24             	mov    %eax,(%esp)
80105330:	e8 bb f3 ff ff       	call   801046f0 <fetchint>
80105335:	85 c0                	test   %eax,%eax
80105337:	78 25                	js     8010535e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105339:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010533f:	85 c0                	test   %eax,%eax
80105341:	74 2d                	je     80105370 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105343:	89 74 24 04          	mov    %esi,0x4(%esp)
80105347:	89 04 24             	mov    %eax,(%esp)
8010534a:	e8 f1 f3 ff ff       	call   80104740 <fetchstr>
8010534f:	85 c0                	test   %eax,%eax
80105351:	78 0b                	js     8010535e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105353:	83 c3 01             	add    $0x1,%ebx
80105356:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105359:	83 fb 20             	cmp    $0x20,%ebx
8010535c:	75 c2                	jne    80105320 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010535e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105369:	5b                   	pop    %ebx
8010536a:	5e                   	pop    %esi
8010536b:	5f                   	pop    %edi
8010536c:	5d                   	pop    %ebp
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105370:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105376:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105380:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105387:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010538b:	89 04 24             	mov    %eax,(%esp)
8010538e:	e8 0d b6 ff ff       	call   801009a0 <exec>
}
80105393:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105399:	5b                   	pop    %ebx
8010539a:	5e                   	pop    %esi
8010539b:	5f                   	pop    %edi
8010539c:	5d                   	pop    %ebp
8010539d:	c3                   	ret    
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <sys_pipe>:

int
sys_pipe(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801053b1:	00 
801053b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801053b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053bd:	e8 1e f4 ff ff       	call   801047e0 <argptr>
801053c2:	85 c0                	test   %eax,%eax
801053c4:	78 6d                	js     80105433 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801053c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d0:	89 04 24             	mov    %eax,(%esp)
801053d3:	e8 08 de ff ff       	call   801031e0 <pipealloc>
801053d8:	85 c0                	test   %eax,%eax
801053da:	78 57                	js     80105433 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053df:	e8 1c f5 ff ff       	call   80104900 <fdalloc>
801053e4:	85 c0                	test   %eax,%eax
801053e6:	89 c3                	mov    %eax,%ebx
801053e8:	78 33                	js     8010541d <sys_pipe+0x7d>
801053ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ed:	e8 0e f5 ff ff       	call   80104900 <fdalloc>
801053f2:	85 c0                	test   %eax,%eax
801053f4:	78 1a                	js     80105410 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801053f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053f9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801053fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053fe:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105401:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105404:	31 c0                	xor    %eax,%eax
}
80105406:	5b                   	pop    %ebx
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105410:	e8 4b e3 ff ff       	call   80103760 <myproc>
80105415:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010541c:	00 
    fileclose(rf);
8010541d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105420:	89 04 24             	mov    %eax,(%esp)
80105423:	e8 68 ba ff ff       	call   80100e90 <fileclose>
    fileclose(wf);
80105428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542b:	89 04 24             	mov    %eax,(%esp)
8010542e:	e8 5d ba ff ff       	call   80100e90 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105433:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010543b:	5b                   	pop    %ebx
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax

80105440 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105446:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105449:	89 44 24 04          	mov    %eax,0x4(%esp)
8010544d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105454:	e8 57 f3 ff ff       	call   801047b0 <argint>
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 33                	js     80105490 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010545d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105460:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105467:	00 
80105468:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105473:	e8 68 f3 ff ff       	call   801047e0 <argptr>
80105478:	85 c0                	test   %eax,%eax
8010547a:	78 14                	js     80105490 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010547c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105486:	89 04 24             	mov    %eax,(%esp)
80105489:	e8 92 20 00 00       	call   80107520 <shm_open>
}
8010548e:	c9                   	leave  
8010548f:	c3                   	ret    
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_shm_close>:

int sys_shm_close(void) {
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
801054a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054b4:	e8 f7 f2 ff ff       	call   801047b0 <argint>
801054b9:	85 c0                	test   %eax,%eax
801054bb:	78 13                	js     801054d0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801054bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c0:	89 04 24             	mov    %eax,(%esp)
801054c3:	e8 08 22 00 00       	call   801076d0 <shm_close>
}
801054c8:	c9                   	leave  
801054c9:	c3                   	ret    
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_fork>:

int
sys_fork(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054e3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
801054e4:	e9 d7 e4 ff ff       	jmp    801039c0 <fork>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_exit>:
}

int
sys_exit(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801054f6:	e8 75 e7 ff ff       	call   80103c70 <exit>
  return 0;  // not reached
}
801054fb:	31 c0                	xor    %eax,%eax
801054fd:	c9                   	leave  
801054fe:	c3                   	ret    
801054ff:	90                   	nop

80105500 <sys_wait>:

int
sys_wait(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105503:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105504:	e9 a7 e9 ff ff       	jmp    80103eb0 <wait>
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_kill>:
}

int
sys_kill(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105519:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105524:	e8 87 f2 ff ff       	call   801047b0 <argint>
80105529:	85 c0                	test   %eax,%eax
8010552b:	78 13                	js     80105540 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010552d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105530:	89 04 24             	mov    %eax,(%esp)
80105533:	e8 d8 ea ff ff       	call   80104010 <kill>
}
80105538:	c9                   	leave  
80105539:	c3                   	ret    
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_getpid>:

int
sys_getpid(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105556:	e8 05 e2 ff ff       	call   80103760 <myproc>
8010555b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010555e:	c9                   	leave  
8010555f:	c3                   	ret    

80105560 <sys_sbrk>:

int
sys_sbrk(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105567:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010556e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105575:	e8 36 f2 ff ff       	call   801047b0 <argint>
8010557a:	85 c0                	test   %eax,%eax
8010557c:	78 22                	js     801055a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010557e:	e8 dd e1 ff ff       	call   80103760 <myproc>
  if(growproc(n) < 0)
80105583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105586:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105588:	89 14 24             	mov    %edx,(%esp)
8010558b:	e8 60 e3 ff ff       	call   801038f0 <growproc>
80105590:	85 c0                	test   %eax,%eax
80105592:	78 0c                	js     801055a0 <sys_sbrk+0x40>
    {return -1;}
  return addr;
80105594:	89 d8                	mov    %ebx,%eax
}
80105596:	83 c4 24             	add    $0x24,%esp
80105599:	5b                   	pop    %ebx
8010559a:	5d                   	pop    %ebp
8010559b:	c3                   	ret    
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a5:	eb ef                	jmp    80105596 <sys_sbrk+0x36>
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
801055b4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801055be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055c5:	e8 e6 f1 ff ff       	call   801047b0 <argint>
801055ca:	85 c0                	test   %eax,%eax
801055cc:	78 7e                	js     8010564c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801055ce:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801055d5:	e8 86 ed ff ff       	call   80104360 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801055dd:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while(ticks - ticks0 < n){
801055e3:	85 d2                	test   %edx,%edx
801055e5:	75 29                	jne    80105610 <sys_sleep+0x60>
801055e7:	eb 4f                	jmp    80105638 <sys_sleep+0x88>
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801055f0:	c7 44 24 04 60 65 11 	movl   $0x80116560,0x4(%esp)
801055f7:	80 
801055f8:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
801055ff:	e8 fc e7 ff ff       	call   80103e00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105604:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80105609:	29 d8                	sub    %ebx,%eax
8010560b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010560e:	73 28                	jae    80105638 <sys_sleep+0x88>
    if(myproc()->killed){
80105610:	e8 4b e1 ff ff       	call   80103760 <myproc>
80105615:	8b 40 24             	mov    0x24(%eax),%eax
80105618:	85 c0                	test   %eax,%eax
8010561a:	74 d4                	je     801055f0 <sys_sleep+0x40>
      release(&tickslock);
8010561c:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105623:	e8 28 ee ff ff       	call   80104450 <release>
      return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010562d:	83 c4 24             	add    $0x24,%esp
80105630:	5b                   	pop    %ebx
80105631:	5d                   	pop    %ebp
80105632:	c3                   	ret    
80105633:	90                   	nop
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105638:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010563f:	e8 0c ee ff ff       	call   80104450 <release>
  return 0;
}
80105644:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105647:	31 c0                	xor    %eax,%eax
}
80105649:	5b                   	pop    %ebx
8010564a:	5d                   	pop    %ebp
8010564b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010564c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105651:	eb da                	jmp    8010562d <sys_sleep+0x7d>
80105653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105667:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010566e:	e8 ed ec ff ff       	call   80104360 <acquire>
  xticks = ticks;
80105673:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
80105679:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105680:	e8 cb ed ff ff       	call   80104450 <release>
  return xticks;
}
80105685:	83 c4 14             	add    $0x14,%esp
80105688:	89 d8                	mov    %ebx,%eax
8010568a:	5b                   	pop    %ebx
8010568b:	5d                   	pop    %ebp
8010568c:	c3                   	ret    

8010568d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010568d:	1e                   	push   %ds
  pushl %es
8010568e:	06                   	push   %es
  pushl %fs
8010568f:	0f a0                	push   %fs
  pushl %gs
80105691:	0f a8                	push   %gs
  pushal
80105693:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105694:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105698:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010569a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010569c:	54                   	push   %esp
  call trap
8010569d:	e8 de 00 00 00       	call   80105780 <trap>
  addl $4, %esp
801056a2:	83 c4 04             	add    $0x4,%esp

801056a5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056a5:	61                   	popa   
  popl %gs
801056a6:	0f a9                	pop    %gs
  popl %fs
801056a8:	0f a1                	pop    %fs
  popl %es
801056aa:	07                   	pop    %es
  popl %ds
801056ab:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056ac:	83 c4 08             	add    $0x8,%esp
  iret
801056af:	cf                   	iret   

801056b0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056b0:	31 c0                	xor    %eax,%eax
801056b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056b8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801056bf:	b9 08 00 00 00       	mov    $0x8,%ecx
801056c4:	66 89 0c c5 a2 65 11 	mov    %cx,-0x7fee9a5e(,%eax,8)
801056cb:	80 
801056cc:	c6 04 c5 a4 65 11 80 	movb   $0x0,-0x7fee9a5c(,%eax,8)
801056d3:	00 
801056d4:	c6 04 c5 a5 65 11 80 	movb   $0x8e,-0x7fee9a5b(,%eax,8)
801056db:	8e 
801056dc:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
801056e3:	80 
801056e4:	c1 ea 10             	shr    $0x10,%edx
801056e7:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
801056ee:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056ef:	83 c0 01             	add    $0x1,%eax
801056f2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056f7:	75 bf                	jne    801056b8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056f9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056fa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056ff:	89 e5                	mov    %esp,%ebp
80105701:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105704:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105709:	c7 44 24 04 81 80 10 	movl   $0x80108081,0x4(%esp)
80105710:	80 
80105711:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105718:	66 89 15 a2 67 11 80 	mov    %dx,0x801167a2
8010571f:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
80105725:	c1 e8 10             	shr    $0x10,%eax
80105728:	c6 05 a4 67 11 80 00 	movb   $0x0,0x801167a4
8010572f:	c6 05 a5 67 11 80 ef 	movb   $0xef,0x801167a5
80105736:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6

  initlock(&tickslock, "time");
8010573c:	e8 2f eb ff ff       	call   80104270 <initlock>
}
80105741:	c9                   	leave  
80105742:	c3                   	ret    
80105743:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <idtinit>:



void
idtinit(void)
{
80105750:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105751:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105756:	89 e5                	mov    %esp,%ebp
80105758:	83 ec 10             	sub    $0x10,%esp
8010575b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010575f:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
80105764:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105768:	c1 e8 10             	shr    $0x10,%eax
8010576b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010576f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105772:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
80105786:	83 ec 3c             	sub    $0x3c,%esp
80105789:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
8010578c:	e8 cf df ff ff       	call   80103760 <myproc>
  if(tf->trapno == T_SYSCALL){
80105791:	8b 53 30             	mov    0x30(%ebx),%edx
80105794:	83 fa 40             	cmp    $0x40,%edx
80105797:	0f 84 1b 02 00 00    	je     801059b8 <trap+0x238>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010579d:	83 ea 0e             	sub    $0xe,%edx
801057a0:	83 fa 31             	cmp    $0x31,%edx
801057a3:	77 0b                	ja     801057b0 <trap+0x30>
801057a5:	ff 24 95 78 82 10 80 	jmp    *-0x7fef7d88(,%edx,4)
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057b0:	e8 ab df ff ff       	call   80103760 <myproc>
801057b5:	85 c0                	test   %eax,%eax
801057b7:	0f 84 86 03 00 00    	je     80105b43 <trap+0x3c3>
801057bd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801057c1:	0f 84 7c 03 00 00    	je     80105b43 <trap+0x3c3>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057c7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057ca:	8b 53 38             	mov    0x38(%ebx),%edx
801057cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057d3:	e8 68 df ff ff       	call   80103740 <cpuid>
801057d8:	8b 73 30             	mov    0x30(%ebx),%esi
801057db:	89 c7                	mov    %eax,%edi
801057dd:	8b 43 34             	mov    0x34(%ebx),%eax
801057e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057e3:	e8 78 df ff ff       	call   80103760 <myproc>
801057e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801057eb:	e8 70 df ff ff       	call   80103760 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057f0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057f7:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
801057fd:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105801:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80105805:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105808:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010580b:	89 54 24 18          	mov    %edx,0x18(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010580f:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105813:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105817:	8b 40 10             	mov    0x10(%eax),%eax
8010581a:	c7 04 24 34 82 10 80 	movl   $0x80108234,(%esp)
80105821:	89 44 24 04          	mov    %eax,0x4(%esp)
80105825:	e8 26 ae ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010582a:	e8 31 df ff ff       	call   80103760 <myproc>
8010582f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105836:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105838:	e8 23 df ff ff       	call   80103760 <myproc>
8010583d:	85 c0                	test   %eax,%eax
8010583f:	74 0c                	je     8010584d <trap+0xcd>
80105841:	e8 1a df ff ff       	call   80103760 <myproc>
80105846:	8b 50 24             	mov    0x24(%eax),%edx
80105849:	85 d2                	test   %edx,%edx
8010584b:	75 4b                	jne    80105898 <trap+0x118>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010584d:	e8 0e df ff ff       	call   80103760 <myproc>
80105852:	85 c0                	test   %eax,%eax
80105854:	74 0c                	je     80105862 <trap+0xe2>
80105856:	e8 05 df ff ff       	call   80103760 <myproc>
8010585b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010585f:	90                   	nop
80105860:	74 4e                	je     801058b0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105862:	e8 f9 de ff ff       	call   80103760 <myproc>
80105867:	85 c0                	test   %eax,%eax
80105869:	74 22                	je     8010588d <trap+0x10d>
8010586b:	90                   	nop
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105870:	e8 eb de ff ff       	call   80103760 <myproc>
80105875:	8b 40 24             	mov    0x24(%eax),%eax
80105878:	85 c0                	test   %eax,%eax
8010587a:	74 11                	je     8010588d <trap+0x10d>
8010587c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105880:	83 e0 03             	and    $0x3,%eax
80105883:	66 83 f8 03          	cmp    $0x3,%ax
80105887:	0f 84 5c 01 00 00    	je     801059e9 <trap+0x269>
    exit();
}
8010588d:	83 c4 3c             	add    $0x3c,%esp
80105890:	5b                   	pop    %ebx
80105891:	5e                   	pop    %esi
80105892:	5f                   	pop    %edi
80105893:	5d                   	pop    %ebp
80105894:	c3                   	ret    
80105895:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105898:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010589c:	83 e0 03             	and    $0x3,%eax
8010589f:	66 83 f8 03          	cmp    $0x3,%ax
801058a3:	75 a8                	jne    8010584d <trap+0xcd>
    exit();
801058a5:	e8 c6 e3 ff ff       	call   80103c70 <exit>
801058aa:	eb a1                	jmp    8010584d <trap+0xcd>
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801058b4:	75 ac                	jne    80105862 <trap+0xe2>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801058b6:	e8 05 e5 ff ff       	call   80103dc0 <yield>
801058bb:	eb a5                	jmp    80105862 <trap+0xe2>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
801058c0:	89 c6                	mov    %eax,%esi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT: // For CS153 lab2 part1
		cprintf("page fault\n");
801058c2:	c7 04 24 86 80 10 80 	movl   $0x80108086,(%esp)
801058c9:	e8 82 ad ff ff       	call   80100650 <cprintf>
		if(curproc && (tf->cs&3) == DPL_USER){ // user mode
801058ce:	85 f6                	test   %esi,%esi
801058d0:	0f 84 da fe ff ff    	je     801057b0 <trap+0x30>
801058d6:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801058da:	83 e0 03             	and    $0x3,%eax
801058dd:	66 83 f8 03          	cmp    $0x3,%ax
801058e1:	0f 84 49 01 00 00    	je     80105a30 <trap+0x2b0>
801058e7:	0f 20 d2             	mov    %cr2,%edx
801058ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
		  cprintf("Access forbidden! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
			curproc->killed = 1;
			break;
		}else if(curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
801058ed:	8b 7b 38             	mov    0x38(%ebx),%edi
801058f0:	e8 4b de ff ff       	call   80103740 <cpuid>
801058f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801058f8:	89 7c 24 18          	mov    %edi,0x18(%esp)
801058fc:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80105900:	89 44 24 14          	mov    %eax,0x14(%esp)
80105904:	8b 43 34             	mov    0x34(%ebx),%eax
80105907:	89 44 24 10          	mov    %eax,0x10(%esp)
8010590b:	8b 43 30             	mov    0x30(%ebx),%eax
8010590e:	89 44 24 0c          	mov    %eax,0xc(%esp)
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
80105912:	8d 46 6c             	lea    0x6c(%esi),%eax
80105915:	89 44 24 08          	mov    %eax,0x8(%esp)
			}
		  cprintf("Access forbidden! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
			curproc->killed = 1;
			break;
		}else if(curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
80105919:	8b 46 10             	mov    0x10(%esi),%eax
8010591c:	c7 04 24 a0 81 10 80 	movl   $0x801081a0,(%esp)
80105923:	89 44 24 04          	mov    %eax,0x4(%esp)
80105927:	e8 24 ad ff ff       	call   80100650 <cprintf>
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
						  rcr2());                                          
			curproc->killed = 1;
8010592c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105933:	e9 00 ff ff ff       	jmp    80105838 <trap+0xb8>
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105938:	e8 03 de ff ff       	call   80103740 <cpuid>
8010593d:	85 c0                	test   %eax,%eax
8010593f:	0f 84 bb 00 00 00    	je     80105a00 <trap+0x280>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105945:	e8 a6 ce ff ff       	call   801027f0 <lapiceoi>
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
80105950:	e9 e3 fe ff ff       	jmp    80105838 <trap+0xb8>
80105955:	8d 76 00             	lea    0x0(%esi),%esi
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105960:	e8 db cc ff ff       	call   80102640 <kbdintr>
    lapiceoi();
80105965:	e8 86 ce ff ff       	call   801027f0 <lapiceoi>
    break;
8010596a:	e9 c9 fe ff ff       	jmp    80105838 <trap+0xb8>
8010596f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105970:	e8 2b 03 00 00       	call   80105ca0 <uartintr>
    lapiceoi();
80105975:	e8 76 ce ff ff       	call   801027f0 <lapiceoi>
    break;
8010597a:	e9 b9 fe ff ff       	jmp    80105838 <trap+0xb8>
8010597f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105980:	8b 7b 38             	mov    0x38(%ebx),%edi
80105983:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105987:	e8 b4 dd ff ff       	call   80103740 <cpuid>
8010598c:	c7 04 24 c8 80 10 80 	movl   $0x801080c8,(%esp)
80105993:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105997:	89 74 24 08          	mov    %esi,0x8(%esp)
8010599b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599f:	e8 ac ac ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801059a4:	e8 47 ce ff ff       	call   801027f0 <lapiceoi>
    break;
801059a9:	e9 8a fe ff ff       	jmp    80105838 <trap+0xb8>
801059ae:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059b0:	e8 3b c7 ff ff       	call   801020f0 <ideintr>
801059b5:	eb 8e                	jmp    80105945 <trap+0x1c5>
801059b7:	90                   	nop
801059b8:	90                   	nop
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801059c0:	e8 9b dd ff ff       	call   80103760 <myproc>
801059c5:	8b 70 24             	mov    0x24(%eax),%esi
801059c8:	85 f6                	test   %esi,%esi
801059ca:	75 2c                	jne    801059f8 <trap+0x278>
      exit();
    myproc()->tf = tf;
801059cc:	e8 8f dd ff ff       	call   80103760 <myproc>
801059d1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801059d4:	e8 b7 ee ff ff       	call   80104890 <syscall>
    if(myproc()->killed)
801059d9:	e8 82 dd ff ff       	call   80103760 <myproc>
801059de:	8b 48 24             	mov    0x24(%eax),%ecx
801059e1:	85 c9                	test   %ecx,%ecx
801059e3:	0f 84 a4 fe ff ff    	je     8010588d <trap+0x10d>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801059e9:	83 c4 3c             	add    $0x3c,%esp
801059ec:	5b                   	pop    %ebx
801059ed:	5e                   	pop    %esi
801059ee:	5f                   	pop    %edi
801059ef:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801059f0:	e9 7b e2 ff ff       	jmp    80103c70 <exit>
801059f5:	8d 76 00             	lea    0x0(%esi),%esi
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801059f8:	e8 73 e2 ff ff       	call   80103c70 <exit>
801059fd:	eb cd                	jmp    801059cc <trap+0x24c>
801059ff:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105a00:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105a07:	e8 54 e9 ff ff       	call   80104360 <acquire>
      ticks++;
      wakeup(&ticks);
80105a0c:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105a13:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
80105a1a:	e8 81 e5 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
80105a1f:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105a26:	e8 25 ea ff ff       	call   80104450 <release>
80105a2b:	e9 15 ff ff ff       	jmp    80105945 <trap+0x1c5>
    break;

  case T_PGFLT: // For CS153 lab2 part1
		cprintf("page fault\n");
		if(curproc && (tf->cs&3) == DPL_USER){ // user mode
			if(curproc->tf->esp <= curproc->tstack){ // Check to see if stack size matches esp and if it doesn't it makes it the same
80105a30:	8b 46 18             	mov    0x18(%esi),%eax
80105a33:	8b 56 7c             	mov    0x7c(%esi),%edx
80105a36:	8b 40 44             	mov    0x44(%eax),%eax
80105a39:	39 d0                	cmp    %edx,%eax
80105a3b:	77 5b                	ja     80105a98 <trap+0x318>
				uint rep = ((curproc->tstack - curproc->tf->esp)/PGSIZE)+1;
80105a3d:	29 c2                	sub    %eax,%edx
80105a3f:	c1 ea 0c             	shr    $0xc,%edx
80105a42:	8d 7a 01             	lea    0x1(%edx),%edi
				cprintf("rep: %d\n", rep);
80105a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105a49:	c7 04 24 92 80 10 80 	movl   $0x80108092,(%esp)
80105a50:	e8 fb ab ff ff       	call   80100650 <cprintf>
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
80105a55:	8b 46 18             	mov    0x18(%esi),%eax
80105a58:	8b 16                	mov    (%esi),%edx
80105a5a:	8b 40 44             	mov    0x44(%eax),%eax
80105a5d:	8d 8a 00 20 00 00    	lea    0x2000(%edx),%ecx
80105a63:	39 c1                	cmp    %eax,%ecx
80105a65:	76 5e                	jbe    80105ac5 <trap+0x345>
80105a67:	0f 20 d1             	mov    %cr2,%ecx
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105a6a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105a6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105a72:	8b 56 7c             	mov    0x7c(%esi),%edx
80105a75:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a79:	c7 04 24 ec 80 10 80 	movl   $0x801080ec,(%esp)
80105a80:	89 54 24 08          	mov    %edx,0x8(%esp)
80105a84:	e8 c7 ab ff ff       	call   80100650 <cprintf>
					curproc->killed = 1;
80105a89:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
					break;
80105a90:	e9 a3 fd ff ff       	jmp    80105838 <trap+0xb8>
80105a95:	8d 76 00             	lea    0x0(%esi),%esi
80105a98:	0f 20 d1             	mov    %cr2,%ecx
				}
				cprintf("current esp 0x%x\n",curproc->tf->esp);
				cprintf("current tstack 0x%x\n",curproc->tstack);
				break;
			}
		  cprintf("Access forbidden! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105a9b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105a9f:	8b 0e                	mov    (%esi),%ecx
80105aa1:	89 54 24 08          	mov    %edx,0x8(%esp)
80105aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa9:	c7 04 24 64 81 10 80 	movl   $0x80108164,(%esp)
80105ab0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105ab4:	e8 97 ab ff ff       	call   80100650 <cprintf>
			curproc->killed = 1;
80105ab9:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105ac0:	e9 73 fd ff ff       	jmp    80105838 <trap+0xb8>
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
					curproc->killed = 1;
					break;
				}
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 0){
80105ac5:	89 7c 24 08          	mov    %edi,0x8(%esp)
80105ac9:	8b 46 7c             	mov    0x7c(%esi),%eax
80105acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ad0:	8b 46 04             	mov    0x4(%esi),%eax
80105ad3:	89 04 24             	mov    %eax,(%esp)
80105ad6:	e8 05 18 00 00       	call   801072e0 <addstackpage>
80105adb:	85 c0                	test   %eax,%eax
80105add:	75 36                	jne    80105b15 <trap+0x395>
80105adf:	0f 20 d0             	mov    %cr2,%eax
		    	cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105ae2:	89 44 24 10          	mov    %eax,0x10(%esp)
80105ae6:	8b 06                	mov    (%esi),%eax
80105ae8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105aec:	8b 46 7c             	mov    0x7c(%esi),%eax
80105aef:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af3:	8b 46 18             	mov    0x18(%esi),%eax
80105af6:	8b 40 44             	mov    0x44(%eax),%eax
80105af9:	c7 04 24 28 81 10 80 	movl   $0x80108128,(%esp)
80105b00:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b04:	e8 47 ab ff ff       	call   80100650 <cprintf>
					curproc->killed = 1;
80105b09:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
					break;
80105b10:	e9 23 fd ff ff       	jmp    80105838 <trap+0xb8>
				}
				cprintf("current esp 0x%x\n",curproc->tf->esp);
80105b15:	8b 46 18             	mov    0x18(%esi),%eax
80105b18:	8b 40 44             	mov    0x44(%eax),%eax
80105b1b:	c7 04 24 9b 80 10 80 	movl   $0x8010809b,(%esp)
80105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b26:	e8 25 ab ff ff       	call   80100650 <cprintf>
				cprintf("current tstack 0x%x\n",curproc->tstack);
80105b2b:	8b 46 7c             	mov    0x7c(%esi),%eax
80105b2e:	c7 04 24 ad 80 10 80 	movl   $0x801080ad,(%esp)
80105b35:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b39:	e8 12 ab ff ff       	call   80100650 <cprintf>
				break;
80105b3e:	e9 f5 fc ff ff       	jmp    80105838 <trap+0xb8>
80105b43:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b46:	8b 73 38             	mov    0x38(%ebx),%esi
80105b49:	e8 f2 db ff ff       	call   80103740 <cpuid>
80105b4e:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105b52:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105b56:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b5a:	8b 43 30             	mov    0x30(%ebx),%eax
80105b5d:	c7 04 24 00 82 10 80 	movl   $0x80108200,(%esp)
80105b64:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b68:	e8 e3 aa ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105b6d:	c7 04 24 c2 80 10 80 	movl   $0x801080c2,(%esp)
80105b74:	e8 e7 a7 ff ff       	call   80100360 <panic>
80105b79:	66 90                	xchg   %ax,%ax
80105b7b:	66 90                	xchg   %ax,%ax
80105b7d:	66 90                	xchg   %ax,%ax
80105b7f:	90                   	nop

80105b80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b80:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105b85:	55                   	push   %ebp
80105b86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b88:	85 c0                	test   %eax,%eax
80105b8a:	74 14                	je     80105ba0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b92:	a8 01                	test   $0x1,%al
80105b94:	74 0a                	je     80105ba0 <uartgetc+0x20>
80105b96:	b2 f8                	mov    $0xf8,%dl
80105b98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b99:	0f b6 c0             	movzbl %al,%eax
}
80105b9c:	5d                   	pop    %ebp
80105b9d:	c3                   	ret    
80105b9e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105ba5:	5d                   	pop    %ebp
80105ba6:	c3                   	ret    
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bb0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	74 3f                	je     80105bf8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105bb9:	55                   	push   %ebp
80105bba:	89 e5                	mov    %esp,%ebp
80105bbc:	56                   	push   %esi
80105bbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105bc2:	53                   	push   %ebx
  int i;

  if(!uart)
80105bc3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bc8:	83 ec 10             	sub    $0x10,%esp
80105bcb:	eb 14                	jmp    80105be1 <uartputc+0x31>
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105bd0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105bd7:	e8 34 cc ff ff       	call   80102810 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105bdc:	83 eb 01             	sub    $0x1,%ebx
80105bdf:	74 07                	je     80105be8 <uartputc+0x38>
80105be1:	89 f2                	mov    %esi,%edx
80105be3:	ec                   	in     (%dx),%al
80105be4:	a8 20                	test   $0x20,%al
80105be6:	74 e8                	je     80105bd0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105be8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bec:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bf1:	ee                   	out    %al,(%dx)
}
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	5b                   	pop    %ebx
80105bf6:	5e                   	pop    %esi
80105bf7:	5d                   	pop    %ebp
80105bf8:	f3 c3                	repz ret 
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c00 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105c00:	55                   	push   %ebp
80105c01:	31 c9                	xor    %ecx,%ecx
80105c03:	89 e5                	mov    %esp,%ebp
80105c05:	89 c8                	mov    %ecx,%eax
80105c07:	57                   	push   %edi
80105c08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c0d:	56                   	push   %esi
80105c0e:	89 fa                	mov    %edi,%edx
80105c10:	53                   	push   %ebx
80105c11:	83 ec 1c             	sub    $0x1c,%esp
80105c14:	ee                   	out    %al,(%dx)
80105c15:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c1f:	89 f2                	mov    %esi,%edx
80105c21:	ee                   	out    %al,(%dx)
80105c22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c27:	b2 f8                	mov    $0xf8,%dl
80105c29:	ee                   	out    %al,(%dx)
80105c2a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c2f:	89 c8                	mov    %ecx,%eax
80105c31:	89 da                	mov    %ebx,%edx
80105c33:	ee                   	out    %al,(%dx)
80105c34:	b8 03 00 00 00       	mov    $0x3,%eax
80105c39:	89 f2                	mov    %esi,%edx
80105c3b:	ee                   	out    %al,(%dx)
80105c3c:	b2 fc                	mov    $0xfc,%dl
80105c3e:	89 c8                	mov    %ecx,%eax
80105c40:	ee                   	out    %al,(%dx)
80105c41:	b8 01 00 00 00       	mov    $0x1,%eax
80105c46:	89 da                	mov    %ebx,%edx
80105c48:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c49:	b2 fd                	mov    $0xfd,%dl
80105c4b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105c4c:	3c ff                	cmp    $0xff,%al
80105c4e:	74 42                	je     80105c92 <uartinit+0x92>
    return;
  uart = 1;
80105c50:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105c57:	00 00 00 
80105c5a:	89 fa                	mov    %edi,%edx
80105c5c:	ec                   	in     (%dx),%al
80105c5d:	b2 f8                	mov    $0xf8,%dl
80105c5f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105c60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c67:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c68:	bb 40 83 10 80       	mov    $0x80108340,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105c6d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105c74:	e8 a7 c6 ff ff       	call   80102320 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c79:	b8 78 00 00 00       	mov    $0x78,%eax
80105c7e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105c80:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c83:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105c86:	e8 25 ff ff ff       	call   80105bb0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c8b:	0f be 03             	movsbl (%ebx),%eax
80105c8e:	84 c0                	test   %al,%al
80105c90:	75 ee                	jne    80105c80 <uartinit+0x80>
    uartputc(*p);
}
80105c92:	83 c4 1c             	add    $0x1c,%esp
80105c95:	5b                   	pop    %ebx
80105c96:	5e                   	pop    %esi
80105c97:	5f                   	pop    %edi
80105c98:	5d                   	pop    %ebp
80105c99:	c3                   	ret    
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ca0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ca6:	c7 04 24 80 5b 10 80 	movl   $0x80105b80,(%esp)
80105cad:	e8 fe aa ff ff       	call   801007b0 <consoleintr>
}
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    

80105cb4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $0
80105cb6:	6a 00                	push   $0x0
  jmp alltraps
80105cb8:	e9 d0 f9 ff ff       	jmp    8010568d <alltraps>

80105cbd <vector1>:
.globl vector1
vector1:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $1
80105cbf:	6a 01                	push   $0x1
  jmp alltraps
80105cc1:	e9 c7 f9 ff ff       	jmp    8010568d <alltraps>

80105cc6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $2
80105cc8:	6a 02                	push   $0x2
  jmp alltraps
80105cca:	e9 be f9 ff ff       	jmp    8010568d <alltraps>

80105ccf <vector3>:
.globl vector3
vector3:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $3
80105cd1:	6a 03                	push   $0x3
  jmp alltraps
80105cd3:	e9 b5 f9 ff ff       	jmp    8010568d <alltraps>

80105cd8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $4
80105cda:	6a 04                	push   $0x4
  jmp alltraps
80105cdc:	e9 ac f9 ff ff       	jmp    8010568d <alltraps>

80105ce1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $5
80105ce3:	6a 05                	push   $0x5
  jmp alltraps
80105ce5:	e9 a3 f9 ff ff       	jmp    8010568d <alltraps>

80105cea <vector6>:
.globl vector6
vector6:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $6
80105cec:	6a 06                	push   $0x6
  jmp alltraps
80105cee:	e9 9a f9 ff ff       	jmp    8010568d <alltraps>

80105cf3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $7
80105cf5:	6a 07                	push   $0x7
  jmp alltraps
80105cf7:	e9 91 f9 ff ff       	jmp    8010568d <alltraps>

80105cfc <vector8>:
.globl vector8
vector8:
  pushl $8
80105cfc:	6a 08                	push   $0x8
  jmp alltraps
80105cfe:	e9 8a f9 ff ff       	jmp    8010568d <alltraps>

80105d03 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $9
80105d05:	6a 09                	push   $0x9
  jmp alltraps
80105d07:	e9 81 f9 ff ff       	jmp    8010568d <alltraps>

80105d0c <vector10>:
.globl vector10
vector10:
  pushl $10
80105d0c:	6a 0a                	push   $0xa
  jmp alltraps
80105d0e:	e9 7a f9 ff ff       	jmp    8010568d <alltraps>

80105d13 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d13:	6a 0b                	push   $0xb
  jmp alltraps
80105d15:	e9 73 f9 ff ff       	jmp    8010568d <alltraps>

80105d1a <vector12>:
.globl vector12
vector12:
  pushl $12
80105d1a:	6a 0c                	push   $0xc
  jmp alltraps
80105d1c:	e9 6c f9 ff ff       	jmp    8010568d <alltraps>

80105d21 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d21:	6a 0d                	push   $0xd
  jmp alltraps
80105d23:	e9 65 f9 ff ff       	jmp    8010568d <alltraps>

80105d28 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d28:	6a 0e                	push   $0xe
  jmp alltraps
80105d2a:	e9 5e f9 ff ff       	jmp    8010568d <alltraps>

80105d2f <vector15>:
.globl vector15
vector15:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $15
80105d31:	6a 0f                	push   $0xf
  jmp alltraps
80105d33:	e9 55 f9 ff ff       	jmp    8010568d <alltraps>

80105d38 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $16
80105d3a:	6a 10                	push   $0x10
  jmp alltraps
80105d3c:	e9 4c f9 ff ff       	jmp    8010568d <alltraps>

80105d41 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d41:	6a 11                	push   $0x11
  jmp alltraps
80105d43:	e9 45 f9 ff ff       	jmp    8010568d <alltraps>

80105d48 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $18
80105d4a:	6a 12                	push   $0x12
  jmp alltraps
80105d4c:	e9 3c f9 ff ff       	jmp    8010568d <alltraps>

80105d51 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $19
80105d53:	6a 13                	push   $0x13
  jmp alltraps
80105d55:	e9 33 f9 ff ff       	jmp    8010568d <alltraps>

80105d5a <vector20>:
.globl vector20
vector20:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $20
80105d5c:	6a 14                	push   $0x14
  jmp alltraps
80105d5e:	e9 2a f9 ff ff       	jmp    8010568d <alltraps>

80105d63 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $21
80105d65:	6a 15                	push   $0x15
  jmp alltraps
80105d67:	e9 21 f9 ff ff       	jmp    8010568d <alltraps>

80105d6c <vector22>:
.globl vector22
vector22:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $22
80105d6e:	6a 16                	push   $0x16
  jmp alltraps
80105d70:	e9 18 f9 ff ff       	jmp    8010568d <alltraps>

80105d75 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $23
80105d77:	6a 17                	push   $0x17
  jmp alltraps
80105d79:	e9 0f f9 ff ff       	jmp    8010568d <alltraps>

80105d7e <vector24>:
.globl vector24
vector24:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $24
80105d80:	6a 18                	push   $0x18
  jmp alltraps
80105d82:	e9 06 f9 ff ff       	jmp    8010568d <alltraps>

80105d87 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $25
80105d89:	6a 19                	push   $0x19
  jmp alltraps
80105d8b:	e9 fd f8 ff ff       	jmp    8010568d <alltraps>

80105d90 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $26
80105d92:	6a 1a                	push   $0x1a
  jmp alltraps
80105d94:	e9 f4 f8 ff ff       	jmp    8010568d <alltraps>

80105d99 <vector27>:
.globl vector27
vector27:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $27
80105d9b:	6a 1b                	push   $0x1b
  jmp alltraps
80105d9d:	e9 eb f8 ff ff       	jmp    8010568d <alltraps>

80105da2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $28
80105da4:	6a 1c                	push   $0x1c
  jmp alltraps
80105da6:	e9 e2 f8 ff ff       	jmp    8010568d <alltraps>

80105dab <vector29>:
.globl vector29
vector29:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $29
80105dad:	6a 1d                	push   $0x1d
  jmp alltraps
80105daf:	e9 d9 f8 ff ff       	jmp    8010568d <alltraps>

80105db4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $30
80105db6:	6a 1e                	push   $0x1e
  jmp alltraps
80105db8:	e9 d0 f8 ff ff       	jmp    8010568d <alltraps>

80105dbd <vector31>:
.globl vector31
vector31:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $31
80105dbf:	6a 1f                	push   $0x1f
  jmp alltraps
80105dc1:	e9 c7 f8 ff ff       	jmp    8010568d <alltraps>

80105dc6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $32
80105dc8:	6a 20                	push   $0x20
  jmp alltraps
80105dca:	e9 be f8 ff ff       	jmp    8010568d <alltraps>

80105dcf <vector33>:
.globl vector33
vector33:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $33
80105dd1:	6a 21                	push   $0x21
  jmp alltraps
80105dd3:	e9 b5 f8 ff ff       	jmp    8010568d <alltraps>

80105dd8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $34
80105dda:	6a 22                	push   $0x22
  jmp alltraps
80105ddc:	e9 ac f8 ff ff       	jmp    8010568d <alltraps>

80105de1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $35
80105de3:	6a 23                	push   $0x23
  jmp alltraps
80105de5:	e9 a3 f8 ff ff       	jmp    8010568d <alltraps>

80105dea <vector36>:
.globl vector36
vector36:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $36
80105dec:	6a 24                	push   $0x24
  jmp alltraps
80105dee:	e9 9a f8 ff ff       	jmp    8010568d <alltraps>

80105df3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $37
80105df5:	6a 25                	push   $0x25
  jmp alltraps
80105df7:	e9 91 f8 ff ff       	jmp    8010568d <alltraps>

80105dfc <vector38>:
.globl vector38
vector38:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $38
80105dfe:	6a 26                	push   $0x26
  jmp alltraps
80105e00:	e9 88 f8 ff ff       	jmp    8010568d <alltraps>

80105e05 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $39
80105e07:	6a 27                	push   $0x27
  jmp alltraps
80105e09:	e9 7f f8 ff ff       	jmp    8010568d <alltraps>

80105e0e <vector40>:
.globl vector40
vector40:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $40
80105e10:	6a 28                	push   $0x28
  jmp alltraps
80105e12:	e9 76 f8 ff ff       	jmp    8010568d <alltraps>

80105e17 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $41
80105e19:	6a 29                	push   $0x29
  jmp alltraps
80105e1b:	e9 6d f8 ff ff       	jmp    8010568d <alltraps>

80105e20 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $42
80105e22:	6a 2a                	push   $0x2a
  jmp alltraps
80105e24:	e9 64 f8 ff ff       	jmp    8010568d <alltraps>

80105e29 <vector43>:
.globl vector43
vector43:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $43
80105e2b:	6a 2b                	push   $0x2b
  jmp alltraps
80105e2d:	e9 5b f8 ff ff       	jmp    8010568d <alltraps>

80105e32 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $44
80105e34:	6a 2c                	push   $0x2c
  jmp alltraps
80105e36:	e9 52 f8 ff ff       	jmp    8010568d <alltraps>

80105e3b <vector45>:
.globl vector45
vector45:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $45
80105e3d:	6a 2d                	push   $0x2d
  jmp alltraps
80105e3f:	e9 49 f8 ff ff       	jmp    8010568d <alltraps>

80105e44 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $46
80105e46:	6a 2e                	push   $0x2e
  jmp alltraps
80105e48:	e9 40 f8 ff ff       	jmp    8010568d <alltraps>

80105e4d <vector47>:
.globl vector47
vector47:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $47
80105e4f:	6a 2f                	push   $0x2f
  jmp alltraps
80105e51:	e9 37 f8 ff ff       	jmp    8010568d <alltraps>

80105e56 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $48
80105e58:	6a 30                	push   $0x30
  jmp alltraps
80105e5a:	e9 2e f8 ff ff       	jmp    8010568d <alltraps>

80105e5f <vector49>:
.globl vector49
vector49:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $49
80105e61:	6a 31                	push   $0x31
  jmp alltraps
80105e63:	e9 25 f8 ff ff       	jmp    8010568d <alltraps>

80105e68 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $50
80105e6a:	6a 32                	push   $0x32
  jmp alltraps
80105e6c:	e9 1c f8 ff ff       	jmp    8010568d <alltraps>

80105e71 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $51
80105e73:	6a 33                	push   $0x33
  jmp alltraps
80105e75:	e9 13 f8 ff ff       	jmp    8010568d <alltraps>

80105e7a <vector52>:
.globl vector52
vector52:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $52
80105e7c:	6a 34                	push   $0x34
  jmp alltraps
80105e7e:	e9 0a f8 ff ff       	jmp    8010568d <alltraps>

80105e83 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $53
80105e85:	6a 35                	push   $0x35
  jmp alltraps
80105e87:	e9 01 f8 ff ff       	jmp    8010568d <alltraps>

80105e8c <vector54>:
.globl vector54
vector54:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $54
80105e8e:	6a 36                	push   $0x36
  jmp alltraps
80105e90:	e9 f8 f7 ff ff       	jmp    8010568d <alltraps>

80105e95 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $55
80105e97:	6a 37                	push   $0x37
  jmp alltraps
80105e99:	e9 ef f7 ff ff       	jmp    8010568d <alltraps>

80105e9e <vector56>:
.globl vector56
vector56:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $56
80105ea0:	6a 38                	push   $0x38
  jmp alltraps
80105ea2:	e9 e6 f7 ff ff       	jmp    8010568d <alltraps>

80105ea7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $57
80105ea9:	6a 39                	push   $0x39
  jmp alltraps
80105eab:	e9 dd f7 ff ff       	jmp    8010568d <alltraps>

80105eb0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $58
80105eb2:	6a 3a                	push   $0x3a
  jmp alltraps
80105eb4:	e9 d4 f7 ff ff       	jmp    8010568d <alltraps>

80105eb9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $59
80105ebb:	6a 3b                	push   $0x3b
  jmp alltraps
80105ebd:	e9 cb f7 ff ff       	jmp    8010568d <alltraps>

80105ec2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $60
80105ec4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ec6:	e9 c2 f7 ff ff       	jmp    8010568d <alltraps>

80105ecb <vector61>:
.globl vector61
vector61:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $61
80105ecd:	6a 3d                	push   $0x3d
  jmp alltraps
80105ecf:	e9 b9 f7 ff ff       	jmp    8010568d <alltraps>

80105ed4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $62
80105ed6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ed8:	e9 b0 f7 ff ff       	jmp    8010568d <alltraps>

80105edd <vector63>:
.globl vector63
vector63:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $63
80105edf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ee1:	e9 a7 f7 ff ff       	jmp    8010568d <alltraps>

80105ee6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $64
80105ee8:	6a 40                	push   $0x40
  jmp alltraps
80105eea:	e9 9e f7 ff ff       	jmp    8010568d <alltraps>

80105eef <vector65>:
.globl vector65
vector65:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $65
80105ef1:	6a 41                	push   $0x41
  jmp alltraps
80105ef3:	e9 95 f7 ff ff       	jmp    8010568d <alltraps>

80105ef8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $66
80105efa:	6a 42                	push   $0x42
  jmp alltraps
80105efc:	e9 8c f7 ff ff       	jmp    8010568d <alltraps>

80105f01 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $67
80105f03:	6a 43                	push   $0x43
  jmp alltraps
80105f05:	e9 83 f7 ff ff       	jmp    8010568d <alltraps>

80105f0a <vector68>:
.globl vector68
vector68:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $68
80105f0c:	6a 44                	push   $0x44
  jmp alltraps
80105f0e:	e9 7a f7 ff ff       	jmp    8010568d <alltraps>

80105f13 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $69
80105f15:	6a 45                	push   $0x45
  jmp alltraps
80105f17:	e9 71 f7 ff ff       	jmp    8010568d <alltraps>

80105f1c <vector70>:
.globl vector70
vector70:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $70
80105f1e:	6a 46                	push   $0x46
  jmp alltraps
80105f20:	e9 68 f7 ff ff       	jmp    8010568d <alltraps>

80105f25 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $71
80105f27:	6a 47                	push   $0x47
  jmp alltraps
80105f29:	e9 5f f7 ff ff       	jmp    8010568d <alltraps>

80105f2e <vector72>:
.globl vector72
vector72:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $72
80105f30:	6a 48                	push   $0x48
  jmp alltraps
80105f32:	e9 56 f7 ff ff       	jmp    8010568d <alltraps>

80105f37 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $73
80105f39:	6a 49                	push   $0x49
  jmp alltraps
80105f3b:	e9 4d f7 ff ff       	jmp    8010568d <alltraps>

80105f40 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $74
80105f42:	6a 4a                	push   $0x4a
  jmp alltraps
80105f44:	e9 44 f7 ff ff       	jmp    8010568d <alltraps>

80105f49 <vector75>:
.globl vector75
vector75:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $75
80105f4b:	6a 4b                	push   $0x4b
  jmp alltraps
80105f4d:	e9 3b f7 ff ff       	jmp    8010568d <alltraps>

80105f52 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $76
80105f54:	6a 4c                	push   $0x4c
  jmp alltraps
80105f56:	e9 32 f7 ff ff       	jmp    8010568d <alltraps>

80105f5b <vector77>:
.globl vector77
vector77:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $77
80105f5d:	6a 4d                	push   $0x4d
  jmp alltraps
80105f5f:	e9 29 f7 ff ff       	jmp    8010568d <alltraps>

80105f64 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $78
80105f66:	6a 4e                	push   $0x4e
  jmp alltraps
80105f68:	e9 20 f7 ff ff       	jmp    8010568d <alltraps>

80105f6d <vector79>:
.globl vector79
vector79:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $79
80105f6f:	6a 4f                	push   $0x4f
  jmp alltraps
80105f71:	e9 17 f7 ff ff       	jmp    8010568d <alltraps>

80105f76 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $80
80105f78:	6a 50                	push   $0x50
  jmp alltraps
80105f7a:	e9 0e f7 ff ff       	jmp    8010568d <alltraps>

80105f7f <vector81>:
.globl vector81
vector81:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $81
80105f81:	6a 51                	push   $0x51
  jmp alltraps
80105f83:	e9 05 f7 ff ff       	jmp    8010568d <alltraps>

80105f88 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $82
80105f8a:	6a 52                	push   $0x52
  jmp alltraps
80105f8c:	e9 fc f6 ff ff       	jmp    8010568d <alltraps>

80105f91 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $83
80105f93:	6a 53                	push   $0x53
  jmp alltraps
80105f95:	e9 f3 f6 ff ff       	jmp    8010568d <alltraps>

80105f9a <vector84>:
.globl vector84
vector84:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $84
80105f9c:	6a 54                	push   $0x54
  jmp alltraps
80105f9e:	e9 ea f6 ff ff       	jmp    8010568d <alltraps>

80105fa3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $85
80105fa5:	6a 55                	push   $0x55
  jmp alltraps
80105fa7:	e9 e1 f6 ff ff       	jmp    8010568d <alltraps>

80105fac <vector86>:
.globl vector86
vector86:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $86
80105fae:	6a 56                	push   $0x56
  jmp alltraps
80105fb0:	e9 d8 f6 ff ff       	jmp    8010568d <alltraps>

80105fb5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $87
80105fb7:	6a 57                	push   $0x57
  jmp alltraps
80105fb9:	e9 cf f6 ff ff       	jmp    8010568d <alltraps>

80105fbe <vector88>:
.globl vector88
vector88:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $88
80105fc0:	6a 58                	push   $0x58
  jmp alltraps
80105fc2:	e9 c6 f6 ff ff       	jmp    8010568d <alltraps>

80105fc7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $89
80105fc9:	6a 59                	push   $0x59
  jmp alltraps
80105fcb:	e9 bd f6 ff ff       	jmp    8010568d <alltraps>

80105fd0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $90
80105fd2:	6a 5a                	push   $0x5a
  jmp alltraps
80105fd4:	e9 b4 f6 ff ff       	jmp    8010568d <alltraps>

80105fd9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $91
80105fdb:	6a 5b                	push   $0x5b
  jmp alltraps
80105fdd:	e9 ab f6 ff ff       	jmp    8010568d <alltraps>

80105fe2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $92
80105fe4:	6a 5c                	push   $0x5c
  jmp alltraps
80105fe6:	e9 a2 f6 ff ff       	jmp    8010568d <alltraps>

80105feb <vector93>:
.globl vector93
vector93:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $93
80105fed:	6a 5d                	push   $0x5d
  jmp alltraps
80105fef:	e9 99 f6 ff ff       	jmp    8010568d <alltraps>

80105ff4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $94
80105ff6:	6a 5e                	push   $0x5e
  jmp alltraps
80105ff8:	e9 90 f6 ff ff       	jmp    8010568d <alltraps>

80105ffd <vector95>:
.globl vector95
vector95:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $95
80105fff:	6a 5f                	push   $0x5f
  jmp alltraps
80106001:	e9 87 f6 ff ff       	jmp    8010568d <alltraps>

80106006 <vector96>:
.globl vector96
vector96:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $96
80106008:	6a 60                	push   $0x60
  jmp alltraps
8010600a:	e9 7e f6 ff ff       	jmp    8010568d <alltraps>

8010600f <vector97>:
.globl vector97
vector97:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $97
80106011:	6a 61                	push   $0x61
  jmp alltraps
80106013:	e9 75 f6 ff ff       	jmp    8010568d <alltraps>

80106018 <vector98>:
.globl vector98
vector98:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $98
8010601a:	6a 62                	push   $0x62
  jmp alltraps
8010601c:	e9 6c f6 ff ff       	jmp    8010568d <alltraps>

80106021 <vector99>:
.globl vector99
vector99:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $99
80106023:	6a 63                	push   $0x63
  jmp alltraps
80106025:	e9 63 f6 ff ff       	jmp    8010568d <alltraps>

8010602a <vector100>:
.globl vector100
vector100:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $100
8010602c:	6a 64                	push   $0x64
  jmp alltraps
8010602e:	e9 5a f6 ff ff       	jmp    8010568d <alltraps>

80106033 <vector101>:
.globl vector101
vector101:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $101
80106035:	6a 65                	push   $0x65
  jmp alltraps
80106037:	e9 51 f6 ff ff       	jmp    8010568d <alltraps>

8010603c <vector102>:
.globl vector102
vector102:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $102
8010603e:	6a 66                	push   $0x66
  jmp alltraps
80106040:	e9 48 f6 ff ff       	jmp    8010568d <alltraps>

80106045 <vector103>:
.globl vector103
vector103:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $103
80106047:	6a 67                	push   $0x67
  jmp alltraps
80106049:	e9 3f f6 ff ff       	jmp    8010568d <alltraps>

8010604e <vector104>:
.globl vector104
vector104:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $104
80106050:	6a 68                	push   $0x68
  jmp alltraps
80106052:	e9 36 f6 ff ff       	jmp    8010568d <alltraps>

80106057 <vector105>:
.globl vector105
vector105:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $105
80106059:	6a 69                	push   $0x69
  jmp alltraps
8010605b:	e9 2d f6 ff ff       	jmp    8010568d <alltraps>

80106060 <vector106>:
.globl vector106
vector106:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $106
80106062:	6a 6a                	push   $0x6a
  jmp alltraps
80106064:	e9 24 f6 ff ff       	jmp    8010568d <alltraps>

80106069 <vector107>:
.globl vector107
vector107:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $107
8010606b:	6a 6b                	push   $0x6b
  jmp alltraps
8010606d:	e9 1b f6 ff ff       	jmp    8010568d <alltraps>

80106072 <vector108>:
.globl vector108
vector108:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $108
80106074:	6a 6c                	push   $0x6c
  jmp alltraps
80106076:	e9 12 f6 ff ff       	jmp    8010568d <alltraps>

8010607b <vector109>:
.globl vector109
vector109:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $109
8010607d:	6a 6d                	push   $0x6d
  jmp alltraps
8010607f:	e9 09 f6 ff ff       	jmp    8010568d <alltraps>

80106084 <vector110>:
.globl vector110
vector110:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $110
80106086:	6a 6e                	push   $0x6e
  jmp alltraps
80106088:	e9 00 f6 ff ff       	jmp    8010568d <alltraps>

8010608d <vector111>:
.globl vector111
vector111:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $111
8010608f:	6a 6f                	push   $0x6f
  jmp alltraps
80106091:	e9 f7 f5 ff ff       	jmp    8010568d <alltraps>

80106096 <vector112>:
.globl vector112
vector112:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $112
80106098:	6a 70                	push   $0x70
  jmp alltraps
8010609a:	e9 ee f5 ff ff       	jmp    8010568d <alltraps>

8010609f <vector113>:
.globl vector113
vector113:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $113
801060a1:	6a 71                	push   $0x71
  jmp alltraps
801060a3:	e9 e5 f5 ff ff       	jmp    8010568d <alltraps>

801060a8 <vector114>:
.globl vector114
vector114:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $114
801060aa:	6a 72                	push   $0x72
  jmp alltraps
801060ac:	e9 dc f5 ff ff       	jmp    8010568d <alltraps>

801060b1 <vector115>:
.globl vector115
vector115:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $115
801060b3:	6a 73                	push   $0x73
  jmp alltraps
801060b5:	e9 d3 f5 ff ff       	jmp    8010568d <alltraps>

801060ba <vector116>:
.globl vector116
vector116:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $116
801060bc:	6a 74                	push   $0x74
  jmp alltraps
801060be:	e9 ca f5 ff ff       	jmp    8010568d <alltraps>

801060c3 <vector117>:
.globl vector117
vector117:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $117
801060c5:	6a 75                	push   $0x75
  jmp alltraps
801060c7:	e9 c1 f5 ff ff       	jmp    8010568d <alltraps>

801060cc <vector118>:
.globl vector118
vector118:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $118
801060ce:	6a 76                	push   $0x76
  jmp alltraps
801060d0:	e9 b8 f5 ff ff       	jmp    8010568d <alltraps>

801060d5 <vector119>:
.globl vector119
vector119:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $119
801060d7:	6a 77                	push   $0x77
  jmp alltraps
801060d9:	e9 af f5 ff ff       	jmp    8010568d <alltraps>

801060de <vector120>:
.globl vector120
vector120:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $120
801060e0:	6a 78                	push   $0x78
  jmp alltraps
801060e2:	e9 a6 f5 ff ff       	jmp    8010568d <alltraps>

801060e7 <vector121>:
.globl vector121
vector121:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $121
801060e9:	6a 79                	push   $0x79
  jmp alltraps
801060eb:	e9 9d f5 ff ff       	jmp    8010568d <alltraps>

801060f0 <vector122>:
.globl vector122
vector122:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $122
801060f2:	6a 7a                	push   $0x7a
  jmp alltraps
801060f4:	e9 94 f5 ff ff       	jmp    8010568d <alltraps>

801060f9 <vector123>:
.globl vector123
vector123:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $123
801060fb:	6a 7b                	push   $0x7b
  jmp alltraps
801060fd:	e9 8b f5 ff ff       	jmp    8010568d <alltraps>

80106102 <vector124>:
.globl vector124
vector124:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $124
80106104:	6a 7c                	push   $0x7c
  jmp alltraps
80106106:	e9 82 f5 ff ff       	jmp    8010568d <alltraps>

8010610b <vector125>:
.globl vector125
vector125:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $125
8010610d:	6a 7d                	push   $0x7d
  jmp alltraps
8010610f:	e9 79 f5 ff ff       	jmp    8010568d <alltraps>

80106114 <vector126>:
.globl vector126
vector126:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $126
80106116:	6a 7e                	push   $0x7e
  jmp alltraps
80106118:	e9 70 f5 ff ff       	jmp    8010568d <alltraps>

8010611d <vector127>:
.globl vector127
vector127:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $127
8010611f:	6a 7f                	push   $0x7f
  jmp alltraps
80106121:	e9 67 f5 ff ff       	jmp    8010568d <alltraps>

80106126 <vector128>:
.globl vector128
vector128:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $128
80106128:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010612d:	e9 5b f5 ff ff       	jmp    8010568d <alltraps>

80106132 <vector129>:
.globl vector129
vector129:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $129
80106134:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106139:	e9 4f f5 ff ff       	jmp    8010568d <alltraps>

8010613e <vector130>:
.globl vector130
vector130:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $130
80106140:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106145:	e9 43 f5 ff ff       	jmp    8010568d <alltraps>

8010614a <vector131>:
.globl vector131
vector131:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $131
8010614c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106151:	e9 37 f5 ff ff       	jmp    8010568d <alltraps>

80106156 <vector132>:
.globl vector132
vector132:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $132
80106158:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010615d:	e9 2b f5 ff ff       	jmp    8010568d <alltraps>

80106162 <vector133>:
.globl vector133
vector133:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $133
80106164:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106169:	e9 1f f5 ff ff       	jmp    8010568d <alltraps>

8010616e <vector134>:
.globl vector134
vector134:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $134
80106170:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106175:	e9 13 f5 ff ff       	jmp    8010568d <alltraps>

8010617a <vector135>:
.globl vector135
vector135:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $135
8010617c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106181:	e9 07 f5 ff ff       	jmp    8010568d <alltraps>

80106186 <vector136>:
.globl vector136
vector136:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $136
80106188:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010618d:	e9 fb f4 ff ff       	jmp    8010568d <alltraps>

80106192 <vector137>:
.globl vector137
vector137:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $137
80106194:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106199:	e9 ef f4 ff ff       	jmp    8010568d <alltraps>

8010619e <vector138>:
.globl vector138
vector138:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $138
801061a0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061a5:	e9 e3 f4 ff ff       	jmp    8010568d <alltraps>

801061aa <vector139>:
.globl vector139
vector139:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $139
801061ac:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061b1:	e9 d7 f4 ff ff       	jmp    8010568d <alltraps>

801061b6 <vector140>:
.globl vector140
vector140:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $140
801061b8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061bd:	e9 cb f4 ff ff       	jmp    8010568d <alltraps>

801061c2 <vector141>:
.globl vector141
vector141:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $141
801061c4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061c9:	e9 bf f4 ff ff       	jmp    8010568d <alltraps>

801061ce <vector142>:
.globl vector142
vector142:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $142
801061d0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061d5:	e9 b3 f4 ff ff       	jmp    8010568d <alltraps>

801061da <vector143>:
.globl vector143
vector143:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $143
801061dc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061e1:	e9 a7 f4 ff ff       	jmp    8010568d <alltraps>

801061e6 <vector144>:
.globl vector144
vector144:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $144
801061e8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ed:	e9 9b f4 ff ff       	jmp    8010568d <alltraps>

801061f2 <vector145>:
.globl vector145
vector145:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $145
801061f4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061f9:	e9 8f f4 ff ff       	jmp    8010568d <alltraps>

801061fe <vector146>:
.globl vector146
vector146:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $146
80106200:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106205:	e9 83 f4 ff ff       	jmp    8010568d <alltraps>

8010620a <vector147>:
.globl vector147
vector147:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $147
8010620c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106211:	e9 77 f4 ff ff       	jmp    8010568d <alltraps>

80106216 <vector148>:
.globl vector148
vector148:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $148
80106218:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010621d:	e9 6b f4 ff ff       	jmp    8010568d <alltraps>

80106222 <vector149>:
.globl vector149
vector149:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $149
80106224:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106229:	e9 5f f4 ff ff       	jmp    8010568d <alltraps>

8010622e <vector150>:
.globl vector150
vector150:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $150
80106230:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106235:	e9 53 f4 ff ff       	jmp    8010568d <alltraps>

8010623a <vector151>:
.globl vector151
vector151:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $151
8010623c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106241:	e9 47 f4 ff ff       	jmp    8010568d <alltraps>

80106246 <vector152>:
.globl vector152
vector152:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $152
80106248:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010624d:	e9 3b f4 ff ff       	jmp    8010568d <alltraps>

80106252 <vector153>:
.globl vector153
vector153:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $153
80106254:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106259:	e9 2f f4 ff ff       	jmp    8010568d <alltraps>

8010625e <vector154>:
.globl vector154
vector154:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $154
80106260:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106265:	e9 23 f4 ff ff       	jmp    8010568d <alltraps>

8010626a <vector155>:
.globl vector155
vector155:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $155
8010626c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106271:	e9 17 f4 ff ff       	jmp    8010568d <alltraps>

80106276 <vector156>:
.globl vector156
vector156:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $156
80106278:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010627d:	e9 0b f4 ff ff       	jmp    8010568d <alltraps>

80106282 <vector157>:
.globl vector157
vector157:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $157
80106284:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106289:	e9 ff f3 ff ff       	jmp    8010568d <alltraps>

8010628e <vector158>:
.globl vector158
vector158:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $158
80106290:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106295:	e9 f3 f3 ff ff       	jmp    8010568d <alltraps>

8010629a <vector159>:
.globl vector159
vector159:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $159
8010629c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062a1:	e9 e7 f3 ff ff       	jmp    8010568d <alltraps>

801062a6 <vector160>:
.globl vector160
vector160:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $160
801062a8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ad:	e9 db f3 ff ff       	jmp    8010568d <alltraps>

801062b2 <vector161>:
.globl vector161
vector161:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $161
801062b4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062b9:	e9 cf f3 ff ff       	jmp    8010568d <alltraps>

801062be <vector162>:
.globl vector162
vector162:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $162
801062c0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062c5:	e9 c3 f3 ff ff       	jmp    8010568d <alltraps>

801062ca <vector163>:
.globl vector163
vector163:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $163
801062cc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062d1:	e9 b7 f3 ff ff       	jmp    8010568d <alltraps>

801062d6 <vector164>:
.globl vector164
vector164:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $164
801062d8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062dd:	e9 ab f3 ff ff       	jmp    8010568d <alltraps>

801062e2 <vector165>:
.globl vector165
vector165:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $165
801062e4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062e9:	e9 9f f3 ff ff       	jmp    8010568d <alltraps>

801062ee <vector166>:
.globl vector166
vector166:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $166
801062f0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062f5:	e9 93 f3 ff ff       	jmp    8010568d <alltraps>

801062fa <vector167>:
.globl vector167
vector167:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $167
801062fc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106301:	e9 87 f3 ff ff       	jmp    8010568d <alltraps>

80106306 <vector168>:
.globl vector168
vector168:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $168
80106308:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010630d:	e9 7b f3 ff ff       	jmp    8010568d <alltraps>

80106312 <vector169>:
.globl vector169
vector169:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $169
80106314:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106319:	e9 6f f3 ff ff       	jmp    8010568d <alltraps>

8010631e <vector170>:
.globl vector170
vector170:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $170
80106320:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106325:	e9 63 f3 ff ff       	jmp    8010568d <alltraps>

8010632a <vector171>:
.globl vector171
vector171:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $171
8010632c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106331:	e9 57 f3 ff ff       	jmp    8010568d <alltraps>

80106336 <vector172>:
.globl vector172
vector172:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $172
80106338:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010633d:	e9 4b f3 ff ff       	jmp    8010568d <alltraps>

80106342 <vector173>:
.globl vector173
vector173:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $173
80106344:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106349:	e9 3f f3 ff ff       	jmp    8010568d <alltraps>

8010634e <vector174>:
.globl vector174
vector174:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $174
80106350:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106355:	e9 33 f3 ff ff       	jmp    8010568d <alltraps>

8010635a <vector175>:
.globl vector175
vector175:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $175
8010635c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106361:	e9 27 f3 ff ff       	jmp    8010568d <alltraps>

80106366 <vector176>:
.globl vector176
vector176:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $176
80106368:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010636d:	e9 1b f3 ff ff       	jmp    8010568d <alltraps>

80106372 <vector177>:
.globl vector177
vector177:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $177
80106374:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106379:	e9 0f f3 ff ff       	jmp    8010568d <alltraps>

8010637e <vector178>:
.globl vector178
vector178:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $178
80106380:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106385:	e9 03 f3 ff ff       	jmp    8010568d <alltraps>

8010638a <vector179>:
.globl vector179
vector179:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $179
8010638c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106391:	e9 f7 f2 ff ff       	jmp    8010568d <alltraps>

80106396 <vector180>:
.globl vector180
vector180:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $180
80106398:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010639d:	e9 eb f2 ff ff       	jmp    8010568d <alltraps>

801063a2 <vector181>:
.globl vector181
vector181:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $181
801063a4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063a9:	e9 df f2 ff ff       	jmp    8010568d <alltraps>

801063ae <vector182>:
.globl vector182
vector182:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $182
801063b0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063b5:	e9 d3 f2 ff ff       	jmp    8010568d <alltraps>

801063ba <vector183>:
.globl vector183
vector183:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $183
801063bc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063c1:	e9 c7 f2 ff ff       	jmp    8010568d <alltraps>

801063c6 <vector184>:
.globl vector184
vector184:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $184
801063c8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063cd:	e9 bb f2 ff ff       	jmp    8010568d <alltraps>

801063d2 <vector185>:
.globl vector185
vector185:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $185
801063d4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063d9:	e9 af f2 ff ff       	jmp    8010568d <alltraps>

801063de <vector186>:
.globl vector186
vector186:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $186
801063e0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063e5:	e9 a3 f2 ff ff       	jmp    8010568d <alltraps>

801063ea <vector187>:
.globl vector187
vector187:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $187
801063ec:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063f1:	e9 97 f2 ff ff       	jmp    8010568d <alltraps>

801063f6 <vector188>:
.globl vector188
vector188:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $188
801063f8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063fd:	e9 8b f2 ff ff       	jmp    8010568d <alltraps>

80106402 <vector189>:
.globl vector189
vector189:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $189
80106404:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106409:	e9 7f f2 ff ff       	jmp    8010568d <alltraps>

8010640e <vector190>:
.globl vector190
vector190:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $190
80106410:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106415:	e9 73 f2 ff ff       	jmp    8010568d <alltraps>

8010641a <vector191>:
.globl vector191
vector191:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $191
8010641c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106421:	e9 67 f2 ff ff       	jmp    8010568d <alltraps>

80106426 <vector192>:
.globl vector192
vector192:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $192
80106428:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010642d:	e9 5b f2 ff ff       	jmp    8010568d <alltraps>

80106432 <vector193>:
.globl vector193
vector193:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $193
80106434:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106439:	e9 4f f2 ff ff       	jmp    8010568d <alltraps>

8010643e <vector194>:
.globl vector194
vector194:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $194
80106440:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106445:	e9 43 f2 ff ff       	jmp    8010568d <alltraps>

8010644a <vector195>:
.globl vector195
vector195:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $195
8010644c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106451:	e9 37 f2 ff ff       	jmp    8010568d <alltraps>

80106456 <vector196>:
.globl vector196
vector196:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $196
80106458:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010645d:	e9 2b f2 ff ff       	jmp    8010568d <alltraps>

80106462 <vector197>:
.globl vector197
vector197:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $197
80106464:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106469:	e9 1f f2 ff ff       	jmp    8010568d <alltraps>

8010646e <vector198>:
.globl vector198
vector198:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $198
80106470:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106475:	e9 13 f2 ff ff       	jmp    8010568d <alltraps>

8010647a <vector199>:
.globl vector199
vector199:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $199
8010647c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106481:	e9 07 f2 ff ff       	jmp    8010568d <alltraps>

80106486 <vector200>:
.globl vector200
vector200:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $200
80106488:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010648d:	e9 fb f1 ff ff       	jmp    8010568d <alltraps>

80106492 <vector201>:
.globl vector201
vector201:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $201
80106494:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106499:	e9 ef f1 ff ff       	jmp    8010568d <alltraps>

8010649e <vector202>:
.globl vector202
vector202:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $202
801064a0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064a5:	e9 e3 f1 ff ff       	jmp    8010568d <alltraps>

801064aa <vector203>:
.globl vector203
vector203:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $203
801064ac:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064b1:	e9 d7 f1 ff ff       	jmp    8010568d <alltraps>

801064b6 <vector204>:
.globl vector204
vector204:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $204
801064b8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064bd:	e9 cb f1 ff ff       	jmp    8010568d <alltraps>

801064c2 <vector205>:
.globl vector205
vector205:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $205
801064c4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064c9:	e9 bf f1 ff ff       	jmp    8010568d <alltraps>

801064ce <vector206>:
.globl vector206
vector206:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $206
801064d0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064d5:	e9 b3 f1 ff ff       	jmp    8010568d <alltraps>

801064da <vector207>:
.globl vector207
vector207:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $207
801064dc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064e1:	e9 a7 f1 ff ff       	jmp    8010568d <alltraps>

801064e6 <vector208>:
.globl vector208
vector208:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $208
801064e8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ed:	e9 9b f1 ff ff       	jmp    8010568d <alltraps>

801064f2 <vector209>:
.globl vector209
vector209:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $209
801064f4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064f9:	e9 8f f1 ff ff       	jmp    8010568d <alltraps>

801064fe <vector210>:
.globl vector210
vector210:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $210
80106500:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106505:	e9 83 f1 ff ff       	jmp    8010568d <alltraps>

8010650a <vector211>:
.globl vector211
vector211:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $211
8010650c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106511:	e9 77 f1 ff ff       	jmp    8010568d <alltraps>

80106516 <vector212>:
.globl vector212
vector212:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $212
80106518:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010651d:	e9 6b f1 ff ff       	jmp    8010568d <alltraps>

80106522 <vector213>:
.globl vector213
vector213:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $213
80106524:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106529:	e9 5f f1 ff ff       	jmp    8010568d <alltraps>

8010652e <vector214>:
.globl vector214
vector214:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $214
80106530:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106535:	e9 53 f1 ff ff       	jmp    8010568d <alltraps>

8010653a <vector215>:
.globl vector215
vector215:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $215
8010653c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106541:	e9 47 f1 ff ff       	jmp    8010568d <alltraps>

80106546 <vector216>:
.globl vector216
vector216:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $216
80106548:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010654d:	e9 3b f1 ff ff       	jmp    8010568d <alltraps>

80106552 <vector217>:
.globl vector217
vector217:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $217
80106554:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106559:	e9 2f f1 ff ff       	jmp    8010568d <alltraps>

8010655e <vector218>:
.globl vector218
vector218:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $218
80106560:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106565:	e9 23 f1 ff ff       	jmp    8010568d <alltraps>

8010656a <vector219>:
.globl vector219
vector219:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $219
8010656c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106571:	e9 17 f1 ff ff       	jmp    8010568d <alltraps>

80106576 <vector220>:
.globl vector220
vector220:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $220
80106578:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010657d:	e9 0b f1 ff ff       	jmp    8010568d <alltraps>

80106582 <vector221>:
.globl vector221
vector221:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $221
80106584:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106589:	e9 ff f0 ff ff       	jmp    8010568d <alltraps>

8010658e <vector222>:
.globl vector222
vector222:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $222
80106590:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106595:	e9 f3 f0 ff ff       	jmp    8010568d <alltraps>

8010659a <vector223>:
.globl vector223
vector223:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $223
8010659c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065a1:	e9 e7 f0 ff ff       	jmp    8010568d <alltraps>

801065a6 <vector224>:
.globl vector224
vector224:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $224
801065a8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ad:	e9 db f0 ff ff       	jmp    8010568d <alltraps>

801065b2 <vector225>:
.globl vector225
vector225:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $225
801065b4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065b9:	e9 cf f0 ff ff       	jmp    8010568d <alltraps>

801065be <vector226>:
.globl vector226
vector226:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $226
801065c0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065c5:	e9 c3 f0 ff ff       	jmp    8010568d <alltraps>

801065ca <vector227>:
.globl vector227
vector227:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $227
801065cc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065d1:	e9 b7 f0 ff ff       	jmp    8010568d <alltraps>

801065d6 <vector228>:
.globl vector228
vector228:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $228
801065d8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065dd:	e9 ab f0 ff ff       	jmp    8010568d <alltraps>

801065e2 <vector229>:
.globl vector229
vector229:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $229
801065e4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065e9:	e9 9f f0 ff ff       	jmp    8010568d <alltraps>

801065ee <vector230>:
.globl vector230
vector230:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $230
801065f0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065f5:	e9 93 f0 ff ff       	jmp    8010568d <alltraps>

801065fa <vector231>:
.globl vector231
vector231:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $231
801065fc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106601:	e9 87 f0 ff ff       	jmp    8010568d <alltraps>

80106606 <vector232>:
.globl vector232
vector232:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $232
80106608:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010660d:	e9 7b f0 ff ff       	jmp    8010568d <alltraps>

80106612 <vector233>:
.globl vector233
vector233:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $233
80106614:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106619:	e9 6f f0 ff ff       	jmp    8010568d <alltraps>

8010661e <vector234>:
.globl vector234
vector234:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $234
80106620:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106625:	e9 63 f0 ff ff       	jmp    8010568d <alltraps>

8010662a <vector235>:
.globl vector235
vector235:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $235
8010662c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106631:	e9 57 f0 ff ff       	jmp    8010568d <alltraps>

80106636 <vector236>:
.globl vector236
vector236:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $236
80106638:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010663d:	e9 4b f0 ff ff       	jmp    8010568d <alltraps>

80106642 <vector237>:
.globl vector237
vector237:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $237
80106644:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106649:	e9 3f f0 ff ff       	jmp    8010568d <alltraps>

8010664e <vector238>:
.globl vector238
vector238:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $238
80106650:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106655:	e9 33 f0 ff ff       	jmp    8010568d <alltraps>

8010665a <vector239>:
.globl vector239
vector239:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $239
8010665c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106661:	e9 27 f0 ff ff       	jmp    8010568d <alltraps>

80106666 <vector240>:
.globl vector240
vector240:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $240
80106668:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010666d:	e9 1b f0 ff ff       	jmp    8010568d <alltraps>

80106672 <vector241>:
.globl vector241
vector241:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $241
80106674:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106679:	e9 0f f0 ff ff       	jmp    8010568d <alltraps>

8010667e <vector242>:
.globl vector242
vector242:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $242
80106680:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106685:	e9 03 f0 ff ff       	jmp    8010568d <alltraps>

8010668a <vector243>:
.globl vector243
vector243:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $243
8010668c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106691:	e9 f7 ef ff ff       	jmp    8010568d <alltraps>

80106696 <vector244>:
.globl vector244
vector244:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $244
80106698:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010669d:	e9 eb ef ff ff       	jmp    8010568d <alltraps>

801066a2 <vector245>:
.globl vector245
vector245:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $245
801066a4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066a9:	e9 df ef ff ff       	jmp    8010568d <alltraps>

801066ae <vector246>:
.globl vector246
vector246:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $246
801066b0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066b5:	e9 d3 ef ff ff       	jmp    8010568d <alltraps>

801066ba <vector247>:
.globl vector247
vector247:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $247
801066bc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066c1:	e9 c7 ef ff ff       	jmp    8010568d <alltraps>

801066c6 <vector248>:
.globl vector248
vector248:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $248
801066c8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066cd:	e9 bb ef ff ff       	jmp    8010568d <alltraps>

801066d2 <vector249>:
.globl vector249
vector249:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $249
801066d4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066d9:	e9 af ef ff ff       	jmp    8010568d <alltraps>

801066de <vector250>:
.globl vector250
vector250:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $250
801066e0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066e5:	e9 a3 ef ff ff       	jmp    8010568d <alltraps>

801066ea <vector251>:
.globl vector251
vector251:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $251
801066ec:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066f1:	e9 97 ef ff ff       	jmp    8010568d <alltraps>

801066f6 <vector252>:
.globl vector252
vector252:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $252
801066f8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066fd:	e9 8b ef ff ff       	jmp    8010568d <alltraps>

80106702 <vector253>:
.globl vector253
vector253:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $253
80106704:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106709:	e9 7f ef ff ff       	jmp    8010568d <alltraps>

8010670e <vector254>:
.globl vector254
vector254:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $254
80106710:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106715:	e9 73 ef ff ff       	jmp    8010568d <alltraps>

8010671a <vector255>:
.globl vector255
vector255:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $255
8010671c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106721:	e9 67 ef ff ff       	jmp    8010568d <alltraps>
80106726:	66 90                	xchg   %ax,%ax
80106728:	66 90                	xchg   %ax,%ax
8010672a:	66 90                	xchg   %ax,%ax
8010672c:	66 90                	xchg   %ax,%ax
8010672e:	66 90                	xchg   %ax,%ax

80106730 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106736:	e8 05 d0 ff ff       	call   80103740 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010673b:	31 c9                	xor    %ecx,%ecx
8010673d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106742:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106748:	05 80 37 11 80       	add    $0x80113780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010674d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106751:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106756:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106759:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010675d:	31 c9                	xor    %ecx,%ecx
8010675f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106763:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106768:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010676c:	31 c9                	xor    %ecx,%ecx
8010676e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106772:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106777:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010677b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010677d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106781:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106785:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106789:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010678d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106791:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106795:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106799:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010679d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067a1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067a6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801067aa:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067ae:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801067b2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067b6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801067ba:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067be:	66 89 48 22          	mov    %cx,0x22(%eax)
801067c2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801067c6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801067ca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801067ce:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067d2:	c1 e8 10             	shr    $0x10,%eax
801067d5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801067d9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801067dc:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801067df:	c9                   	leave  
801067e0:	c3                   	ret    
801067e1:	eb 0d                	jmp    801067f0 <walkpgdir>
801067e3:	90                   	nop
801067e4:	90                   	nop
801067e5:	90                   	nop
801067e6:	90                   	nop
801067e7:	90                   	nop
801067e8:	90                   	nop
801067e9:	90                   	nop
801067ea:	90                   	nop
801067eb:	90                   	nop
801067ec:	90                   	nop
801067ed:	90                   	nop
801067ee:	90                   	nop
801067ef:	90                   	nop

801067f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
801067f6:	83 ec 1c             	sub    $0x1c,%esp
801067f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801067fc:	8b 55 08             	mov    0x8(%ebp),%edx
801067ff:	89 fb                	mov    %edi,%ebx
80106801:	c1 eb 16             	shr    $0x16,%ebx
80106804:	8d 1c 9a             	lea    (%edx,%ebx,4),%ebx
  if(*pde & PTE_P){
80106807:	8b 33                	mov    (%ebx),%esi
80106809:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010680f:	74 27                	je     80106838 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106811:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106817:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010681d:	89 fa                	mov    %edi,%edx
}
8010681f:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106822:	c1 ea 0a             	shr    $0xa,%edx
80106825:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
}
8010682b:	5b                   	pop    %ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010682c:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
8010682f:	5e                   	pop    %esi
80106830:	5f                   	pop    %edi
80106831:	5d                   	pop    %ebp
80106832:	c3                   	ret    
80106833:	90                   	nop
80106834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106838:	8b 45 10             	mov    0x10(%ebp),%eax
8010683b:	85 c0                	test   %eax,%eax
8010683d:	74 31                	je     80106870 <walkpgdir+0x80>
8010683f:	e8 cc bc ff ff       	call   80102510 <kalloc>
80106844:	85 c0                	test   %eax,%eax
80106846:	89 c6                	mov    %eax,%esi
80106848:	74 26                	je     80106870 <walkpgdir+0x80>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010684a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106851:	00 
80106852:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106859:	00 
8010685a:	89 04 24             	mov    %eax,(%esp)
8010685d:	e8 3e dc ff ff       	call   801044a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106862:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106868:	83 c8 07             	or     $0x7,%eax
8010686b:	89 03                	mov    %eax,(%ebx)
8010686d:	eb ae                	jmp    8010681d <walkpgdir+0x2d>
8010686f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106870:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106873:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106875:	5b                   	pop    %ebx
80106876:	5e                   	pop    %esi
80106877:	5f                   	pop    %edi
80106878:	5d                   	pop    %ebp
80106879:	c3                   	ret    
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106887:	8d b9 ff 0f 00 00    	lea    0xfff(%ecx),%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010688d:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010688e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106894:	83 ec 2c             	sub    $0x2c,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106897:	39 d7                	cmp    %edx,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106899:	89 d3                	mov    %edx,%ebx
8010689b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010689e:	72 3b                	jb     801068db <deallocuvm.part.0+0x5b>
801068a0:	eb 6e                	jmp    80106910 <deallocuvm.part.0+0x90>
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801068a8:	8b 08                	mov    (%eax),%ecx
801068aa:	f6 c1 01             	test   $0x1,%cl
801068ad:	74 22                	je     801068d1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068af:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801068b5:	74 64                	je     8010691b <deallocuvm.part.0+0x9b>
        panic("kfree");
      char *v = P2V(pa);
801068b7:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
      kfree(v);
801068bd:	89 0c 24             	mov    %ecx,(%esp)
801068c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068c3:	e8 98 ba ff ff       	call   80102360 <kfree>
      *pte = 0;
801068c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068d1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801068d7:	39 df                	cmp    %ebx,%edi
801068d9:	73 35                	jae    80106910 <deallocuvm.part.0+0x90>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801068e2:	00 
801068e3:	89 7c 24 04          	mov    %edi,0x4(%esp)
801068e7:	89 34 24             	mov    %esi,(%esp)
801068ea:	e8 01 ff ff ff       	call   801067f0 <walkpgdir>
    if(!pte)
801068ef:	85 c0                	test   %eax,%eax
801068f1:	75 b5                	jne    801068a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068f3:	89 fa                	mov    %edi,%edx
801068f5:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801068fb:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106901:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106907:	39 df                	cmp    %ebx,%edi
80106909:	72 d0                	jb     801068db <deallocuvm.part.0+0x5b>
8010690b:	90                   	nop
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106910:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106913:	83 c4 2c             	add    $0x2c,%esp
80106916:	5b                   	pop    %ebx
80106917:	5e                   	pop    %esi
80106918:	5f                   	pop    %edi
80106919:	5d                   	pop    %ebp
8010691a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010691b:	c7 04 24 52 7b 10 80 	movl   $0x80107b52,(%esp)
80106922:	e8 39 9a ff ff       	call   80100360 <panic>
80106927:	89 f6                	mov    %esi,%esi
80106929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106930 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
80106936:	83 ec 1c             	sub    $0x1c,%esp
80106939:	8b 45 0c             	mov    0xc(%ebp),%eax
8010693c:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010693f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106942:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106946:	89 c7                	mov    %eax,%edi
80106948:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010694e:	29 fe                	sub    %edi,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106950:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106954:	89 75 14             	mov    %esi,0x14(%ebp)
80106957:	89 fe                	mov    %edi,%esi
80106959:	8b 7d 14             	mov    0x14(%ebp),%edi
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010695c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010695f:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106966:	eb 15                	jmp    8010697d <mappages+0x4d>
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106968:	f6 00 01             	testb  $0x1,(%eax)
8010696b:	75 45                	jne    801069b2 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010696d:	0b 5d 18             	or     0x18(%ebp),%ebx
    if(a == last)
80106970:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106973:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106975:	74 31                	je     801069a8 <mappages+0x78>
      break;
    a += PGSIZE;
80106977:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010697d:	8b 45 08             	mov    0x8(%ebp),%eax
80106980:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106983:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010698a:	00 
8010698b:	89 74 24 04          	mov    %esi,0x4(%esp)
8010698f:	89 04 24             	mov    %eax,(%esp)
80106992:	e8 59 fe ff ff       	call   801067f0 <walkpgdir>
80106997:	85 c0                	test   %eax,%eax
80106999:	75 cd                	jne    80106968 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010699b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010699e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801069a3:	5b                   	pop    %ebx
801069a4:	5e                   	pop    %esi
801069a5:	5f                   	pop    %edi
801069a6:	5d                   	pop    %ebp
801069a7:	c3                   	ret    
801069a8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801069ab:	31 c0                	xor    %eax,%eax
}
801069ad:	5b                   	pop    %ebx
801069ae:	5e                   	pop    %esi
801069af:	5f                   	pop    %edi
801069b0:	5d                   	pop    %ebp
801069b1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801069b2:	c7 04 24 48 83 10 80 	movl   $0x80108348,(%esp)
801069b9:	e8 a2 99 ff ff       	call   80100360 <panic>
801069be:	66 90                	xchg   %ax,%ax

801069c0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069c0:	a1 a4 6d 11 80       	mov    0x80116da4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069c5:	55                   	push   %ebp
801069c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069cd:	0f 22 d8             	mov    %eax,%cr3
}
801069d0:	5d                   	pop    %ebp
801069d1:	c3                   	ret    
801069d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
801069e6:	83 ec 1c             	sub    $0x1c,%esp
801069e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069ec:	85 f6                	test   %esi,%esi
801069ee:	0f 84 cd 00 00 00    	je     80106ac1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801069f4:	8b 46 08             	mov    0x8(%esi),%eax
801069f7:	85 c0                	test   %eax,%eax
801069f9:	0f 84 da 00 00 00    	je     80106ad9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801069ff:	8b 7e 04             	mov    0x4(%esi),%edi
80106a02:	85 ff                	test   %edi,%edi
80106a04:	0f 84 c3 00 00 00    	je     80106acd <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
80106a0a:	e8 11 d9 ff ff       	call   80104320 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a0f:	e8 ac cc ff ff       	call   801036c0 <mycpu>
80106a14:	89 c3                	mov    %eax,%ebx
80106a16:	e8 a5 cc ff ff       	call   801036c0 <mycpu>
80106a1b:	89 c7                	mov    %eax,%edi
80106a1d:	e8 9e cc ff ff       	call   801036c0 <mycpu>
80106a22:	83 c7 08             	add    $0x8,%edi
80106a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a28:	e8 93 cc ff ff       	call   801036c0 <mycpu>
80106a2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a30:	ba 67 00 00 00       	mov    $0x67,%edx
80106a35:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a3c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a43:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a4a:	83 c1 08             	add    $0x8,%ecx
80106a4d:	c1 e9 10             	shr    $0x10,%ecx
80106a50:	83 c0 08             	add    $0x8,%eax
80106a53:	c1 e8 18             	shr    $0x18,%eax
80106a56:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106a5c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a63:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a69:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106a6e:	e8 4d cc ff ff       	call   801036c0 <mycpu>
80106a73:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a7a:	e8 41 cc ff ff       	call   801036c0 <mycpu>
80106a7f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106a84:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a88:	e8 33 cc ff ff       	call   801036c0 <mycpu>
80106a8d:	8b 56 08             	mov    0x8(%esi),%edx
80106a90:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106a96:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a99:	e8 22 cc ff ff       	call   801036c0 <mycpu>
80106a9e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106aa2:	b8 28 00 00 00       	mov    $0x28,%eax
80106aa7:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106aaa:	8b 46 04             	mov    0x4(%esi),%eax
80106aad:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ab2:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106ab5:	83 c4 1c             	add    $0x1c,%esp
80106ab8:	5b                   	pop    %ebx
80106ab9:	5e                   	pop    %esi
80106aba:	5f                   	pop    %edi
80106abb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106abc:	e9 1f d9 ff ff       	jmp    801043e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106ac1:	c7 04 24 4e 83 10 80 	movl   $0x8010834e,(%esp)
80106ac8:	e8 93 98 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106acd:	c7 04 24 79 83 10 80 	movl   $0x80108379,(%esp)
80106ad4:	e8 87 98 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106ad9:	c7 04 24 64 83 10 80 	movl   $0x80108364,(%esp)
80106ae0:	e8 7b 98 ff ff       	call   80100360 <panic>
80106ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 2c             	sub    $0x2c,%esp
80106af9:	8b 75 10             	mov    0x10(%ebp),%esi
80106afc:	8b 55 08             	mov    0x8(%ebp),%edx
80106aff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106b02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b08:	77 64                	ja     80106b6e <inituvm+0x7e>
80106b0a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
80106b0d:	e8 fe b9 ff ff       	call   80102510 <kalloc>
  memset(mem, 0, PGSIZE);
80106b12:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b19:	00 
80106b1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b21:	00 
80106b22:	89 04 24             	mov    %eax,(%esp)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106b25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b27:	e8 74 d9 ff ff       	call   801044a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b35:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106b3c:	00 
80106b3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b41:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b48:	00 
80106b49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b50:	00 
80106b51:	89 14 24             	mov    %edx,(%esp)
80106b54:	e8 d7 fd ff ff       	call   80106930 <mappages>
  memmove(mem, init, sz);
80106b59:	89 75 10             	mov    %esi,0x10(%ebp)
80106b5c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b62:	83 c4 2c             	add    $0x2c,%esp
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b69:	e9 d2 d9 ff ff       	jmp    80104540 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b6e:	c7 04 24 8d 83 10 80 	movl   $0x8010838d,(%esp)
80106b75:	e8 e6 97 ff ff       	call   80100360 <panic>
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b80 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b90:	0f 85 a0 00 00 00    	jne    80106c36 <loaduvm+0xb6>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b96:	8b 75 18             	mov    0x18(%ebp),%esi
80106b99:	31 db                	xor    %ebx,%ebx
80106b9b:	85 f6                	test   %esi,%esi
80106b9d:	75 1a                	jne    80106bb9 <loaduvm+0x39>
80106b9f:	eb 7f                	jmp    80106c20 <loaduvm+0xa0>
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106bb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106bb7:	76 67                	jbe    80106c20 <loaduvm+0xa0>
80106bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106bbc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106bc3:	00 
80106bc4:	01 d8                	add    %ebx,%eax
80106bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bca:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcd:	89 04 24             	mov    %eax,(%esp)
80106bd0:	e8 1b fc ff ff       	call   801067f0 <walkpgdir>
80106bd5:	85 c0                	test   %eax,%eax
80106bd7:	74 51                	je     80106c2a <loaduvm+0xaa>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106bd9:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106bdb:	bf 00 10 00 00       	mov    $0x1000,%edi
80106be0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106be8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106bee:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bf1:	05 00 00 00 80       	add    $0x80000000,%eax
80106bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bfa:	8b 45 10             	mov    0x10(%ebp),%eax
80106bfd:	01 d9                	add    %ebx,%ecx
80106bff:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106c07:	89 04 24             	mov    %eax,(%esp)
80106c0a:	e8 c1 ad ff ff       	call   801019d0 <readi>
80106c0f:	39 f8                	cmp    %edi,%eax
80106c11:	74 95                	je     80106ba8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106c13:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106c1b:	5b                   	pop    %ebx
80106c1c:	5e                   	pop    %esi
80106c1d:	5f                   	pop    %edi
80106c1e:	5d                   	pop    %ebp
80106c1f:	c3                   	ret    
80106c20:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106c23:	31 c0                	xor    %eax,%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106c2a:	c7 04 24 a7 83 10 80 	movl   $0x801083a7,(%esp)
80106c31:	e8 2a 97 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106c36:	c7 04 24 54 84 10 80 	movl   $0x80108454,(%esp)
80106c3d:	e8 1e 97 ff ff       	call   80100360 <panic>
80106c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 2c             	sub    $0x2c,%esp
80106c59:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz > USEREND)
80106c5c:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
80106c62:	0f 87 98 00 00 00    	ja     80106d00 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
80106c68:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz > USEREND)
    return 0;
  if(newsz < oldsz)
80106c6e:	0f 82 8e 00 00 00    	jb     80106d02 <allocuvm+0xb2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c74:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c7a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c80:	39 df                	cmp    %ebx,%edi
80106c82:	77 5b                	ja     80106cdf <allocuvm+0x8f>
80106c84:	e9 87 00 00 00       	jmp    80106d10 <allocuvm+0xc0>
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c97:	00 
80106c98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c9f:	00 
80106ca0:	89 04 24             	mov    %eax,(%esp)
80106ca3:	e8 f8 d7 ff ff       	call   801044a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ca8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106cae:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106cbc:	00 
80106cbd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cc4:	00 
80106cc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106cc9:	89 04 24             	mov    %eax,(%esp)
80106ccc:	e8 5f fc ff ff       	call   80106930 <mappages>
80106cd1:	85 c0                	test   %eax,%eax
80106cd3:	78 4b                	js     80106d20 <allocuvm+0xd0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106cd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cdb:	39 df                	cmp    %ebx,%edi
80106cdd:	76 31                	jbe    80106d10 <allocuvm+0xc0>
    mem = kalloc();
80106cdf:	e8 2c b8 ff ff       	call   80102510 <kalloc>
    if(mem == 0){
80106ce4:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106ce6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ce8:	75 a6                	jne    80106c90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106cea:	c7 04 24 c5 83 10 80 	movl   $0x801083c5,(%esp)
80106cf1:	e8 5a 99 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cf6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cf9:	77 55                	ja     80106d50 <allocuvm+0x100>
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106d00:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d02:	83 c4 2c             	add    $0x2c,%esp
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d10:	83 c4 2c             	add    $0x2c,%esp
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80106d13:	89 f8                	mov    %edi,%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106d20:	c7 04 24 dd 83 10 80 	movl   $0x801083dd,(%esp)
80106d27:	e8 24 99 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d2c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d2f:	76 0d                	jbe    80106d3e <allocuvm+0xee>
80106d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d34:	89 fa                	mov    %edi,%edx
80106d36:	8b 45 08             	mov    0x8(%ebp),%eax
80106d39:	e8 42 fb ff ff       	call   80106880 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106d3e:	89 34 24             	mov    %esi,(%esp)
80106d41:	e8 1a b6 ff ff       	call   80102360 <kfree>
      return 0;
    }
  }
  return newsz;
}
80106d46:	83 c4 2c             	add    $0x2c,%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106d49:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106d4b:	5b                   	pop    %ebx
80106d4c:	5e                   	pop    %esi
80106d4d:	5f                   	pop    %edi
80106d4e:	5d                   	pop    %ebp
80106d4f:	c3                   	ret    
80106d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d53:	89 fa                	mov    %edi,%edx
80106d55:	8b 45 08             	mov    0x8(%ebp),%eax
80106d58:	e8 23 fb ff ff       	call   80106880 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106d5d:	31 c0                	xor    %eax,%eax
80106d5f:	eb a1                	jmp    80106d02 <allocuvm+0xb2>
80106d61:	eb 0d                	jmp    80106d70 <allocshm>
80106d63:	90                   	nop
80106d64:	90                   	nop
80106d65:	90                   	nop
80106d66:	90                   	nop
80106d67:	90                   	nop
80106d68:	90                   	nop
80106d69:	90                   	nop
80106d6a:	90                   	nop
80106d6b:	90                   	nop
80106d6c:	90                   	nop
80106d6d:	90                   	nop
80106d6e:	90                   	nop
80106d6f:	90                   	nop

80106d70 <allocshm>:
  return newsz;
}

int
allocshm(pde_t *pgdir, char *frame)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 2c             	sub    $0x2c,%esp
	struct proc *curproc = myproc();
80106d79:	e8 e2 c9 ff ff       	call   80103760 <myproc>
80106d7e:	89 c6                	mov    %eax,%esi
	uint sz = PGROUNDUP(curproc->sz);
80106d80:	8b 00                	mov    (%eax),%eax
80106d82:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106d8e:	8d 8b 00 20 00 00    	lea    0x2000(%ebx),%ecx
80106d94:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106d97:	0f 87 ab 00 00 00    	ja     80106e48 <allocshm+0xd8>
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
80106d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106da0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106da7:	00 
80106da8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106dac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106daf:	89 04 24             	mov    %eax,(%esp)
80106db2:	e8 39 fa ff ff       	call   801067f0 <walkpgdir>
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106db7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dba:	f6 00 01             	testb  $0x1,(%eax)
80106dbd:	0f 84 92 00 00 00    	je     80106e55 <allocshm+0xe5>
80106dc3:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106dc6:	76 15                	jbe    80106ddd <allocshm+0x6d>
80106dc8:	eb 7e                	jmp    80106e48 <allocshm+0xd8>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dd0:	81 c3 00 30 00 00    	add    $0x3000,%ebx
80106dd6:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
80106dd9:	72 6d                	jb     80106e48 <allocshm+0xd8>
		sz+=PGSIZE;
80106ddb:	89 fb                	mov    %edi,%ebx
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106ddd:	8b 45 08             	mov    0x8(%ebp),%eax
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
80106de0:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106de6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ded:	00 
80106dee:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106df2:	89 04 24             	mov    %eax,(%esp)
80106df5:	e8 f6 f9 ff ff       	call   801067f0 <walkpgdir>
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106dfa:	f6 00 01             	testb  $0x1,(%eax)
80106dfd:	75 d1                	jne    80106dd0 <allocshm+0x60>
80106dff:	8d 8b 00 30 00 00    	lea    0x3000(%ebx),%ecx
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106e05:	39 4e 7c             	cmp    %ecx,0x7c(%esi)
80106e08:	72 3e                	jb     80106e48 <allocshm+0xd8>
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
80106e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e0d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106e14:	00 
80106e15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e1c:	00 
80106e1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106e21:	05 00 00 00 80       	add    $0x80000000,%eax
80106e26:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2d:	89 04 24             	mov    %eax,(%esp)
80106e30:	e8 fb fa ff ff       	call   80106930 <mappages>
80106e35:	85 c0                	test   %eax,%eax
80106e37:	78 20                	js     80106e59 <allocshm+0xe9>
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106e39:	83 c4 2c             	add    $0x2c,%esp
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
80106e3c:	89 f8                	mov    %edi,%eax
}
80106e3e:	5b                   	pop    %ebx
80106e3f:	5e                   	pop    %esi
80106e40:	5f                   	pop    %edi
80106e41:	5d                   	pop    %ebp
80106e42:	c3                   	ret    
80106e43:	90                   	nop
80106e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106e4d:	83 c4 2c             	add    $0x2c,%esp
80106e50:	5b                   	pop    %ebx
80106e51:	5e                   	pop    %esi
80106e52:	5f                   	pop    %edi
80106e53:	5d                   	pop    %ebp
80106e54:	c3                   	ret    

int
allocshm(pde_t *pgdir, char *frame)
{
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
80106e55:	89 df                	mov    %ebx,%edi
80106e57:	eb ac                	jmp    80106e05 <allocshm+0x95>
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
80106e59:	c7 04 24 c5 83 10 80 	movl   $0x801083c5,(%esp)
80106e60:	e8 eb 97 ff ff       	call   80100650 <cprintf>
		return -1;
80106e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e6a:	eb e1                	jmp    80106e4d <allocshm+0xdd>
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e70 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 08                	jae    80106e88 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e80:	5d                   	pop    %ebp
80106e81:	e9 fa f9 ff ff       	jmp    80106880 <deallocuvm.part.0>
80106e86:	66 90                	xchg   %ax,%ax
80106e88:	89 d0                	mov    %edx,%eax
80106e8a:	5d                   	pop    %ebp
80106e8b:	c3                   	ret    
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	56                   	push   %esi
80106e94:	53                   	push   %ebx
80106e95:	83 ec 10             	sub    $0x10,%esp
80106e98:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e9b:	85 f6                	test   %esi,%esi
80106e9d:	74 59                	je     80106ef8 <freevm+0x68>
80106e9f:	31 c9                	xor    %ecx,%ecx
80106ea1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ea6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ea8:	31 db                	xor    %ebx,%ebx
80106eaa:	e8 d1 f9 ff ff       	call   80106880 <deallocuvm.part.0>
80106eaf:	eb 12                	jmp    80106ec3 <freevm+0x33>
80106eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eb8:	83 c3 01             	add    $0x1,%ebx
80106ebb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106ec1:	74 27                	je     80106eea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ec3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106ec6:	f6 c2 01             	test   $0x1,%dl
80106ec9:	74 ed                	je     80106eb8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ecb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ed1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ed4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106eda:	89 14 24             	mov    %edx,(%esp)
80106edd:	e8 7e b4 ff ff       	call   80102360 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ee2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106ee8:	75 d9                	jne    80106ec3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106eea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106eed:	83 c4 10             	add    $0x10,%esp
80106ef0:	5b                   	pop    %ebx
80106ef1:	5e                   	pop    %esi
80106ef2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ef3:	e9 68 b4 ff ff       	jmp    80102360 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ef8:	c7 04 24 f9 83 10 80 	movl   $0x801083f9,(%esp)
80106eff:	e8 5c 94 ff ff       	call   80100360 <panic>
80106f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f10 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	56                   	push   %esi
80106f14:	53                   	push   %ebx
80106f15:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106f18:	e8 f3 b5 ff ff       	call   80102510 <kalloc>
80106f1d:	85 c0                	test   %eax,%eax
80106f1f:	89 c6                	mov    %eax,%esi
80106f21:	74 75                	je     80106f98 <setupkvm+0x88>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106f23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f2a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f2b:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106f30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f37:	00 
80106f38:	89 04 24             	mov    %eax,(%esp)
80106f3b:	e8 60 d5 ff ff       	call   801044a0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f40:	8b 53 0c             	mov    0xc(%ebx),%edx
80106f43:	8b 43 04             	mov    0x4(%ebx),%eax
80106f46:	89 34 24             	mov    %esi,(%esp)
80106f49:	89 54 24 10          	mov    %edx,0x10(%esp)
80106f4d:	8b 53 08             	mov    0x8(%ebx),%edx
80106f50:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106f54:	29 c2                	sub    %eax,%edx
80106f56:	8b 03                	mov    (%ebx),%eax
80106f58:	89 54 24 08          	mov    %edx,0x8(%esp)
80106f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f60:	e8 cb f9 ff ff       	call   80106930 <mappages>
80106f65:	85 c0                	test   %eax,%eax
80106f67:	78 17                	js     80106f80 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f69:	83 c3 10             	add    $0x10,%ebx
80106f6c:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106f72:	72 cc                	jb     80106f40 <setupkvm+0x30>
80106f74:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106f76:	83 c4 20             	add    $0x20,%esp
80106f79:	5b                   	pop    %ebx
80106f7a:	5e                   	pop    %esi
80106f7b:	5d                   	pop    %ebp
80106f7c:	c3                   	ret    
80106f7d:	8d 76 00             	lea    0x0(%esi),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106f80:	89 34 24             	mov    %esi,(%esp)
80106f83:	e8 08 ff ff ff       	call   80106e90 <freevm>
      return 0;
    }
  return pgdir;
}
80106f88:	83 c4 20             	add    $0x20,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106f8b:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5d                   	pop    %ebp
80106f90:	c3                   	ret    
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106f98:	31 c0                	xor    %eax,%eax
80106f9a:	eb da                	jmp    80106f76 <setupkvm+0x66>
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fa6:	e8 65 ff ff ff       	call   80106f10 <setupkvm>
80106fab:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106fd0:	00 
80106fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd8:	89 04 24             	mov    %eax,(%esp)
80106fdb:	e8 10 f8 ff ff       	call   801067f0 <walkpgdir>
  if(pte == 0)
80106fe0:	85 c0                	test   %eax,%eax
80106fe2:	74 05                	je     80106fe9 <clearpteu+0x29>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106fe4:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fe7:	c9                   	leave  
80106fe8:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106fe9:	c7 04 24 0a 84 10 80 	movl   $0x8010840a,(%esp)
80106ff0:	e8 6b 93 ff ff       	call   80100360 <panic>
80106ff5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <resetpteu>:
  *pte &= ~PTE_U;
}

void
resetpteu(pde_t *pgdir, char *uva)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107006:	8b 45 0c             	mov    0xc(%ebp),%eax
80107009:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107010:	00 
80107011:	89 44 24 04          	mov    %eax,0x4(%esp)
80107015:	8b 45 08             	mov    0x8(%ebp),%eax
80107018:	89 04 24             	mov    %eax,(%esp)
8010701b:	e8 d0 f7 ff ff       	call   801067f0 <walkpgdir>
  if(pte == 0)
80107020:	85 c0                	test   %eax,%eax
80107022:	74 05                	je     80107029 <resetpteu+0x29>
    panic("resetpteu");
  *pte &= PTE_U;
80107024:	83 20 04             	andl   $0x4,(%eax)
}
80107027:	c9                   	leave  
80107028:	c3                   	ret    
resetpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("resetpteu");
80107029:	c7 04 24 14 84 10 80 	movl   $0x80108414,(%esp)
80107030:	e8 2b 93 ff ff       	call   80100360 <panic>
80107035:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <copyuvm>:
}
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)// FOR CS153 lab2 part1
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
	struct proc *curproc = myproc();
80107049:	e8 12 c7 ff ff       	call   80103760 <myproc>
8010704e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if((d = setupkvm()) == 0)
80107051:	e8 ba fe ff ff       	call   80106f10 <setupkvm>
80107056:	85 c0                	test   %eax,%eax
80107058:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010705b:	0f 84 85 01 00 00    	je     801071e6 <copyuvm+0x1a6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107061:	8b 45 0c             	mov    0xc(%ebp),%eax
80107064:	85 c0                	test   %eax,%eax
80107066:	0f 84 bc 00 00 00    	je     80107128 <copyuvm+0xe8>
8010706c:	31 db                	xor    %ebx,%ebx
8010706e:	eb 51                	jmp    801070c1 <copyuvm+0x81>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107070:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107076:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010707d:	00 
8010707e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80107082:	89 04 24             	mov    %eax,(%esp)
80107085:	e8 b6 d4 ff ff       	call   80104540 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010708a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80107093:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107097:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010709e:	00 
8010709f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801070a3:	89 44 24 10          	mov    %eax,0x10(%esp)
801070a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070aa:	89 04 24             	mov    %eax,(%esp)
801070ad:	e8 7e f8 ff ff       	call   80106930 <mappages>
801070b2:	85 c0                	test   %eax,%eax
801070b4:	78 58                	js     8010710e <copyuvm+0xce>
  uint pa, i, flags;
  char *mem;
	struct proc *curproc = myproc();
  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070bc:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801070bf:	76 67                	jbe    80107128 <copyuvm+0xe8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070c1:	8b 45 08             	mov    0x8(%ebp),%eax
801070c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801070cb:	00 
801070cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801070d0:	89 04 24             	mov    %eax,(%esp)
801070d3:	e8 18 f7 ff ff       	call   801067f0 <walkpgdir>
801070d8:	85 c0                	test   %eax,%eax
801070da:	0f 84 19 01 00 00    	je     801071f9 <copyuvm+0x1b9>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801070e0:	8b 30                	mov    (%eax),%esi
801070e2:	f7 c6 01 00 00 00    	test   $0x1,%esi
801070e8:	0f 84 ff 00 00 00    	je     801071ed <copyuvm+0x1ad>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070ee:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
801070f0:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801070f6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070f9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801070ff:	e8 0c b4 ff ff       	call   80102510 <kalloc>
80107104:	85 c0                	test   %eax,%eax
80107106:	89 c6                	mov    %eax,%esi
80107108:	0f 85 62 ff ff ff    	jne    80107070 <copyuvm+0x30>
      goto bad;
	}
  return d;

bad:
  freevm(d);
8010710e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107111:	89 04 24             	mov    %eax,(%esp)
80107114:	e8 77 fd ff ff       	call   80106e90 <freevm>
  return 0;
80107119:	31 c0                	xor    %eax,%eax
}
8010711b:	83 c4 2c             	add    $0x2c,%esp
8010711e:	5b                   	pop    %ebx
8010711f:	5e                   	pop    %esi
80107120:	5f                   	pop    %edi
80107121:	5d                   	pop    %ebp
80107122:	c3                   	ret    
80107123:	90                   	nop
80107124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (curproc->tstack == 0 || curproc->tstack >= USEREND) return d; // For CS153 lab2 part1
80107128:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010712b:	8b 58 7c             	mov    0x7c(%eax),%ebx
  for(i = curproc->tstack; i < USEREND-PGSIZE; i += PGSIZE){
8010712e:	8d 43 ff             	lea    -0x1(%ebx),%eax
80107131:	3d fe ef ff 7f       	cmp    $0x7fffeffe,%eax
80107136:	76 5c                	jbe    80107194 <copyuvm+0x154>
80107138:	e9 a1 00 00 00       	jmp    801071de <copyuvm+0x19e>
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107140:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107146:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010714d:	00 
8010714e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80107152:	89 04 24             	mov    %eax,(%esp)
80107155:	e8 e6 d3 ff ff       	call   80104540 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010715a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010715d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80107163:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107167:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010716e:	00 
8010716f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80107173:	89 44 24 10          	mov    %eax,0x10(%esp)
80107177:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010717a:	89 04 24             	mov    %eax,(%esp)
8010717d:	e8 ae f7 ff ff       	call   80106930 <mappages>
80107182:	85 c0                	test   %eax,%eax
80107184:	78 88                	js     8010710e <copyuvm+0xce>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (curproc->tstack == 0 || curproc->tstack >= USEREND) return d; // For CS153 lab2 part1
  for(i = curproc->tstack; i < USEREND-PGSIZE; i += PGSIZE){
80107186:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718c:	81 fb ff ef ff 7f    	cmp    $0x7fffefff,%ebx
80107192:	77 4a                	ja     801071de <copyuvm+0x19e>
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
80107194:	8b 45 08             	mov    0x8(%ebp),%eax
80107197:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010719e:	00 
8010719f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801071a3:	89 04 24             	mov    %eax,(%esp)
801071a6:	e8 45 f6 ff ff       	call   801067f0 <walkpgdir>
801071ab:	85 c0                	test   %eax,%eax
801071ad:	74 4a                	je     801071f9 <copyuvm+0x1b9>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801071af:	8b 30                	mov    (%eax),%esi
801071b1:	f7 c6 01 00 00 00    	test   $0x1,%esi
801071b7:	74 34                	je     801071ed <copyuvm+0x1ad>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071b9:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
801071bb:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801071c1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = curproc->tstack; i < USEREND-PGSIZE; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071c4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801071ca:	e8 41 b3 ff ff       	call   80102510 <kalloc>
801071cf:	85 c0                	test   %eax,%eax
801071d1:	89 c6                	mov    %eax,%esi
801071d3:	0f 85 67 ff ff ff    	jne    80107140 <copyuvm+0x100>
801071d9:	e9 30 ff ff ff       	jmp    8010710e <copyuvm+0xce>
801071de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071e1:	e9 35 ff ff ff       	jmp    8010711b <copyuvm+0xdb>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
	struct proc *curproc = myproc();
  if((d = setupkvm()) == 0)
    return 0;
801071e6:	31 c0                	xor    %eax,%eax
801071e8:	e9 2e ff ff ff       	jmp    8010711b <copyuvm+0xdb>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801071ed:	c7 04 24 38 84 10 80 	movl   $0x80108438,(%esp)
801071f4:	e8 67 91 ff ff       	call   80100360 <panic>
	struct proc *curproc = myproc();
  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071f9:	c7 04 24 1e 84 10 80 	movl   $0x8010841e,(%esp)
80107200:	e8 5b 91 ff ff       	call   80100360 <panic>
80107205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107216:	8b 45 0c             	mov    0xc(%ebp),%eax
80107219:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107220:	00 
80107221:	89 44 24 04          	mov    %eax,0x4(%esp)
80107225:	8b 45 08             	mov    0x8(%ebp),%eax
80107228:	89 04 24             	mov    %eax,(%esp)
8010722b:	e8 c0 f5 ff ff       	call   801067f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107230:	8b 00                	mov    (%eax),%eax
80107232:	89 c2                	mov    %eax,%edx
80107234:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80107237:	83 fa 05             	cmp    $0x5,%edx
8010723a:	75 0c                	jne    80107248 <uva2ka+0x38>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010723c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107241:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107246:	c9                   	leave  
80107247:	c3                   	ret    

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107248:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
8010724a:	c9                   	leave  
8010724b:	c3                   	ret    
8010724c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107250 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010725c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010725f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107262:	85 db                	test   %ebx,%ebx
80107264:	75 3a                	jne    801072a0 <copyout+0x50>
80107266:	eb 68                	jmp    801072d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107268:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010726b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010726d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107271:	29 ca                	sub    %ecx,%edx
80107273:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107279:	39 da                	cmp    %ebx,%edx
8010727b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010727e:	29 f1                	sub    %esi,%ecx
80107280:	01 c8                	add    %ecx,%eax
80107282:	89 54 24 08          	mov    %edx,0x8(%esp)
80107286:	89 04 24             	mov    %eax,(%esp)
80107289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010728c:	e8 af d2 ff ff       	call   80104540 <memmove>
    len -= n;
    buf += n;
80107291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107294:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010729a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010729c:	29 d3                	sub    %edx,%ebx
8010729e:	74 30                	je     801072d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
801072a0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801072a3:	89 ce                	mov    %ecx,%esi
801072a5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801072ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801072af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801072b2:	89 04 24             	mov    %eax,(%esp)
801072b5:	e8 56 ff ff ff       	call   80107210 <uva2ka>
    if(pa0 == 0)
801072ba:	85 c0                	test   %eax,%eax
801072bc:	75 aa                	jne    80107268 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801072be:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801072c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801072c6:	5b                   	pop    %ebx
801072c7:	5e                   	pop    %esi
801072c8:	5f                   	pop    %edi
801072c9:	5d                   	pop    %ebp
801072ca:	c3                   	ret    
801072cb:	90                   	nop
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072d0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801072d3:	31 c0                	xor    %eax,%eax
}
801072d5:	5b                   	pop    %ebx
801072d6:	5e                   	pop    %esi
801072d7:	5f                   	pop    %edi
801072d8:	5d                   	pop    %ebp
801072d9:	c3                   	ret    
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <addstackpage>:
int // For CS153 lab2 part1 
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
801072e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
801072ec:	e8 6f c4 ff ff       	call   80103760 <myproc>
801072f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i=0;i<rep;i++){
801072f4:	8b 45 10             	mov    0x10(%ebp),%eax
801072f7:	85 c0                	test   %eax,%eax
801072f9:	74 56                	je     80107351 <addstackpage+0x71>
801072fb:	31 f6                	xor    %esi,%esi
801072fd:	eb 27                	jmp    80107326 <addstackpage+0x46>
801072ff:	90                   	nop
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
80107300:	f6 00 01             	testb  $0x1,(%eax)
80107303:	75 42                	jne    80107347 <addstackpage+0x67>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
80107305:	8b 45 08             	mov    0x8(%ebp),%eax
80107308:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010730c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80107310:	89 04 24             	mov    %eax,(%esp)
80107313:	e8 38 f9 ff ff       	call   80106c50 <allocuvm>
80107318:	85 c0                	test   %eax,%eax
8010731a:	74 2b                	je     80107347 <addstackpage+0x67>
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
8010731c:	83 c6 01             	add    $0x1,%esi
8010731f:	3b 75 10             	cmp    0x10(%ebp),%esi
80107322:	74 34                	je     80107358 <addstackpage+0x78>
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
80107324:	89 df                	mov    %ebx,%edi
80107326:	8b 45 08             	mov    0x8(%ebp),%eax
80107329:	8d 9f 00 f0 ff ff    	lea    -0x1000(%edi),%ebx
8010732f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107336:	00 
80107337:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010733b:	89 04 24             	mov    %eax,(%esp)
8010733e:	e8 ad f4 ff ff       	call   801067f0 <walkpgdir>
80107343:	85 c0                	test   %eax,%eax
80107345:	75 b9                	jne    80107300 <addstackpage+0x20>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
80107347:	83 c4 1c             	add    $0x1c,%esp
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
8010734a:	31 c0                	xor    %eax,%eax
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
8010734c:	5b                   	pop    %ebx
8010734d:	5e                   	pop    %esi
8010734e:	5f                   	pop    %edi
8010734f:	5d                   	pop    %ebp
80107350:	c3                   	ret    
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
80107351:	89 fb                	mov    %edi,%ebx
80107353:	90                   	nop
80107354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
80107358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010735b:	89 58 7c             	mov    %ebx,0x7c(%eax)
  return 1;
}
8010735e:	83 c4 1c             	add    $0x1c,%esp
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
80107361:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107366:	5b                   	pop    %ebx
80107367:	5e                   	pop    %esi
80107368:	5f                   	pop    %edi
80107369:	5d                   	pop    %ebp
8010736a:	c3                   	ret    
8010736b:	66 90                	xchg   %ax,%ax
8010736d:	66 90                	xchg   %ax,%ax
8010736f:	90                   	nop

80107370 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107376:	c7 44 24 04 77 84 10 	movl   $0x80108477,0x4(%esp)
8010737d:	80 
8010737e:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107385:	e8 e6 ce ff ff       	call   80104270 <initlock>
  acquire(&(shm_table.lock));
8010738a:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107391:	e8 ca cf ff ff       	call   80104360 <acquire>
80107396:	b8 f4 6d 11 80       	mov    $0x80116df4,%eax
8010739b:	90                   	nop
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
801073a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801073a6:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
801073a9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
801073b0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
801073b7:	3d f4 70 11 80       	cmp    $0x801170f4,%eax
801073bc:	75 e2                	jne    801073a0 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
801073be:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801073c5:	e8 86 d0 ff ff       	call   80104450 <release>
}
801073ca:	c9                   	leave  
801073cb:	c3                   	ret    
801073cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073d0 <shm_create>:

int shm_create(int table_id) {
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 2c             	sub    $0x2c,%esp
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
801073d9:	e8 82 c3 ff ff       	call   80103760 <myproc>
	if(table_id < 0 || table_id >= 64){
801073de:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
}

int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
801073e2:	89 c7                	mov    %eax,%edi
	if(table_id < 0 || table_id >= 64){
801073e4:	0f 87 f1 00 00 00    	ja     801074db <shm_create+0x10b>
801073ea:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
801073ec:	8b b4 df 80 00 00 00 	mov    0x80(%edi,%ebx,8),%esi
801073f3:	83 fe ff             	cmp    $0xffffffff,%esi
801073f6:	74 30                	je     80107428 <shm_create+0x58>
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
801073f8:	83 c3 01             	add    $0x1,%ebx
801073fb:	83 fb 04             	cmp    $0x4,%ebx
801073fe:	75 ec                	jne    801073ec <shm_create+0x1c>
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
80107400:	8b 47 10             	mov    0x10(%edi),%eax
		return -1;
80107403:	be ff ff ff ff       	mov    $0xffffffff,%esi
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
80107408:	c7 04 24 b2 84 10 80 	movl   $0x801084b2,(%esp)
8010740f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107413:	e8 38 92 ff ff       	call   80100650 <cprintf>
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
80107418:	83 c4 2c             	add    $0x2c,%esp
8010741b:	89 f0                	mov    %esi,%eax
8010741d:	5b                   	pop    %ebx
8010741e:	5e                   	pop    %esi
8010741f:	5f                   	pop    %edi
80107420:	5d                   	pop    %ebp
80107421:	c3                   	ret    
80107422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
80107428:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010742f:	e8 2c cf ff ff       	call   80104360 <acquire>
	if(shm_table.shm_pages[table_id].refcnt != 0){
80107434:	8b 45 08             	mov    0x8(%ebp),%eax
80107437:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010743a:	8d 14 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edx
80107441:	8b 42 0c             	mov    0xc(%edx),%eax
80107444:	85 c0                	test   %eax,%eax
80107446:	75 68                	jne    801074b0 <shm_create+0xe0>
80107448:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
8010744b:	e8 c0 b0 ff ff       	call   80102510 <kalloc>
80107450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107453:	85 c0                	test   %eax,%eax
80107455:	89 c1                	mov    %eax,%ecx
80107457:	0f 84 9b 00 00 00    	je     801074f8 <shm_create+0x128>
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
8010745d:	8b 45 08             	mov    0x8(%ebp),%eax
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
80107460:	89 de                	mov    %ebx,%esi
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
	shm_table.shm_pages[table_id].refcnt++;
80107462:	83 42 0c 01          	addl   $0x1,0xc(%edx)
80107466:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
80107469:	89 42 04             	mov    %eax,0x4(%edx)
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
8010746c:	89 0c 24             	mov    %ecx,(%esp)
8010746f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107476:	00 
80107477:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010747e:	00 
8010747f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107482:	e8 19 d0 ff ff       	call   801044a0 <memset>
	shm_table.shm_pages[table_id].frame = memory;
80107487:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010748a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010748d:	89 4a 08             	mov    %ecx,0x8(%edx)
	release(&(shm_table.lock));
80107490:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107497:	e8 b4 cf ff ff       	call   80104450 <release>
	curproc->pages[page_id].id = table_id;
8010749c:	8b 45 08             	mov    0x8(%ebp),%eax
8010749f:	89 84 df 80 00 00 00 	mov    %eax,0x80(%edi,%ebx,8)
	return page_id;
}
801074a6:	83 c4 2c             	add    $0x2c,%esp
801074a9:	89 f0                	mov    %esi,%eax
801074ab:	5b                   	pop    %ebx
801074ac:	5e                   	pop    %esi
801074ad:	5f                   	pop    %edi
801074ae:	5d                   	pop    %ebp
801074af:	c3                   	ret    
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[table_id].refcnt != 0){
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
801074b0:	8b 45 08             	mov    0x8(%ebp),%eax
801074b3:	89 44 24 08          	mov    %eax,0x8(%esp)
801074b7:	8b 47 10             	mov    0x10(%edi),%eax
801074ba:	c7 04 24 f8 84 10 80 	movl   $0x801084f8,(%esp)
801074c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801074c5:	e8 86 91 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
801074ca:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801074d1:	e8 7a cf ff ff       	call   80104450 <release>
		return -1;
801074d6:	e9 3d ff ff ff       	jmp    80107418 <shm_create+0x48>
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
801074db:	8b 40 10             	mov    0x10(%eax),%eax
		return -1;
801074de:	be ff ff ff ff       	mov    $0xffffffff,%esi
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
801074e3:	c7 04 24 80 84 10 80 	movl   $0x80108480,(%esp)
801074ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801074ee:	e8 5d 91 ff ff       	call   80100650 <cprintf>
		return -1;
801074f3:	e9 20 ff ff ff       	jmp    80107418 <shm_create+0x48>
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
801074f8:	8b 47 10             	mov    0x10(%edi),%eax
801074fb:	c7 04 24 96 84 10 80 	movl   $0x80108496,(%esp)
80107502:	89 44 24 04          	mov    %eax,0x4(%esp)
80107506:	e8 45 91 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010750b:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107512:	e8 39 cf ff ff       	call   80104450 <release>
		return -1;
80107517:	e9 fc fe ff ff       	jmp    80107418 <shm_create+0x48>
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107520 <shm_open>:
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
int shm_open(int id, char **pointer) {
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 1c             	sub    $0x1c,%esp
80107529:	8b 75 08             	mov    0x8(%ebp),%esi
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
8010752c:	e8 2f c2 ff ff       	call   80103760 <myproc>
	if(id < 0 || id >= 64){
80107531:	83 fe 3f             	cmp    $0x3f,%esi
	return page_id;
}
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
80107534:	89 c7                	mov    %eax,%edi
	if(id < 0 || id >= 64){
80107536:	0f 87 0c 01 00 00    	ja     80107648 <shm_open+0x128>
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
8010753c:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
	if (shm_table.shm_pages[id].refcnt == 0){
80107543:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
80107545:	e8 16 ce ff ff       	call   80104360 <acquire>
	if (shm_table.shm_pages[id].refcnt == 0){
8010754a:	8d 04 76             	lea    (%esi,%esi,2),%eax
8010754d:	8b 14 85 fc 6d 11 80 	mov    -0x7fee9204(,%eax,4),%edx
80107554:	85 d2                	test   %edx,%edx
80107556:	74 58                	je     801075b0 <shm_open+0x90>
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
80107558:	39 b4 df 80 00 00 00 	cmp    %esi,0x80(%edi,%ebx,8)
8010755f:	0f 84 8d 00 00 00    	je     801075f2 <shm_open+0xd2>
			return -1;
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
80107565:	83 c3 01             	add    $0x1,%ebx
80107568:	83 fb 04             	cmp    $0x4,%ebx
8010756b:	75 eb                	jne    80107558 <shm_open+0x38>
8010756d:	30 db                	xor    %bl,%bl
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
				if(curproc->pages[page_id].id == -1) break;
8010756f:	83 bc df 80 00 00 00 	cmpl   $0xffffffff,0x80(%edi,%ebx,8)
80107576:	ff 
80107577:	0f 84 e5 00 00 00    	je     80107662 <shm_open+0x142>
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
8010757d:	83 c3 01             	add    $0x1,%ebx
80107580:	83 fb 04             	cmp    $0x4,%ebx
80107583:	75 ea                	jne    8010756f <shm_open+0x4f>
				if(curproc->pages[page_id].id == -1) break;
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
80107585:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010758c:	e8 bf ce ff ff       	call   80104450 <release>
      	cprintf("Proc: %d, process is full\n",curproc->pid);
80107591:	8b 47 10             	mov    0x10(%edi),%eax
80107594:	c7 04 24 b2 84 10 80 	movl   $0x801084b2,(%esp)
8010759b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010759f:	e8 ac 90 ff ff       	call   80100650 <cprintf>
				return -1; 
801075a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a9:	eb 6d                	jmp    80107618 <shm_open+0xf8>
801075ab:	90                   	nop
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
801075b0:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801075b7:	e8 94 ce ff ff       	call   80104450 <release>
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
801075bc:	89 74 24 08          	mov    %esi,0x8(%esp)
801075c0:	8b 47 10             	mov    0x10(%edi),%eax
801075c3:	c7 04 24 18 85 10 80 	movl   $0x80108518,(%esp)
801075ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801075ce:	e8 7d 90 ff ff       	call   80100650 <cprintf>
		if((page_id = shm_create(id))==-1){
801075d3:	89 34 24             	mov    %esi,(%esp)
801075d6:	e8 f5 fd ff ff       	call   801073d0 <shm_create>
801075db:	83 f8 ff             	cmp    $0xffffffff,%eax
801075de:	89 c3                	mov    %eax,%ebx
801075e0:	0f 84 9f 00 00 00    	je     80107685 <shm_open+0x165>
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
			return -1;
		}
		acquire(&(shm_table.lock));
801075e6:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801075ed:	e8 6e cd ff ff       	call   80104360 <acquire>
801075f2:	8d 1c df             	lea    (%edi,%ebx,8),%ebx
			curproc->pages[page_id].id = id;
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
801075f5:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801075fb:	85 c0                	test   %eax,%eax
801075fd:	74 21                	je     80107620 <shm_open+0x100>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
  }
	release(&(shm_table.lock));
801075ff:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107606:	e8 45 ce ff ff       	call   80104450 <release>
	*pointer = curproc->pages[page_id].vaddr;
8010760b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010760e:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80107614:	89 10                	mov    %edx,(%eax)
	return 0;
80107616:	31 c0                	xor    %eax,%eax
}
80107618:	83 c4 1c             	add    $0x1c,%esp
8010761b:	5b                   	pop    %ebx
8010761c:	5e                   	pop    %esi
8010761d:	5f                   	pop    %edi
8010761e:	5d                   	pop    %ebp
8010761f:	c3                   	ret    
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
80107620:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107623:	8b 04 85 f8 6d 11 80 	mov    -0x7fee9208(,%eax,4),%eax
8010762a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010762e:	8b 47 04             	mov    0x4(%edi),%eax
80107631:	89 04 24             	mov    %eax,(%esp)
80107634:	e8 37 f7 ff ff       	call   80106d70 <allocshm>
80107639:	83 f8 ff             	cmp    $0xffffffff,%eax
8010763c:	74 68                	je     801076a6 <shm_open+0x186>
			release(&(shm_table.lock));
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
8010763e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80107644:	eb b9                	jmp    801075ff <shm_open+0xdf>
80107646:	66 90                	xchg   %ax,%ax
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
80107648:	8b 40 10             	mov    0x10(%eax),%eax
8010764b:	c7 04 24 80 84 10 80 	movl   $0x80108480,(%esp)
80107652:	89 44 24 04          	mov    %eax,0x4(%esp)
80107656:	e8 f5 8f ff ff       	call   80100650 <cprintf>
		return -1;
8010765b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107660:	eb b6                	jmp    80107618 <shm_open+0xf8>
80107662:	8d 04 df             	lea    (%edi,%ebx,8),%eax
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
      	cprintf("Proc: %d, process is full\n",curproc->pid);
				return -1; 
    	}
			curproc->pages[page_id].id = id;
80107665:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
			curproc->pages[page_id].vaddr = 0;
8010766b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80107672:	00 00 00 
			shm_table.shm_pages[id].refcnt++;
80107675:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107678:	83 04 85 fc 6d 11 80 	addl   $0x1,-0x7fee9204(,%eax,4)
8010767f:	01 
80107680:	e9 6d ff ff ff       	jmp    801075f2 <shm_open+0xd2>
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
		if((page_id = shm_create(id))==-1){
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
80107685:	89 74 24 08          	mov    %esi,0x8(%esp)
80107689:	8b 47 10             	mov    0x10(%edi),%eax
8010768c:	c7 04 24 38 85 10 80 	movl   $0x80108538,(%esp)
80107693:	89 44 24 04          	mov    %eax,0x4(%esp)
80107697:	e8 b4 8f ff ff       	call   80100650 <cprintf>
			return -1;
8010769c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076a1:	e9 72 ff ff ff       	jmp    80107618 <shm_open+0xf8>
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
			release(&(shm_table.lock));
801076a6:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801076ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076b0:	e8 9b cd ff ff       	call   80104450 <release>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
801076b5:	8b 57 10             	mov    0x10(%edi),%edx
801076b8:	c7 04 24 cd 84 10 80 	movl   $0x801084cd,(%esp)
801076bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801076c3:	e8 88 8f ff ff       	call   80100650 <cprintf>
			return -1;
801076c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076cb:	e9 48 ff ff ff       	jmp    80107618 <shm_open+0xf8>

801076d0 <shm_close>:
	*pointer = curproc->pages[page_id].vaddr;
	return 0;
}


int shm_close(int id) {
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 1c             	sub    $0x1c,%esp
801076d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	cprintf("****************");
801076dc:	c7 04 24 e7 84 10 80 	movl   $0x801084e7,(%esp)
801076e3:	e8 68 8f ff ff       	call   80100650 <cprintf>
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801076e8:	e8 73 c0 ff ff       	call   80103760 <myproc>
	if(id < 0 || id >= 64){
801076ed:	83 ff 3f             	cmp    $0x3f,%edi

int shm_close(int id) {
	cprintf("****************");
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801076f0:	89 c6                	mov    %eax,%esi
	if(id < 0 || id >= 64){
801076f2:	0f 87 76 01 00 00    	ja     8010786e <shm_close+0x19e>
801076f8:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == id) break;
801076fa:	39 bc de 80 00 00 00 	cmp    %edi,0x80(%esi,%ebx,8)
80107701:	74 2d                	je     80107730 <shm_close+0x60>
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
80107703:	83 c3 01             	add    $0x1,%ebx
80107706:	83 fb 04             	cmp    $0x4,%ebx
80107709:	75 ef                	jne    801076fa <shm_close+0x2a>
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
8010770b:	8b 46 10             	mov    0x10(%esi),%eax
8010770e:	c7 04 24 bc 85 10 80 	movl   $0x801085bc,(%esp)
80107715:	89 44 24 04          	mov    %eax,0x4(%esp)
80107719:	e8 32 8f ff ff       	call   80100650 <cprintf>
		return -1;
8010771e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
80107723:	83 c4 1c             	add    $0x1c,%esp
80107726:	5b                   	pop    %ebx
80107727:	5e                   	pop    %esi
80107728:	5f                   	pop    %edi
80107729:	5d                   	pop    %ebp
8010772a:	c3                   	ret    
8010772b:	90                   	nop
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
80107730:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107737:	e8 24 cc ff ff       	call   80104360 <acquire>
	if(shm_table.shm_pages[id].refcnt <= 0){
8010773c:	8d 04 7f             	lea    (%edi,%edi,2),%eax
8010773f:	8d 3c 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edi
80107746:	8b 47 0c             	mov    0xc(%edi),%eax
80107749:	85 c0                	test   %eax,%eax
8010774b:	0f 8e cb 00 00 00    	jle    8010781c <shm_close+0x14c>
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
80107751:	83 e8 01             	sub    $0x1,%eax
80107754:	89 47 0c             	mov    %eax,0xc(%edi)
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
80107757:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010775e:	00 
8010775f:	8b 47 08             	mov    0x8(%edi),%eax
80107762:	89 44 24 04          	mov    %eax,0x4(%esp)
80107766:	8b 46 04             	mov    0x4(%esi),%eax
80107769:	89 04 24             	mov    %eax,(%esp)
8010776c:	e8 7f f0 ff ff       	call   801067f0 <walkpgdir>
	if(pte == 0){
80107771:	85 c0                	test   %eax,%eax
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
80107773:	89 c2                	mov    %eax,%edx
	if(pte == 0){
80107775:	0f 84 cd 00 00 00    	je     80107848 <shm_close+0x178>
		cprintf("Proc: %d, free memory error 1\n",curproc->pid);
		release(&(shm_table.lock));
		return 0;
	}
	if(shm_table.shm_pages[id].refcnt == 0){
8010777b:	8b 47 0c             	mov    0xc(%edi),%eax
8010777e:	85 c0                	test   %eax,%eax
80107780:	75 2f                	jne    801077b1 <shm_close+0xe1>
		shm_table.shm_pages[id].id =0;
80107782:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
		if((*pte & PTE_P) == 0){
80107789:	8b 0a                	mov    (%edx),%ecx
8010778b:	f6 c1 01             	test   $0x1,%cl
8010778e:	74 58                	je     801077e8 <shm_close+0x118>
			cprintf("Proc: %d, free memory error 2\n",curproc->pid);
			shm_table.shm_pages[id].frame =0;
			release(&(shm_table.lock));
			return 0;
		}
		kfree(P2V(PTE_ADDR(*pte)));
80107790:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107796:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
8010779c:	89 0c 24             	mov    %ecx,(%esp)
8010779f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801077a2:	e8 b9 ab ff ff       	call   80102360 <kfree>
		shm_table.shm_pages[id].frame =0;
801077a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077aa:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
	}
	*pte = 0;
801077b1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	release(&(shm_table.lock));
801077b7:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801077be:	e8 8d cc ff ff       	call   80104450 <release>
801077c3:	8d 04 de             	lea    (%esi,%ebx,8),%eax
	curproc->pages[page_id].id = -1;
801077c6:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
801077cd:	ff ff ff 
	curproc->pages[page_id].vaddr = 0;
801077d0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801077d7:	00 00 00 
	return 0;
}
801077da:	83 c4 1c             	add    $0x1c,%esp
	}
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
801077dd:	31 c0                	xor    %eax,%eax
}
801077df:	5b                   	pop    %ebx
801077e0:	5e                   	pop    %esi
801077e1:	5f                   	pop    %edi
801077e2:	5d                   	pop    %ebp
801077e3:	c3                   	ret    
801077e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return 0;
	}
	if(shm_table.shm_pages[id].refcnt == 0){
		shm_table.shm_pages[id].id =0;
		if((*pte & PTE_P) == 0){
			cprintf("Proc: %d, free memory error 2\n",curproc->pid);
801077e8:	8b 56 10             	mov    0x10(%esi),%edx
801077eb:	c7 04 24 9c 85 10 80 	movl   $0x8010859c,(%esp)
801077f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801077f9:	e8 52 8e ff ff       	call   80100650 <cprintf>
			shm_table.shm_pages[id].frame =0;
801077fe:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
			release(&(shm_table.lock));
80107805:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010780c:	e8 3f cc ff ff       	call   80104450 <release>
			return 0;
80107811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
80107814:	83 c4 1c             	add    $0x1c,%esp
80107817:	5b                   	pop    %ebx
80107818:	5e                   	pop    %esi
80107819:	5f                   	pop    %edi
8010781a:	5d                   	pop    %ebp
8010781b:	c3                   	ret    
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[id].refcnt <= 0){
		release(&(shm_table.lock));
8010781c:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107823:	e8 28 cc ff ff       	call   80104450 <release>
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
80107828:	8b 46 10             	mov    0x10(%esi),%eax
8010782b:	c7 04 24 5c 85 10 80 	movl   $0x8010855c,(%esp)
80107832:	89 44 24 04          	mov    %eax,0x4(%esp)
80107836:	e8 15 8e ff ff       	call   80100650 <cprintf>
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
8010783b:	83 c4 1c             	add    $0x1c,%esp
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[id].refcnt <= 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
8010783e:	31 c0                	xor    %eax,%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
80107840:	5b                   	pop    %ebx
80107841:	5e                   	pop    %esi
80107842:	5f                   	pop    %edi
80107843:	5d                   	pop    %ebp
80107844:	c3                   	ret    
80107845:	8d 76 00             	lea    0x0(%esi),%esi
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
	if(pte == 0){
		cprintf("Proc: %d, free memory error 1\n",curproc->pid);
80107848:	8b 46 10             	mov    0x10(%esi),%eax
8010784b:	c7 04 24 7c 85 10 80 	movl   $0x8010857c,(%esp)
80107852:	89 44 24 04          	mov    %eax,0x4(%esp)
80107856:	e8 f5 8d ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010785b:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107862:	e8 e9 cb ff ff       	call   80104450 <release>
		return 0;
80107867:	31 c0                	xor    %eax,%eax
80107869:	e9 b5 fe ff ff       	jmp    80107723 <shm_close+0x53>
	cprintf("****************");
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
8010786e:	8b 40 10             	mov    0x10(%eax),%eax
80107871:	c7 04 24 80 84 10 80 	movl   $0x80108480,(%esp)
80107878:	89 44 24 04          	mov    %eax,0x4(%esp)
8010787c:	e8 cf 8d ff ff       	call   80100650 <cprintf>
		return -1;
80107881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107886:	e9 98 fe ff ff       	jmp    80107723 <shm_close+0x53>
