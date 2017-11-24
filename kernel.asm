
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
8010002d:	b8 20 2e 10 80       	mov    $0x80102e20,%eax
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
8010004c:	c7 44 24 04 60 77 10 	movl   $0x80107760,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010005b:	e8 00 41 00 00       	call   80104160 <initlock>

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
80100094:	c7 44 24 04 67 77 10 	movl   $0x80107767,0x4(%esp)
8010009b:	80 
8010009c:	e8 af 3f 00 00       	call   80104050 <initsleeplock>
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
801000e6:	e8 65 41 00 00       	call   80104250 <acquire>

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
80100161:	e8 da 41 00 00       	call   80104340 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 1f 3f 00 00       	call   80104090 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 d2 1f 00 00       	call   80102150 <iderw>
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
80100188:	c7 04 24 6e 77 10 80 	movl   $0x8010776e,(%esp)
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
801001b0:	e8 7b 3f 00 00       	call   80104130 <holdingsleep>
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
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 7f 77 10 80 	movl   $0x8010777f,(%esp)
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
801001f1:	e8 3a 3f 00 00       	call   80104130 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ee 3e 00 00       	call   801040f0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100209:	e8 42 40 00 00       	call   80104250 <acquire>
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
80100250:	e9 eb 40 00 00       	jmp    80104340 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 86 77 10 80 	movl   $0x80107786,(%esp)
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
80100282:	e8 39 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 bd 3f 00 00       	call   80104250 <acquire>
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
801002a8:	e8 23 34 00 00       	call   801036d0 <myproc>
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
801002c3:	e8 28 3a 00 00       	call   80103cf0 <sleep>

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
80100311:	e8 2a 40 00 00       	call   80104340 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 c2 13 00 00       	call   801016e0 <ilock>
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
8010032f:	e8 0c 40 00 00       	call   80104340 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 a4 13 00 00       	call   801016e0 <ilock>
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
80100376:	e8 15 24 00 00       	call   80102790 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 8d 77 10 80 	movl   $0x8010778d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 7f 82 10 80 	movl   $0x8010827f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 cc 3d 00 00       	call   80104180 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
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
80100409:	e8 82 56 00 00       	call   80105a90 <uartputc>
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
801004b9:	e8 d2 55 00 00       	call   80105a90 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 c6 55 00 00       	call   80105a90 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ba 55 00 00       	call   80105a90 <uartputc>
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
801004fc:	e8 2f 3f 00 00       	call   80104430 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 72 3e 00 00       	call   80104390 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 a5 77 10 80 	movl   $0x801077a5,(%esp)
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
80100599:	0f b6 92 d0 77 10 80 	movzbl -0x7fef8830(%edx),%edx
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
80100602:	e8 b9 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 3d 3c 00 00       	call   80104250 <acquire>
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
80100636:	e8 05 3d 00 00       	call   80104340 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 9a 10 00 00       	call   801016e0 <ilock>

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
801006f3:	e8 48 3c 00 00       	call   80104340 <release>
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
80100760:	b8 b8 77 10 80       	mov    $0x801077b8,%eax
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
80100797:	e8 b4 3a 00 00       	call   80104250 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 bf 77 10 80 	movl   $0x801077bf,(%esp)
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
801007c5:	e8 86 3a 00 00       	call   80104250 <acquire>
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
80100827:	e8 14 3b 00 00       	call   80104340 <release>
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
801008b2:	e8 d9 35 00 00       	call   80103e90 <wakeup>
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
80100927:	e9 54 36 00 00       	jmp    80103f80 <procdump>
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
80100956:	c7 44 24 04 c8 77 10 	movl   $0x801077c8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100965:	e8 f6 37 00 00       	call   80104160 <initlock>

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
80100997:	e8 44 19 00 00       	call   801022e0 <ioapicenable>
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
801009ac:	e8 1f 2d 00 00       	call   801036d0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();
801009b7:	e8 84 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 69 15 00 00       	call   80101f30 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 83 02 00 00    	je     80100c54 <exec+0x2b4>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 07 0d 00 00       	call   801016e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 95 0f 00 00       	call   80101990 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 38 0f 00 00       	call   80101940 <iunlockput>
    end_op();
80100a08:	e8 a3 21 00 00       	call   80102bb0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 bf 63 00 00       	call   80106df0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 fd 0e 00 00       	call   80101990 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 59 60 00 00       	call   80106b30 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 48 5f 00 00       	call   80106a60 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 42 62 00 00       	call   80106d70 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 05 0e 00 00       	call   80101940 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 6b 20 00 00       	call   80102bb0 <end_op>
  ip = 0;

  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
	clearpteu(pgdir, (char*)sz);
80100b4b:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100b51:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b56:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b5c:	81 a5 e8 fe ff ff 00 	andl   $0xfffff000,-0x118(%ebp)
80100b63:	f0 ff ff 
	clearpteu(pgdir, (char*)sz);
80100b66:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100b6c:	89 3c 24             	mov    %edi,(%esp)
80100b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b73:	e8 28 63 00 00       	call   80106ea0 <clearpteu>
  sp = sz;
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
80100b78:	c7 44 24 08 00 00 00 	movl   $0x80000000,0x8(%esp)
80100b7f:	80 
80100b80:	c7 44 24 04 00 e0 ff 	movl   $0x7fffe000,0x4(%esp)
80100b87:	7f 
80100b88:	89 3c 24             	mov    %edi,(%esp)
80100b8b:	e8 a0 5f 00 00       	call   80106b30 <allocuvm>
80100b90:	85 c0                	test   %eax,%eax
80100b92:	89 c3                	mov    %eax,%ebx
80100b94:	0f 84 bf 01 00 00    	je     80100d59 <exec+0x3b9>
			panic("stack allocation failed");
			goto bad;
		}
  clearpteu(pgdir, (char*)(tstack+PGSIZE));
80100b9a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ba0:	c7 44 24 04 00 f0 ff 	movl   $0x7ffff000,0x4(%esp)
80100ba7:	7f 
80100ba8:	89 04 24             	mov    %eax,(%esp)
80100bab:	e8 f0 62 00 00       	call   80106ea0 <clearpteu>


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb3:	8b 00                	mov    (%eax),%eax
80100bb5:	85 c0                	test   %eax,%eax
80100bb7:	0f 84 b2 00 00 00    	je     80100c6f <exec+0x2cf>
80100bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bc0:	31 f6                	xor    %esi,%esi
80100bc2:	8d 51 04             	lea    0x4(%ecx),%edx
80100bc5:	89 cf                	mov    %ecx,%edi
80100bc7:	eb 31                	jmp    80100bfa <exec+0x25a>
80100bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bd0:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bd6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100bdc:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
		}
  clearpteu(pgdir, (char*)(tstack+PGSIZE));


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be3:	83 c6 01             	add    $0x1,%esi
80100be6:	8b 02                	mov    (%edx),%eax
80100be8:	89 d7                	mov    %edx,%edi
80100bea:	85 c0                	test   %eax,%eax
80100bec:	0f 84 85 00 00 00    	je     80100c77 <exec+0x2d7>
80100bf2:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf5:	83 fe 20             	cmp    $0x20,%esi
80100bf8:	74 42                	je     80100c3c <exec+0x29c>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bfa:	89 04 24             	mov    %eax,(%esp)
80100bfd:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c03:	e8 a8 39 00 00       	call   801045b0 <strlen>
80100c08:	f7 d0                	not    %eax
80100c0a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0c:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 97 39 00 00       	call   801045b0 <strlen>
80100c19:	83 c0 01             	add    $0x1,%eax
80100c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c20:	8b 07                	mov    (%edi),%eax
80100c22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c26:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c2a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c30:	89 04 24             	mov    %eax,(%esp)
80100c33:	e8 e8 64 00 00       	call   80107120 <copyout>
80100c38:	85 c0                	test   %eax,%eax
80100c3a:	79 94                	jns    80100bd0 <exec+0x230>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c3c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c42:	89 04 24             	mov    %eax,(%esp)
80100c45:	e8 26 61 00 00       	call   80106d70 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4f:	e9 be fd ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c54:	e8 57 1f 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100c59:	c7 04 24 e1 77 10 80 	movl   $0x801077e1,(%esp)
80100c60:	e8 eb f9 ff ff       	call   80100650 <cprintf>
    return -1;
80100c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c6a:	e9 a3 fd ff ff       	jmp    80100a12 <exec+0x72>
		}
  clearpteu(pgdir, (char*)(tstack+PGSIZE));


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6f:	31 f6                	xor    %esi,%esi
80100c71:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c77:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c7e:	89 da                	mov    %ebx,%edx
80100c80:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c82:	83 c0 0c             	add    $0xc,%eax
80100c85:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c8b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c99:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100ca0:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100ca7:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cae:	ff ff ff 
  ustack[1] = argc;
80100cb1:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb7:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbd:	e8 5e 64 00 00       	call   80107120 <copyout>
80100cc2:	85 c0                	test   %eax,%eax
80100cc4:	0f 88 72 ff ff ff    	js     80100c3c <exec+0x29c>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cca:	8b 45 08             	mov    0x8(%ebp),%eax
80100ccd:	0f b6 10             	movzbl (%eax),%edx
80100cd0:	84 d2                	test   %dl,%dl
80100cd2:	74 1f                	je     80100cf3 <exec+0x353>
80100cd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd7:	83 c0 01             	add    $0x1,%eax
80100cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == '/')
      last = s+1;
80100ce0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce6:	0f 44 c8             	cmove  %eax,%ecx
80100ce9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cec:	84 d2                	test   %dl,%dl
80100cee:	75 f0                	jne    80100ce0 <exec+0x340>
80100cf0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100d03:	00 
80100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d08:	89 f8                	mov    %edi,%eax
80100d0a:	83 c0 6c             	add    $0x6c,%eax
80100d0d:	89 04 24             	mov    %eax,(%esp)
80100d10:	e8 5b 38 00 00       	call   80104570 <safestrcpy>

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d15:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
80100d1b:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d1e:	8b 47 18             	mov    0x18(%edi),%eax
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
80100d21:	c7 47 7c 00 e0 ff 7f 	movl   $0x7fffe000,0x7c(%edi)
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d28:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d2b:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d31:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d33:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d39:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d3c:	8b 47 18             	mov    0x18(%edi),%eax
80100d3f:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d42:	89 3c 24             	mov    %edi,(%esp)
80100d45:	e8 76 5b 00 00       	call   801068c0 <switchuvm>
  freevm(oldpgdir);
80100d4a:	89 34 24             	mov    %esi,(%esp)
80100d4d:	e8 1e 60 00 00       	call   80106d70 <freevm>
  return 0;
80100d52:	31 c0                	xor    %eax,%eax
80100d54:	e9 b9 fc ff ff       	jmp    80100a12 <exec+0x72>
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
			panic("stack allocation failed");
80100d59:	c7 04 24 ed 77 10 80 	movl   $0x801077ed,(%esp)
80100d60:	e8 fb f5 ff ff       	call   80100360 <panic>
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d76:	c7 44 24 04 05 78 10 	movl   $0x80107805,0x4(%esp)
80100d7d:	80 
80100d7e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100d85:	e8 d6 33 00 00       	call   80104160 <initlock>
}
80100d8a:	c9                   	leave  
80100d8b:	c3                   	ret    
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d94:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d99:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d9c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100da3:	e8 a8 34 00 00       	call   80104250 <acquire>
80100da8:	eb 11                	jmp    80100dbb <filealloc+0x2b>
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100db9:	74 25                	je     80100de0 <filealloc+0x50>
    if(f->ref == 0){
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dc2:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100dc9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dd0:	e8 6b 35 00 00       	call   80104340 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dd5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100dd8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dda:	5b                   	pop    %ebx
80100ddb:	5d                   	pop    %ebp
80100ddc:	c3                   	ret    
80100ddd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100de0:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100de7:	e8 54 35 00 00       	call   80104340 <release>
  return 0;
}
80100dec:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100def:	31 c0                	xor    %eax,%eax
}
80100df1:	5b                   	pop    %ebx
80100df2:	5d                   	pop    %ebp
80100df3:	c3                   	ret    
80100df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 14             	sub    $0x14,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0a:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e11:	e8 3a 34 00 00       	call   80104250 <acquire>
  if(f->ref < 1)
80100e16:	8b 43 04             	mov    0x4(%ebx),%eax
80100e19:	85 c0                	test   %eax,%eax
80100e1b:	7e 1a                	jle    80100e37 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e1d:	83 c0 01             	add    $0x1,%eax
80100e20:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e23:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e2a:	e8 11 35 00 00       	call   80104340 <release>
  return f;
}
80100e2f:	83 c4 14             	add    $0x14,%esp
80100e32:	89 d8                	mov    %ebx,%eax
80100e34:	5b                   	pop    %ebx
80100e35:	5d                   	pop    %ebp
80100e36:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e37:	c7 04 24 0c 78 10 80 	movl   $0x8010780c,(%esp)
80100e3e:	e8 1d f5 ff ff       	call   80100360 <panic>
80100e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 1c             	sub    $0x1c,%esp
80100e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e5c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e63:	e8 e8 33 00 00       	call   80104250 <acquire>
  if(f->ref < 1)
80100e68:	8b 57 04             	mov    0x4(%edi),%edx
80100e6b:	85 d2                	test   %edx,%edx
80100e6d:	0f 8e 89 00 00 00    	jle    80100efc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e73:	83 ea 01             	sub    $0x1,%edx
80100e76:	85 d2                	test   %edx,%edx
80100e78:	89 57 04             	mov    %edx,0x4(%edi)
80100e7b:	74 13                	je     80100e90 <fileclose+0x40>
    release(&ftable.lock);
80100e7d:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e84:	83 c4 1c             	add    $0x1c,%esp
80100e87:	5b                   	pop    %ebx
80100e88:	5e                   	pop    %esi
80100e89:	5f                   	pop    %edi
80100e8a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e8b:	e9 b0 34 00 00       	jmp    80104340 <release>
    return;
  }
  ff = *f;
80100e90:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e94:	8b 37                	mov    (%edi),%esi
80100e96:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e99:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e9f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ea2:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ea5:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eaf:	e8 8c 34 00 00       	call   80104340 <release>

  if(ff.type == FD_PIPE)
80100eb4:	83 fe 01             	cmp    $0x1,%esi
80100eb7:	74 0f                	je     80100ec8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100eb9:	83 fe 02             	cmp    $0x2,%esi
80100ebc:	74 22                	je     80100ee0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ebe:	83 c4 1c             	add    $0x1c,%esp
80100ec1:	5b                   	pop    %ebx
80100ec2:	5e                   	pop    %esi
80100ec3:	5f                   	pop    %edi
80100ec4:	5d                   	pop    %ebp
80100ec5:	c3                   	ret    
80100ec6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ecc:	89 1c 24             	mov    %ebx,(%esp)
80100ecf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ed3:	e8 b8 23 00 00       	call   80103290 <pipeclose>
80100ed8:	eb e4                	jmp    80100ebe <fileclose+0x6e>
80100eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ee0:	e8 5b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ee8:	89 04 24             	mov    %eax,(%esp)
80100eeb:	e8 10 09 00 00       	call   80101800 <iput>
    end_op();
  }
}
80100ef0:	83 c4 1c             	add    $0x1c,%esp
80100ef3:	5b                   	pop    %ebx
80100ef4:	5e                   	pop    %esi
80100ef5:	5f                   	pop    %edi
80100ef6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ef7:	e9 b4 1c 00 00       	jmp    80102bb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100efc:	c7 04 24 14 78 10 80 	movl   $0x80107814,(%esp)
80100f03:	e8 58 f4 ff ff       	call   80100360 <panic>
80100f08:	90                   	nop
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 14             	sub    $0x14,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f22:	89 04 24             	mov    %eax,(%esp)
80100f25:	e8 b6 07 00 00       	call   801016e0 <ilock>
    stati(f->ip, st);
80100f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
80100f34:	89 04 24             	mov    %eax,(%esp)
80100f37:	e8 24 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f3c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f3f:	89 04 24             	mov    %eax,(%esp)
80100f42:	e8 79 08 00 00       	call   801017c0 <iunlock>
    return 0;
  }
  return -1;
}
80100f47:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f4a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f4c:	5b                   	pop    %ebx
80100f4d:	5d                   	pop    %ebp
80100f4e:	c3                   	ret    
80100f4f:	90                   	nop
80100f50:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f58:	5b                   	pop    %ebx
80100f59:	5d                   	pop    %ebp
80100f5a:	c3                   	ret    
80100f5b:	90                   	nop
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 1c             	sub    $0x1c,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 68                	je     80100fe0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 49                	je     80100fc8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 63                	jne    80100fe7 <fileread+0x87>
    ilock(f->ip);
80100f84:	8b 43 10             	mov    0x10(%ebx),%eax
80100f87:	89 04 24             	mov    %eax,(%esp)
80100f8a:	e8 51 07 00 00       	call   801016e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f93:	8b 43 14             	mov    0x14(%ebx),%eax
80100f96:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f9e:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa1:	89 04 24             	mov    %eax,(%esp)
80100fa4:	e8 e7 09 00 00       	call   80101990 <readi>
80100fa9:	85 c0                	test   %eax,%eax
80100fab:	89 c6                	mov    %eax,%esi
80100fad:	7e 03                	jle    80100fb2 <fileread+0x52>
      f->off += r;
80100faf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb5:	89 04 24             	mov    %eax,(%esp)
80100fb8:	e8 03 08 00 00       	call   801017c0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbd:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fbf:	83 c4 1c             	add    $0x1c,%esp
80100fc2:	5b                   	pop    %ebx
80100fc3:	5e                   	pop    %esi
80100fc4:	5f                   	pop    %edi
80100fc5:	5d                   	pop    %ebp
80100fc6:	c3                   	ret    
80100fc7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fc8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fcb:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fce:	83 c4 1c             	add    $0x1c,%esp
80100fd1:	5b                   	pop    %ebx
80100fd2:	5e                   	pop    %esi
80100fd3:	5f                   	pop    %edi
80100fd4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fd5:	e9 36 24 00 00       	jmp    80103410 <piperead>
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fe5:	eb d8                	jmp    80100fbf <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fe7:	c7 04 24 1e 78 10 80 	movl   $0x8010781e,(%esp)
80100fee:	e8 6d f3 ff ff       	call   80100360 <panic>
80100ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 2c             	sub    $0x2c,%esp
80101009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010100f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101012:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101015:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010101c:	0f 84 ae 00 00 00    	je     801010d0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 07                	mov    (%edi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c2 00 00 00    	je     801010ef <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d7 00 00 00    	jne    8010110d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101039:	31 db                	xor    %ebx,%ebx
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 31                	jg     80101070 <filewrite+0x70>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101048:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010104b:	01 47 14             	add    %eax,0x14(%edi)
8010104e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101051:	89 0c 24             	mov    %ecx,(%esp)
80101054:	e8 67 07 00 00       	call   801017c0 <iunlock>
      end_op();
80101059:	e8 52 1b 00 00       	call   80102bb0 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101061:	39 f0                	cmp    %esi,%eax
80101063:	0f 85 98 00 00 00    	jne    80101101 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101069:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010106b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010106e:	7e 70                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101070:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101073:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101078:	29 de                	sub    %ebx,%esi
8010107a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101080:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101083:	e8 b8 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
80101088:	8b 47 10             	mov    0x10(%edi),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 4d 06 00 00       	call   801016e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101093:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101097:	8b 47 14             	mov    0x14(%edi),%eax
8010109a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010109e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a1:	01 d8                	add    %ebx,%eax
801010a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a7:	8b 47 10             	mov    0x10(%edi),%eax
801010aa:	89 04 24             	mov    %eax,(%esp)
801010ad:	e8 de 09 00 00       	call   80101a90 <writei>
801010b2:	85 c0                	test   %eax,%eax
801010b4:	7f 92                	jg     80101048 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010b6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010bc:	89 0c 24             	mov    %ecx,(%esp)
801010bf:	e8 fc 06 00 00       	call   801017c0 <iunlock>
      end_op();
801010c4:	e8 e7 1a 00 00       	call   80102bb0 <end_op>

      if(r < 0)
801010c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010cc:	85 c0                	test   %eax,%eax
801010ce:	74 91                	je     80101061 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
801010dc:	c3                   	ret    
801010dd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010e0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010e3:	89 d8                	mov    %ebx,%eax
801010e5:	75 e9                	jne    801010d0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010e7:	83 c4 2c             	add    $0x2c,%esp
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ef:	8b 47 0c             	mov    0xc(%edi),%eax
801010f2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f5:	83 c4 2c             	add    $0x2c,%esp
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010fc:	e9 1f 22 00 00       	jmp    80103320 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101101:	c7 04 24 27 78 10 80 	movl   $0x80107827,(%esp)
80101108:	e8 53 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010110d:	c7 04 24 2d 78 10 80 	movl   $0x8010782d,(%esp)
80101114:	e8 47 f2 ff ff       	call   80100360 <panic>
80101119:	66 90                	xchg   %ax,%ax
8010111b:	66 90                	xchg   %ax,%ax
8010111d:	66 90                	xchg   %ax,%ax
8010111f:	90                   	nop

80101120 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 2c             	sub    $0x2c,%esp
80101129:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010112c:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101131:	85 c0                	test   %eax,%eax
80101133:	0f 84 8c 00 00 00    	je     801011c5 <balloc+0xa5>
80101139:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101140:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101143:	89 f0                	mov    %esi,%eax
80101145:	c1 f8 0c             	sar    $0xc,%eax
80101148:	03 05 d8 19 11 80    	add    0x801119d8,%eax
8010114e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101152:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 73 ef ff ff       	call   801000d0 <bread>
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101165:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101168:	31 c0                	xor    %eax,%eax
8010116a:	eb 33                	jmp    8010119f <balloc+0x7f>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101170:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101173:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101175:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101177:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010117a:	83 e1 07             	and    $0x7,%ecx
8010117d:	bf 01 00 00 00       	mov    $0x1,%edi
80101182:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101184:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101189:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010118b:	0f b6 fb             	movzbl %bl,%edi
8010118e:	85 cf                	test   %ecx,%edi
80101190:	74 46                	je     801011d8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101192:	83 c0 01             	add    $0x1,%eax
80101195:	83 c6 01             	add    $0x1,%esi
80101198:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010119d:	74 05                	je     801011a4 <balloc+0x84>
8010119f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011a2:	72 cc                	jb     80101170 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011a7:	89 04 24             	mov    %eax,(%esp)
801011aa:	e8 31 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011af:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	3b 05 c0 19 11 80    	cmp    0x801119c0,%eax
801011bf:	0f 82 7b ff ff ff    	jb     80101140 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011c5:	c7 04 24 37 78 10 80 	movl   $0x80107837,(%esp)
801011cc:	e8 8f f1 ff ff       	call   80100360 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011d8:	09 d9                	or     %ebx,%ecx
801011da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011dd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011e1:	89 1c 24             	mov    %ebx,(%esp)
801011e4:	e8 f7 1a 00 00       	call   80102ce0 <log_write>
        brelse(bp);
801011e9:	89 1c 24             	mov    %ebx,(%esp)
801011ec:	e8 ef ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011f4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011f8:	89 04 24             	mov    %eax,(%esp)
801011fb:	e8 d0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101200:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101207:	00 
80101208:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010120f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101210:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101212:	8d 40 5c             	lea    0x5c(%eax),%eax
80101215:	89 04 24             	mov    %eax,(%esp)
80101218:	e8 73 31 00 00       	call   80104390 <memset>
  log_write(bp);
8010121d:	89 1c 24             	mov    %ebx,(%esp)
80101220:	e8 bb 1a 00 00       	call   80102ce0 <log_write>
  brelse(bp);
80101225:	89 1c 24             	mov    %ebx,(%esp)
80101228:	e8 b3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010122d:	83 c4 2c             	add    $0x2c,%esp
80101230:	89 f0                	mov    %esi,%eax
80101232:	5b                   	pop    %ebx
80101233:	5e                   	pop    %esi
80101234:	5f                   	pop    %edi
80101235:	5d                   	pop    %ebp
80101236:	c3                   	ret    
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101240 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	89 c7                	mov    %eax,%edi
80101246:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101247:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101249:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010124f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101252:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101259:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010125c:	e8 ef 2f 00 00       	call   80104250 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101264:	eb 14                	jmp    8010127a <iget+0x3a>
80101266:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 f6                	test   %esi,%esi
8010126a:	74 3c                	je     801012a8 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101272:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101278:	74 46                	je     801012c0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010127a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010127d:	85 c9                	test   %ecx,%ecx
8010127f:	7e e7                	jle    80101268 <iget+0x28>
80101281:	39 3b                	cmp    %edi,(%ebx)
80101283:	75 e3                	jne    80101268 <iget+0x28>
80101285:	39 53 04             	cmp    %edx,0x4(%ebx)
80101288:	75 de                	jne    80101268 <iget+0x28>
      ip->ref++;
8010128a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010128d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010128f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101296:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101299:	e8 a2 30 00 00       	call   80104340 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010129e:	83 c4 1c             	add    $0x1c,%esp
801012a1:	89 f0                	mov    %esi,%eax
801012a3:	5b                   	pop    %ebx
801012a4:	5e                   	pop    %esi
801012a5:	5f                   	pop    %edi
801012a6:	5d                   	pop    %ebp
801012a7:	c3                   	ret    
801012a8:	85 c9                	test   %ecx,%ecx
801012aa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ad:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012b9:	75 bf                	jne    8010127a <iget+0x3a>
801012bb:	90                   	nop
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012c0:	85 f6                	test   %esi,%esi
801012c2:	74 29                	je     801012ed <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012c4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012c9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012d7:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801012de:	e8 5d 30 00 00       	call   80104340 <release>

  return ip;
}
801012e3:	83 c4 1c             	add    $0x1c,%esp
801012e6:	89 f0                	mov    %esi,%eax
801012e8:	5b                   	pop    %ebx
801012e9:	5e                   	pop    %esi
801012ea:	5f                   	pop    %edi
801012eb:	5d                   	pop    %ebp
801012ec:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012ed:	c7 04 24 4d 78 10 80 	movl   $0x8010784d,(%esp)
801012f4:	e8 67 f0 ff ff       	call   80100360 <panic>
801012f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101300 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	89 c3                	mov    %eax,%ebx
80101308:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010130b:	83 fa 0b             	cmp    $0xb,%edx
8010130e:	77 18                	ja     80101328 <bmap+0x28>
80101310:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101313:	8b 46 5c             	mov    0x5c(%esi),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 66                	je     80101380 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010131a:	83 c4 1c             	add    $0x1c,%esp
8010131d:	5b                   	pop    %ebx
8010131e:	5e                   	pop    %esi
8010131f:	5f                   	pop    %edi
80101320:	5d                   	pop    %ebp
80101321:	c3                   	ret    
80101322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101328:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010132b:	83 fe 7f             	cmp    $0x7f,%esi
8010132e:	77 77                	ja     801013a7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101330:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101336:	85 c0                	test   %eax,%eax
80101338:	74 5e                	je     80101398 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010133a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010133e:	8b 03                	mov    (%ebx),%eax
80101340:	89 04 24             	mov    %eax,(%esp)
80101343:	e8 88 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101348:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010134c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010134e:	8b 32                	mov    (%edx),%esi
80101350:	85 f6                	test   %esi,%esi
80101352:	75 19                	jne    8010136d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101354:	8b 03                	mov    (%ebx),%eax
80101356:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101359:	e8 c2 fd ff ff       	call   80101120 <balloc>
8010135e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101361:	89 02                	mov    %eax,(%edx)
80101363:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101365:	89 3c 24             	mov    %edi,(%esp)
80101368:	e8 73 19 00 00       	call   80102ce0 <log_write>
    }
    brelse(bp);
8010136d:	89 3c 24             	mov    %edi,(%esp)
80101370:	e8 6b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101375:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101378:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
8010137f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 03                	mov    (%ebx),%eax
80101382:	e8 99 fd ff ff       	call   80101120 <balloc>
80101387:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	83 c4 1c             	add    $0x1c,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101398:	8b 03                	mov    (%ebx),%eax
8010139a:	e8 81 fd ff ff       	call   80101120 <balloc>
8010139f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013a5:	eb 93                	jmp    8010133a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013a7:	c7 04 24 5d 78 10 80 	movl   $0x8010785d,(%esp)
801013ae:	e8 ad ef ff ff       	call   80100360 <panic>
801013b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013c8:	8b 45 08             	mov    0x8(%ebp),%eax
801013cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013d2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013d6:	89 04 24             	mov    %eax,(%esp)
801013d9:	e8 f2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013de:	89 34 24             	mov    %esi,(%esp)
801013e1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013e8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013e9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013eb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f2:	e8 39 30 00 00       	call   80104430 <memmove>
  brelse(bp);
801013f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101400:	e9 db ed ff ff       	jmp    801001e0 <brelse>
80101405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	89 d7                	mov    %edx,%edi
80101416:	56                   	push   %esi
80101417:	53                   	push   %ebx
80101418:	89 c3                	mov    %eax,%ebx
8010141a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010141d:	89 04 24             	mov    %eax,(%esp)
80101420:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
80101427:	80 
80101428:	e8 93 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010142d:	89 fa                	mov    %edi,%edx
8010142f:	c1 ea 0c             	shr    $0xc,%edx
80101432:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101438:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010143b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101440:	89 54 24 04          	mov    %edx,0x4(%esp)
80101444:	e8 87 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101449:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010144b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101451:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101453:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101456:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101459:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010145b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010145d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101462:	0f b6 c8             	movzbl %al,%ecx
80101465:	85 d9                	test   %ebx,%ecx
80101467:	74 20                	je     80101489 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101469:	f7 d3                	not    %ebx
8010146b:	21 c3                	and    %eax,%ebx
8010146d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101471:	89 34 24             	mov    %esi,(%esp)
80101474:	e8 67 18 00 00       	call   80102ce0 <log_write>
  brelse(bp);
80101479:	89 34 24             	mov    %esi,(%esp)
8010147c:	e8 5f ed ff ff       	call   801001e0 <brelse>
}
80101481:	83 c4 1c             	add    $0x1c,%esp
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101489:	c7 04 24 70 78 10 80 	movl   $0x80107870,(%esp)
80101490:	e8 cb ee ff ff       	call   80100360 <panic>
80101495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014a9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ac:	c7 44 24 04 83 78 10 	movl   $0x80107883,0x4(%esp)
801014b3:	80 
801014b4:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801014bb:	e8 a0 2c 00 00       	call   80104160 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	89 1c 24             	mov    %ebx,(%esp)
801014c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c9:	c7 44 24 04 8a 78 10 	movl   $0x8010788a,0x4(%esp)
801014d0:	80 
801014d1:	e8 7a 2b 00 00       	call   80104050 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014d6:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014dc:	75 e2                	jne    801014c0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014de:	8b 45 08             	mov    0x8(%ebp),%eax
801014e1:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
801014e8:	80 
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 cf fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014f1:	a1 d8 19 11 80       	mov    0x801119d8,%eax
801014f6:	c7 04 24 f0 78 10 80 	movl   $0x801078f0,(%esp)
801014fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101501:	a1 d4 19 11 80       	mov    0x801119d4,%eax
80101506:	89 44 24 18          	mov    %eax,0x18(%esp)
8010150a:	a1 d0 19 11 80       	mov    0x801119d0,%eax
8010150f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101513:	a1 cc 19 11 80       	mov    0x801119cc,%eax
80101518:	89 44 24 10          	mov    %eax,0x10(%esp)
8010151c:	a1 c8 19 11 80       	mov    0x801119c8,%eax
80101521:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101525:	a1 c4 19 11 80       	mov    0x801119c4,%eax
8010152a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010152e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101533:	89 44 24 04          	mov    %eax,0x4(%esp)
80101537:	e8 14 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010153c:	83 c4 24             	add    $0x24,%esp
8010153f:	5b                   	pop    %ebx
80101540:	5d                   	pop    %ebp
80101541:	c3                   	ret    
80101542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 2c             	sub    $0x2c,%esp
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101563:	8b 7d 08             	mov    0x8(%ebp),%edi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 a2 00 00 00    	jbe    80101611 <ialloc+0xc1>
8010156f:	be 01 00 00 00       	mov    $0x1,%esi
80101574:	bb 01 00 00 00       	mov    $0x1,%ebx
80101579:	eb 1a                	jmp    80101595 <ialloc+0x45>
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101580:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101586:	e8 55 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010158b:	89 de                	mov    %ebx,%esi
8010158d:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
80101593:	73 7c                	jae    80101611 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101595:	89 f0                	mov    %esi,%eax
80101597:	c1 e8 03             	shr    $0x3,%eax
8010159a:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015a0:	89 3c 24             	mov    %edi,(%esp)
801015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 f0                	mov    %esi,%eax
801015b0:	83 e0 07             	and    $0x7,%eax
801015b3:	c1 e0 06             	shl    $0x6,%eax
801015b6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ba:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015be:	75 c0                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c0:	89 0c 24             	mov    %ecx,(%esp)
801015c3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ca:	00 
801015cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015d2:	00 
801015d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015d9:	e8 b2 2d 00 00       	call   80104390 <memset>
      dip->type = type;
801015de:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015eb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ee:	89 14 24             	mov    %edx,(%esp)
801015f1:	e8 ea 16 00 00       	call   80102ce0 <log_write>
      brelse(bp);
801015f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015f9:	89 14 24             	mov    %edx,(%esp)
801015fc:	e8 df eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101601:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101604:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101606:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101607:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101609:	5e                   	pop    %esi
8010160a:	5f                   	pop    %edi
8010160b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010160c:	e9 2f fc ff ff       	jmp    80101240 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101611:	c7 04 24 90 78 10 80 	movl   $0x80107890,(%esp)
80101618:	e8 43 ed ff ff       	call   80100360 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 10             	sub    $0x10,%esp
80101628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010162b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101631:	c1 e8 03             	shr    $0x3,%eax
80101634:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 87 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101649:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010164c:	83 e2 07             	and    $0x7,%edx
8010164f:	c1 e2 06             	shl    $0x6,%edx
80101652:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101656:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101658:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010165f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101663:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101667:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010166b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010166f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101673:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101677:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010167b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010167e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101681:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101685:	89 14 24             	mov    %edx,(%esp)
80101688:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010168f:	00 
80101690:	e8 9b 2d 00 00       	call   80104430 <memmove>
  log_write(bp);
80101695:	89 34 24             	mov    %esi,(%esp)
80101698:	e8 43 16 00 00       	call   80102ce0 <log_write>
  brelse(bp);
8010169d:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016a6:	e9 35 eb ff ff       	jmp    801001e0 <brelse>
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	83 ec 14             	sub    $0x14,%esp
801016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ba:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016c1:	e8 8a 2b 00 00       	call   80104250 <acquire>
  ip->ref++;
801016c6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ca:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016d1:	e8 6a 2c 00 00       	call   80104340 <release>
  return ip;
}
801016d6:	83 c4 14             	add    $0x14,%esp
801016d9:	89 d8                	mov    %ebx,%eax
801016db:	5b                   	pop    %ebx
801016dc:	5d                   	pop    %ebp
801016dd:	c3                   	ret    
801016de:	66 90                	xchg   %ax,%ax

801016e0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	83 ec 10             	sub    $0x10,%esp
801016e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016eb:	85 db                	test   %ebx,%ebx
801016ed:	0f 84 b3 00 00 00    	je     801017a6 <ilock+0xc6>
801016f3:	8b 53 08             	mov    0x8(%ebx),%edx
801016f6:	85 d2                	test   %edx,%edx
801016f8:	0f 8e a8 00 00 00    	jle    801017a6 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101701:	89 04 24             	mov    %eax,(%esp)
80101704:	e8 87 29 00 00       	call   80104090 <acquiresleep>

  if(ip->valid == 0){
80101709:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010170c:	85 c0                	test   %eax,%eax
8010170e:	74 08                	je     80101718 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101710:	83 c4 10             	add    $0x10,%esp
80101713:	5b                   	pop    %ebx
80101714:	5e                   	pop    %esi
80101715:	5d                   	pop    %ebp
80101716:	c3                   	ret    
80101717:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	8b 43 04             	mov    0x4(%ebx),%eax
8010171b:	c1 e8 03             	shr    $0x3,%eax
8010171e:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101724:	89 44 24 04          	mov    %eax,0x4(%esp)
80101728:	8b 03                	mov    (%ebx),%eax
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 9e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101732:	8b 53 04             	mov    0x4(%ebx),%edx
80101735:	83 e2 07             	and    $0x7,%edx
80101738:	c1 e2 06             	shl    $0x6,%edx
8010173b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101741:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101744:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101747:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010174b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010174f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101753:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101757:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010175b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010175f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101763:	8b 42 fc             	mov    -0x4(%edx),%eax
80101766:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101769:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010176c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101770:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101777:	00 
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 b0 2c 00 00       	call   80104430 <memmove>
    brelse(bp);
80101780:	89 34 24             	mov    %esi,(%esp)
80101783:	e8 58 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101788:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010178d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101794:	0f 85 76 ff ff ff    	jne    80101710 <ilock+0x30>
      panic("ilock: no type");
8010179a:	c7 04 24 a8 78 10 80 	movl   $0x801078a8,(%esp)
801017a1:	e8 ba eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017a6:	c7 04 24 a2 78 10 80 	movl   $0x801078a2,(%esp)
801017ad:	e8 ae eb ff ff       	call   80100360 <panic>
801017b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017c0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	74 24                	je     801017f3 <iunlock+0x33>
801017cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017d2:	89 34 24             	mov    %esi,(%esp)
801017d5:	e8 56 29 00 00       	call   80104130 <holdingsleep>
801017da:	85 c0                	test   %eax,%eax
801017dc:	74 15                	je     801017f3 <iunlock+0x33>
801017de:	8b 43 08             	mov    0x8(%ebx),%eax
801017e1:	85 c0                	test   %eax,%eax
801017e3:	7e 0e                	jle    801017f3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017e5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	5b                   	pop    %ebx
801017ec:	5e                   	pop    %esi
801017ed:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ee:	e9 fd 28 00 00       	jmp    801040f0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017f3:	c7 04 24 b7 78 10 80 	movl   $0x801078b7,(%esp)
801017fa:	e8 61 eb ff ff       	call   80100360 <panic>
801017ff:	90                   	nop

80101800 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 1c             	sub    $0x1c,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010180c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010180f:	89 3c 24             	mov    %edi,(%esp)
80101812:	e8 79 28 00 00       	call   80104090 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101817:	8b 56 4c             	mov    0x4c(%esi),%edx
8010181a:	85 d2                	test   %edx,%edx
8010181c:	74 07                	je     80101825 <iput+0x25>
8010181e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101823:	74 2b                	je     80101850 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101825:	89 3c 24             	mov    %edi,(%esp)
80101828:	e8 c3 28 00 00       	call   801040f0 <releasesleep>

  acquire(&icache.lock);
8010182d:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101834:	e8 17 2a 00 00       	call   80104250 <acquire>
  ip->ref--;
80101839:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010183d:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101844:	83 c4 1c             	add    $0x1c,%esp
80101847:	5b                   	pop    %ebx
80101848:	5e                   	pop    %esi
80101849:	5f                   	pop    %edi
8010184a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010184b:	e9 f0 2a 00 00       	jmp    80104340 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101850:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101857:	e8 f4 29 00 00       	call   80104250 <acquire>
    int r = ip->ref;
8010185c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010185f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101866:	e8 d5 2a 00 00       	call   80104340 <release>
    if(r == 1){
8010186b:	83 fb 01             	cmp    $0x1,%ebx
8010186e:	75 b5                	jne    80101825 <iput+0x25>
80101870:	8d 4e 30             	lea    0x30(%esi),%ecx
80101873:	89 f3                	mov    %esi,%ebx
80101875:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x87>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fb                	cmp    %edi,%ebx
80101885:	74 19                	je     801018a0 <iput+0xa0>
    if(ip->addrs[i]){
80101887:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010188a:	85 d2                	test   %edx,%edx
8010188c:	74 f2                	je     80101880 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010188e:	8b 06                	mov    (%esi),%eax
80101890:	e8 7b fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101895:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010189c:	eb e2                	jmp    80101880 <iput+0x80>
8010189e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 2b                	jne    801018d8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ad:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018b4:	89 34 24             	mov    %esi,(%esp)
801018b7:	e8 64 fd ff ff       	call   80101620 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018bc:	31 c0                	xor    %eax,%eax
801018be:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018c2:	89 34 24             	mov    %esi,(%esp)
801018c5:	e8 56 fd ff ff       	call   80101620 <iupdate>
      ip->valid = 0;
801018ca:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018d1:	e9 4f ff ff ff       	jmp    80101825 <iput+0x25>
801018d6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018dc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	89 04 24             	mov    %eax,(%esp)
801018e3:	e8 e8 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018e8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018eb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018f1:	89 cf                	mov    %ecx,%edi
801018f3:	31 c0                	xor    %eax,%eax
801018f5:	eb 0e                	jmp    80101905 <iput+0x105>
801018f7:	90                   	nop
801018f8:	83 c3 01             	add    $0x1,%ebx
801018fb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101901:	89 d8                	mov    %ebx,%eax
80101903:	74 10                	je     80101915 <iput+0x115>
      if(a[j])
80101905:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101908:	85 d2                	test   %edx,%edx
8010190a:	74 ec                	je     801018f8 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010190c:	8b 06                	mov    (%esi),%eax
8010190e:	e8 fd fa ff ff       	call   80101410 <bfree>
80101913:	eb e3                	jmp    801018f8 <iput+0xf8>
    }
    brelse(bp);
80101915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101918:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010191b:	89 04 24             	mov    %eax,(%esp)
8010191e:	e8 bd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101923:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101929:	8b 06                	mov    (%esi),%eax
8010192b:	e8 e0 fa ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101930:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101937:	00 00 00 
8010193a:	e9 6e ff ff ff       	jmp    801018ad <iput+0xad>
8010193f:	90                   	nop

80101940 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 14             	sub    $0x14,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	89 1c 24             	mov    %ebx,(%esp)
8010194d:	e8 6e fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101955:	83 c4 14             	add    $0x14,%esp
80101958:	5b                   	pop    %ebx
80101959:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010195a:	e9 a1 fe ff ff       	jmp    80101800 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 2c             	sub    $0x2c,%esp
80101999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010199c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010199f:	8b 75 10             	mov    0x10(%ebp),%esi
801019a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b0:	0f 84 aa 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b6:	8b 47 58             	mov    0x58(%edi),%eax
801019b9:	39 f0                	cmp    %esi,%eax
801019bb:	0f 82 c7 00 00 00    	jb     80101a88 <readi+0xf8>
801019c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019c4:	89 da                	mov    %ebx,%edx
801019c6:	01 f2                	add    %esi,%edx
801019c8:	0f 82 ba 00 00 00    	jb     80101a88 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ce:	89 c1                	mov    %eax,%ecx
801019d0:	29 f1                	sub    %esi,%ecx
801019d2:	39 d0                	cmp    %edx,%eax
801019d4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d7:	31 c0                	xor    %eax,%eax
801019d9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	74 70                	je     80101a50 <readi+0xc0>
801019e0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019e3:	89 c7                	mov    %eax,%edi
801019e5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019eb:	89 f2                	mov    %esi,%edx
801019ed:	c1 ea 09             	shr    $0x9,%edx
801019f0:	89 d8                	mov    %ebx,%eax
801019f2:	e8 09 f9 ff ff       	call   80101300 <bmap>
801019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019fb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a02:	89 04 24             	mov    %eax,(%esp)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a0d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a11:	89 f0                	mov    %esi,%eax
80101a13:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a18:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2e:	01 df                	add    %ebx,%edi
80101a30:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a35:	89 04 24             	mov    %eax,(%esp)
80101a38:	e8 f3 29 00 00       	call   80104430 <memmove>
    brelse(bp);
80101a3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a40:	89 14 24             	mov    %edx,(%esp)
80101a43:	e8 98 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a48:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a4e:	77 98                	ja     801019e8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a53:	83 c4 2c             	add    $0x2c,%esp
80101a56:	5b                   	pop    %ebx
80101a57:	5e                   	pop    %esi
80101a58:	5f                   	pop    %edi
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 1e                	ja     80101a88 <readi+0xf8>
80101a6a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 13                	je     80101a88 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a75:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a78:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a7b:	83 c4 2c             	add    $0x2c,%esp
80101a7e:	5b                   	pop    %ebx
80101a7f:	5e                   	pop    %esi
80101a80:	5f                   	pop    %edi
80101a81:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a82:	ff e0                	jmp    *%eax
80101a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a8d:	eb c4                	jmp    80101a53 <readi+0xc3>
80101a8f:	90                   	nop

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 2c             	sub    $0x2c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	8b 75 10             	mov    0x10(%ebp),%esi
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 e3 00 00 00    	jb     80101ba8 <writei+0x118>
80101ac5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ac8:	89 c8                	mov    %ecx,%eax
80101aca:	01 f0                	add    %esi,%eax
80101acc:	0f 82 d6 00 00 00    	jb     80101ba8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad7:	0f 87 cb 00 00 00    	ja     80101ba8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101add:	85 c9                	test   %ecx,%ecx
80101adf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ae6:	74 77                	je     80101b5f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aeb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aed:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af2:	c1 ea 09             	shr    $0x9,%edx
80101af5:	89 f8                	mov    %edi,%eax
80101af7:	e8 04 f8 ff ff       	call   80101300 <bmap>
80101afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b00:	8b 07                	mov    (%edi),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b0d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b10:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b13:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b15:	89 f0                	mov    %esi,%eax
80101b17:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1c:	29 c3                	sub    %eax,%ebx
80101b1e:	39 cb                	cmp    %ecx,%ebx
80101b20:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b27:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b29:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b31:	89 04 24             	mov    %eax,(%esp)
80101b34:	e8 f7 28 00 00       	call   80104430 <memmove>
    log_write(bp);
80101b39:	89 3c 24             	mov    %edi,(%esp)
80101b3c:	e8 9f 11 00 00       	call   80102ce0 <log_write>
    brelse(bp);
80101b41:	89 3c 24             	mov    %edi,(%esp)
80101b44:	e8 97 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b49:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b4f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b52:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b55:	77 91                	ja     80101ae8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b5d:	72 39                	jb     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b62:	83 c4 2c             	add    $0x2c,%esp
80101b65:	5b                   	pop    %ebx
80101b66:	5e                   	pop    %esi
80101b67:	5f                   	pop    %edi
80101b68:	5d                   	pop    %ebp
80101b69:	c3                   	ret    
80101b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 2e                	ja     80101ba8 <writei+0x118>
80101b7a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 23                	je     80101ba8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b9e:	89 04 24             	mov    %eax,(%esp)
80101ba1:	e8 7a fa ff ff       	call   80101620 <iupdate>
80101ba6:	eb b7                	jmp    80101b5f <writei+0xcf>
  }
  return n;
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bb0:	5b                   	pop    %ebx
80101bb1:	5e                   	pop    %esi
80101bb2:	5f                   	pop    %edi
80101bb3:	5d                   	pop    %ebp
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bd0:	00 
80101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 d0 28 00 00       	call   801044b0 <strncmp>
}
80101be0:	c9                   	leave  
80101be1:	c3                   	ret    
80101be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 97 00 00 00    	jne    80101c9e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	75 0d                	jne    80101c20 <dirlookup+0x30>
80101c13:	eb 73                	jmp    80101c88 <dirlookup+0x98>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
80101c18:	83 c7 10             	add    $0x10,%edi
80101c1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c1e:	76 68                	jbe    80101c88 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c20:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c27:	00 
80101c28:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c30:	89 1c 24             	mov    %ebx,(%esp)
80101c33:	e8 58 fd ff ff       	call   80101990 <readi>
80101c38:	83 f8 10             	cmp    $0x10,%eax
80101c3b:	75 55                	jne    80101c92 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c3d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c42:	74 d4                	je     80101c18 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c55:	00 
80101c56:	89 04 24             	mov    %eax,(%esp)
80101c59:	e8 52 28 00 00       	call   801044b0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	75 b6                	jne    80101c18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c62:	8b 45 10             	mov    0x10(%ebp),%eax
80101c65:	85 c0                	test   %eax,%eax
80101c67:	74 05                	je     80101c6e <dirlookup+0x7e>
        *poff = off;
80101c69:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c72:	8b 03                	mov    (%ebx),%eax
80101c74:	e8 c7 f5 ff ff       	call   80101240 <iget>
    }
  }

  return 0;
}
80101c79:	83 c4 2c             	add    $0x2c,%esp
80101c7c:	5b                   	pop    %ebx
80101c7d:	5e                   	pop    %esi
80101c7e:	5f                   	pop    %edi
80101c7f:	5d                   	pop    %ebp
80101c80:	c3                   	ret    
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c8b:	31 c0                	xor    %eax,%eax
}
80101c8d:	5b                   	pop    %ebx
80101c8e:	5e                   	pop    %esi
80101c8f:	5f                   	pop    %edi
80101c90:	5d                   	pop    %ebp
80101c91:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c92:	c7 04 24 d1 78 10 80 	movl   $0x801078d1,(%esp)
80101c99:	e8 c2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c9e:	c7 04 24 bf 78 10 80 	movl   $0x801078bf,(%esp)
80101ca5:	e8 b6 e6 ff ff       	call   80100360 <panic>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	89 cf                	mov    %ecx,%edi
80101cb6:	56                   	push   %esi
80101cb7:	53                   	push   %ebx
80101cb8:	89 c3                	mov    %eax,%ebx
80101cba:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cbd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cc3:	0f 84 51 01 00 00    	je     80101e1a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cc9:	e8 02 1a 00 00       	call   801036d0 <myproc>
80101cce:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cd1:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cd8:	e8 73 25 00 00       	call   80104250 <acquire>
  ip->ref++;
80101cdd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ce1:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ce8:	e8 53 26 00 00       	call   80104340 <release>
80101ced:	eb 04                	jmp    80101cf3 <namex+0x43>
80101cef:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cf3:	0f b6 03             	movzbl (%ebx),%eax
80101cf6:	3c 2f                	cmp    $0x2f,%al
80101cf8:	74 f6                	je     80101cf0 <namex+0x40>
    path++;
  if(*path == 0)
80101cfa:	84 c0                	test   %al,%al
80101cfc:	0f 84 ed 00 00 00    	je     80101def <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d02:	0f b6 03             	movzbl (%ebx),%eax
80101d05:	89 da                	mov    %ebx,%edx
80101d07:	84 c0                	test   %al,%al
80101d09:	0f 84 b1 00 00 00    	je     80101dc0 <namex+0x110>
80101d0f:	3c 2f                	cmp    $0x2f,%al
80101d11:	75 0f                	jne    80101d22 <namex+0x72>
80101d13:	e9 a8 00 00 00       	jmp    80101dc0 <namex+0x110>
80101d18:	3c 2f                	cmp    $0x2f,%al
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d20:	74 0a                	je     80101d2c <namex+0x7c>
    path++;
80101d22:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d25:	0f b6 02             	movzbl (%edx),%eax
80101d28:	84 c0                	test   %al,%al
80101d2a:	75 ec                	jne    80101d18 <namex+0x68>
80101d2c:	89 d1                	mov    %edx,%ecx
80101d2e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d30:	83 f9 0d             	cmp    $0xd,%ecx
80101d33:	0f 8e 8f 00 00 00    	jle    80101dc8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d3d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d44:	00 
80101d45:	89 3c 24             	mov    %edi,(%esp)
80101d48:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d4b:	e8 e0 26 00 00       	call   80104430 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d53:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d55:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d58:	75 0e                	jne    80101d68 <namex+0xb8>
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d63:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d66:	74 f8                	je     80101d60 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d68:	89 34 24             	mov    %esi,(%esp)
80101d6b:	e8 70 f9 ff ff       	call   801016e0 <ilock>
    if(ip->type != T_DIR){
80101d70:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d75:	0f 85 85 00 00 00    	jne    80101e00 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d7e:	85 d2                	test   %edx,%edx
80101d80:	74 09                	je     80101d8b <namex+0xdb>
80101d82:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d85:	0f 84 a5 00 00 00    	je     80101e30 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d92:	00 
80101d93:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 51 fe ff ff       	call   80101bf0 <dirlookup>
80101d9f:	85 c0                	test   %eax,%eax
80101da1:	74 5d                	je     80101e00 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101da3:	89 34 24             	mov    %esi,(%esp)
80101da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101da9:	e8 12 fa ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101dae:	89 34 24             	mov    %esi,(%esp)
80101db1:	e8 4a fa ff ff       	call   80101800 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	89 c6                	mov    %eax,%esi
80101dbb:	e9 33 ff ff ff       	jmp    80101cf3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dc0:	31 c9                	xor    %ecx,%ecx
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101dc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dd6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dd9:	e8 52 26 00 00       	call   80104430 <memmove>
    name[len] = 0;
80101dde:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101de4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101de8:	89 d3                	mov    %edx,%ebx
80101dea:	e9 66 ff ff ff       	jmp    80101d55 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101def:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101df2:	85 c0                	test   %eax,%eax
80101df4:	75 4c                	jne    80101e42 <namex+0x192>
80101df6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 b8 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101e08:	89 34 24             	mov    %esi,(%esp)
80101e0b:	e8 f0 f9 ff ff       	call   80101800 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e10:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e13:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e15:	5b                   	pop    %ebx
80101e16:	5e                   	pop    %esi
80101e17:	5f                   	pop    %edi
80101e18:	5d                   	pop    %ebp
80101e19:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e1a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e24:	e8 17 f4 ff ff       	call   80101240 <iget>
80101e29:	89 c6                	mov    %eax,%esi
80101e2b:	e9 c3 fe ff ff       	jmp    80101cf3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e30:	89 34 24             	mov    %esi,(%esp)
80101e33:	e8 88 f9 ff ff       	call   801017c0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e38:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e3b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e3d:	5b                   	pop    %ebx
80101e3e:	5e                   	pop    %esi
80101e3f:	5f                   	pop    %edi
80101e40:	5d                   	pop    %ebp
80101e41:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e42:	89 34 24             	mov    %esi,(%esp)
80101e45:	e8 b6 f9 ff ff       	call   80101800 <iput>
    return 0;
80101e4a:	31 c0                	xor    %eax,%eax
80101e4c:	eb aa                	jmp    80101df8 <namex+0x148>
80101e4e:	66 90                	xchg   %ax,%ax

80101e50 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 2c             	sub    $0x2c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e66:	00 
80101e67:	89 1c 24             	mov    %ebx,(%esp)
80101e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6e:	e8 7d fd ff ff       	call   80101bf0 <dirlookup>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	0f 85 8b 00 00 00    	jne    80101f06 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7e:	31 ff                	xor    %edi,%edi
80101e80:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e83:	85 c0                	test   %eax,%eax
80101e85:	75 13                	jne    80101e9a <dirlink+0x4a>
80101e87:	eb 35                	jmp    80101ebe <dirlink+0x6e>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8d 57 10             	lea    0x10(%edi),%edx
80101e93:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e96:	89 d7                	mov    %edx,%edi
80101e98:	76 24                	jbe    80101ebe <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea1:	00 
80101ea2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eaa:	89 1c 24             	mov    %ebx,(%esp)
80101ead:	e8 de fa ff ff       	call   80101990 <readi>
80101eb2:	83 f8 10             	cmp    $0x10,%eax
80101eb5:	75 5e                	jne    80101f15 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101eb7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ebc:	75 d2                	jne    80101e90 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ec8:	00 
80101ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 48 26 00 00       	call   80104520 <strncpy>
  de.inum = inum;
80101ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101edb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ee2:	00 
80101ee3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eeb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eee:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef2:	e8 99 fb ff ff       	call   80101a90 <writei>
80101ef7:	83 f8 10             	cmp    $0x10,%eax
80101efa:	75 25                	jne    80101f21 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101efc:	31 c0                	xor    %eax,%eax
}
80101efe:	83 c4 2c             	add    $0x2c,%esp
80101f01:	5b                   	pop    %ebx
80101f02:	5e                   	pop    %esi
80101f03:	5f                   	pop    %edi
80101f04:	5d                   	pop    %ebp
80101f05:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f06:	89 04 24             	mov    %eax,(%esp)
80101f09:	e8 f2 f8 ff ff       	call   80101800 <iput>
    return -1;
80101f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f13:	eb e9                	jmp    80101efe <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f15:	c7 04 24 e0 78 10 80 	movl   $0x801078e0,(%esp)
80101f1c:	e8 3f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f21:	c7 04 24 e6 7e 10 80 	movl   $0x80107ee6,(%esp)
80101f28:	e8 33 e4 ff ff       	call   80100360 <panic>
80101f2d:	8d 76 00             	lea    0x0(%esi),%esi

80101f30 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f30:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f31:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f33:	89 e5                	mov    %esp,%ebp
80101f35:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f38:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f3e:	e8 6d fd ff ff       	call   80101cb0 <namex>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f50:	55                   	push   %ebp
  return namex(path, 1, name);
80101f51:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f56:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f5e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f5f:	e9 4c fd ff ff       	jmp    80101cb0 <namex>
80101f64:	66 90                	xchg   %ax,%ax
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	66 90                	xchg   %ax,%ax
80101f6a:	66 90                	xchg   %ax,%ax
80101f6c:	66 90                	xchg   %ax,%ax
80101f6e:	66 90                	xchg   %ax,%ax

80101f70 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	56                   	push   %esi
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	53                   	push   %ebx
80101f77:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	0f 84 99 00 00 00    	je     8010201b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f82:	8b 48 08             	mov    0x8(%eax),%ecx
80101f85:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f8b:	0f 87 7e 00 00 00    	ja     8010200f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f91:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f99:	83 e0 c0             	and    $0xffffffc0,%eax
80101f9c:	3c 40                	cmp    $0x40,%al
80101f9e:	75 f8                	jne    80101f98 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa0:	31 db                	xor    %ebx,%ebx
80101fa2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101faf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb4:	ee                   	out    %al,(%dx)
80101fb5:	0f b6 c1             	movzbl %cl,%eax
80101fb8:	b2 f3                	mov    $0xf3,%dl
80101fba:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fbb:	89 c8                	mov    %ecx,%eax
80101fbd:	b2 f4                	mov    $0xf4,%dl
80101fbf:	c1 f8 08             	sar    $0x8,%eax
80101fc2:	ee                   	out    %al,(%dx)
80101fc3:	b2 f5                	mov    $0xf5,%dl
80101fc5:	89 d8                	mov    %ebx,%eax
80101fc7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fc8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fcc:	b2 f6                	mov    $0xf6,%dl
80101fce:	83 e0 01             	and    $0x1,%eax
80101fd1:	c1 e0 04             	shl    $0x4,%eax
80101fd4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fd7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fd8:	f6 06 04             	testb  $0x4,(%esi)
80101fdb:	75 13                	jne    80101ff0 <idestart+0x80>
80101fdd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
80101fef:	90                   	nop
80101ff0:	b2 f7                	mov    $0xf7,%dl
80101ff2:	b8 30 00 00 00       	mov    $0x30,%eax
80101ff7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101ff8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101ffd:	83 c6 5c             	add    $0x5c,%esi
80102000:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102005:	fc                   	cld    
80102006:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010200f:	c7 04 24 4c 79 10 80 	movl   $0x8010794c,(%esp)
80102016:	e8 45 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010201b:	c7 04 24 43 79 10 80 	movl   $0x80107943,(%esp)
80102022:	e8 39 e3 ff ff       	call   80100360 <panic>
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102036:	c7 44 24 04 5e 79 10 	movl   $0x8010795e,0x4(%esp)
8010203d:	80 
8010203e:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102045:	e8 16 21 00 00       	call   80104160 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010204a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010204f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102056:	83 e8 01             	sub    $0x1,%eax
80102059:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205d:	e8 7e 02 00 00       	call   801022e0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102062:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102067:	90                   	nop
80102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	83 e0 c0             	and    $0xffffffc0,%eax
8010206c:	3c 40                	cmp    $0x40,%al
8010206e:	75 f8                	jne    80102068 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102070:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207a:	ee                   	out    %al,(%dx)
8010207b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102080:	b2 f7                	mov    $0xf7,%dl
80102082:	eb 09                	jmp    8010208d <ideinit+0x5d>
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102088:	83 e9 01             	sub    $0x1,%ecx
8010208b:	74 0f                	je     8010209c <ideinit+0x6c>
8010208d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010208e:	84 c0                	test   %al,%al
80102090:	74 f6                	je     80102088 <ideinit+0x58>
      havedisk1 = 1;
80102092:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102099:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010209c:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020a7:	c9                   	leave  
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801020c0:	e8 8b 21 00 00       	call   80104250 <acquire>

  if((b = idequeue) == 0){
801020c5:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020cb:	85 db                	test   %ebx,%ebx
801020cd:	74 30                	je     801020ff <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020cf:	8b 43 58             	mov    0x58(%ebx),%eax
801020d2:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020df:	74 37                	je     80102118 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e1:	83 e6 fb             	and    $0xfffffffb,%esi
801020e4:	83 ce 02             	or     $0x2,%esi
801020e7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020e9:	89 1c 24             	mov    %ebx,(%esp)
801020ec:	e8 9f 1d 00 00       	call   80103e90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020f6:	85 c0                	test   %eax,%eax
801020f8:	74 05                	je     801020ff <ideintr+0x4f>
    idestart(idequeue);
801020fa:	e8 71 fe ff ff       	call   80101f70 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020ff:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102106:	e8 35 22 00 00       	call   80104340 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010210b:	83 c4 1c             	add    $0x1c,%esp
8010210e:	5b                   	pop    %ebx
8010210f:	5e                   	pop    %esi
80102110:	5f                   	pop    %edi
80102111:	5d                   	pop    %ebp
80102112:	c3                   	ret    
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	8d 76 00             	lea    0x0(%esi),%esi
80102120:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	89 c1                	mov    %eax,%ecx
80102123:	83 e1 c0             	and    $0xffffffc0,%ecx
80102126:	80 f9 40             	cmp    $0x40,%cl
80102129:	75 f5                	jne    80102120 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010212b:	a8 21                	test   $0x21,%al
8010212d:	75 b2                	jne    801020e1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010212f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102132:	b9 80 00 00 00       	mov    $0x80,%ecx
80102137:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213c:	fc                   	cld    
8010213d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010213f:	8b 33                	mov    (%ebx),%esi
80102141:	eb 9e                	jmp    801020e1 <ideintr+0x31>
80102143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 14             	sub    $0x14,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	89 04 24             	mov    %eax,(%esp)
80102160:	e8 cb 1f 00 00       	call   80104130 <holdingsleep>
80102165:	85 c0                	test   %eax,%eax
80102167:	0f 84 9e 00 00 00    	je     8010220b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216d:	8b 03                	mov    (%ebx),%eax
8010216f:	83 e0 06             	and    $0x6,%eax
80102172:	83 f8 02             	cmp    $0x2,%eax
80102175:	0f 84 a8 00 00 00    	je     80102223 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217b:	8b 53 04             	mov    0x4(%ebx),%edx
8010217e:	85 d2                	test   %edx,%edx
80102180:	74 0d                	je     8010218f <iderw+0x3f>
80102182:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102187:	85 c0                	test   %eax,%eax
80102189:	0f 84 88 00 00 00    	je     80102217 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010218f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102196:	e8 b5 20 00 00       	call   80104250 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021a7:	85 c0                	test   %eax,%eax
801021a9:	75 07                	jne    801021b2 <iderw+0x62>
801021ab:	eb 4e                	jmp    801021fb <iderw+0xab>
801021ad:	8d 76 00             	lea    0x0(%esi),%esi
801021b0:	89 d0                	mov    %edx,%eax
801021b2:	8b 50 58             	mov    0x58(%eax),%edx
801021b5:	85 d2                	test   %edx,%edx
801021b7:	75 f7                	jne    801021b0 <iderw+0x60>
801021b9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021bc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021be:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021c4:	74 3c                	je     80102202 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c6:	8b 03                	mov    (%ebx),%eax
801021c8:	83 e0 06             	and    $0x6,%eax
801021cb:	83 f8 02             	cmp    $0x2,%eax
801021ce:	74 1a                	je     801021ea <iderw+0x9a>
    sleep(b, &idelock);
801021d0:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
801021d7:	80 
801021d8:	89 1c 24             	mov    %ebx,(%esp)
801021db:	e8 10 1b 00 00       	call   80103cf0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e0:	8b 13                	mov    (%ebx),%edx
801021e2:	83 e2 06             	and    $0x6,%edx
801021e5:	83 fa 02             	cmp    $0x2,%edx
801021e8:	75 e6                	jne    801021d0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ea:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021f1:	83 c4 14             	add    $0x14,%esp
801021f4:	5b                   	pop    %ebx
801021f5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021f6:	e9 45 21 00 00       	jmp    80104340 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021fb:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
80102200:	eb ba                	jmp    801021bc <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102202:	89 d8                	mov    %ebx,%eax
80102204:	e8 67 fd ff ff       	call   80101f70 <idestart>
80102209:	eb bb                	jmp    801021c6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010220b:	c7 04 24 62 79 10 80 	movl   $0x80107962,(%esp)
80102212:	e8 49 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102217:	c7 04 24 8d 79 10 80 	movl   $0x8010798d,(%esp)
8010221e:	e8 3d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102223:	c7 04 24 78 79 10 80 	movl   $0x80107978,(%esp)
8010222a:	e8 31 e1 ff ff       	call   80100360 <panic>
8010222f:	90                   	nop

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx
80102235:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102238:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010223f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102242:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102249:	00 00 00 
  return ioapic->data;
8010224c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102252:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102255:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010225b:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102261:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102268:	c1 e8 10             	shr    $0x10,%eax
8010226b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010226e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102271:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102274:	39 c2                	cmp    %eax,%edx
80102276:	74 12                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102278:	c7 04 24 ac 79 10 80 	movl   $0x801079ac,(%esp)
8010227f:	e8 cc e3 ff ff       	call   80100650 <cprintf>
80102284:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
8010228a:	ba 10 00 00 00       	mov    $0x10,%edx
8010228f:	31 c0                	xor    %eax,%eax
80102291:	eb 07                	jmp    8010229a <ioapicinit+0x6a>
80102293:	90                   	nop
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102298:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010229a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010229c:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
801022a2:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022ab:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ae:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022b1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022b4:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022b9:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022bf:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022c8:	7d ce                	jge    80102298 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	5b                   	pop    %ebx
801022ce:	5e                   	pop    %esi
801022cf:	5d                   	pop    %ebp
801022d0:	c3                   	ret    
801022d1:	eb 0d                	jmp    801022e0 <ioapicenable>
801022d3:	90                   	nop
801022d4:	90                   	nop
801022d5:	90                   	nop
801022d6:	90                   	nop
801022d7:	90                   	nop
801022d8:	90                   	nop
801022d9:	90                   	nop
801022da:	90                   	nop
801022db:	90                   	nop
801022dc:	90                   	nop
801022dd:	90                   	nop
801022de:	90                   	nop
801022df:	90                   	nop

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	8b 55 08             	mov    0x8(%ebp),%edx
801022e6:	53                   	push   %ebx
801022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ea:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ed:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022f1:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022fa:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fc:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102302:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102305:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102308:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010230a:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102310:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102313:	5b                   	pop    %ebx
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
80102316:	66 90                	xchg   %ax,%ax
80102318:	66 90                	xchg   %ax,%ax
8010231a:	66 90                	xchg   %ax,%ax
8010231c:	66 90                	xchg   %ax,%ax
8010231e:	66 90                	xchg   %ax,%ax

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 14             	sub    $0x14,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 7c                	jne    801023ae <kfree+0x8e>
80102332:	81 fb f4 70 11 80    	cmp    $0x801170f4,%ebx
80102338:	72 74                	jb     801023ae <kfree+0x8e>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 67                	ja     801023ae <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010234e:	00 
8010234f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102356:	00 
80102357:	89 1c 24             	mov    %ebx,(%esp)
8010235a:	e8 31 20 00 00       	call   80104390 <memset>

  if(kmem.use_lock)
8010235f:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102365:	85 d2                	test   %edx,%edx
80102367:	75 37                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102369:	a1 78 36 11 80       	mov    0x80113678,%eax
8010236e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102370:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102375:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
8010237b:	85 c0                	test   %eax,%eax
8010237d:	75 09                	jne    80102388 <kfree+0x68>
    release(&kmem.lock);
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
80102384:	c3                   	ret    
80102385:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102388:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102394:	e9 a7 1f 00 00       	jmp    80104340 <release>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023a0:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801023a7:	e8 a4 1e 00 00       	call   80104250 <acquire>
801023ac:	eb bb                	jmp    80102369 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023ae:	c7 04 24 de 79 10 80 	movl   $0x801079de,(%esp)
801023b5:	e8 a6 df ff ff       	call   80100360 <panic>
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ce:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023da:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023e0:	39 de                	cmp    %ebx,%esi
801023e2:	73 08                	jae    801023ec <freerange+0x2c>
801023e4:	eb 18                	jmp    801023fe <freerange+0x3e>
801023e6:	66 90                	xchg   %ax,%ax
801023e8:	89 da                	mov    %ebx,%edx
801023ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ec:	89 14 24             	mov    %edx,(%esp)
801023ef:	e8 2c ff ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023fa:	39 f0                	cmp    %esi,%eax
801023fc:	76 ea                	jbe    801023e8 <freerange+0x28>
    kfree(p);
}
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010241b:	c7 44 24 04 e4 79 10 	movl   $0x801079e4,0x4(%esp)
80102422:	80 
80102423:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
8010242a:	e8 31 1d 00 00       	call   80104160 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102432:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102439:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102442:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102448:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010244e:	39 de                	cmp    %ebx,%esi
80102450:	73 0a                	jae    8010245c <kinit1+0x4c>
80102452:	eb 1a                	jmp    8010246e <kinit1+0x5e>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102458:	89 da                	mov    %ebx,%edx
8010245a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010245c:	89 14 24             	mov    %edx,(%esp)
8010245f:	e8 bc fe ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102464:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010246a:	39 c6                	cmp    %eax,%esi
8010246c:	73 ea                	jae    80102458 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010246e:	83 c4 10             	add    $0x10,%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102488:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010248b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010248e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102494:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 08                	jae    801024ac <kinit2+0x2c>
801024a4:	eb 18                	jmp    801024be <kinit2+0x3e>
801024a6:	66 90                	xchg   %ax,%ax
801024a8:	89 da                	mov    %ebx,%edx
801024aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ac:	89 14 24             	mov    %edx,(%esp)
801024af:	e8 6c fe ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ba:	39 c6                	cmp    %eax,%esi
801024bc:	73 ea                	jae    801024a8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024be:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024c5:	00 00 00 
}
801024c8:	83 c4 10             	add    $0x10,%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret    
801024cf:	90                   	nop

801024d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024d7:	a1 74 36 11 80       	mov    0x80113674,%eax
801024dc:	85 c0                	test   %eax,%eax
801024de:	75 30                	jne    80102510 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e0:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024e6:	85 db                	test   %ebx,%ebx
801024e8:	74 08                	je     801024f2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ea:	8b 13                	mov    (%ebx),%edx
801024ec:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801024f2:	85 c0                	test   %eax,%eax
801024f4:	74 0c                	je     80102502 <kalloc+0x32>
    release(&kmem.lock);
801024f6:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801024fd:	e8 3e 1e 00 00       	call   80104340 <release>
  return (char*)r;
}
80102502:	83 c4 14             	add    $0x14,%esp
80102505:	89 d8                	mov    %ebx,%eax
80102507:	5b                   	pop    %ebx
80102508:	5d                   	pop    %ebp
80102509:	c3                   	ret    
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102510:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
80102517:	e8 34 1d 00 00       	call   80104250 <acquire>
8010251c:	a1 74 36 11 80       	mov    0x80113674,%eax
80102521:	eb bd                	jmp    801024e0 <kalloc+0x10>
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 ba 00 00 00    	je     801025f8 <kbdgetc+0xc8>
8010253e:	b2 60                	mov    $0x60,%dl
80102540:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102541:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102544:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010254a:	0f 84 88 00 00 00    	je     801025d8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102550:	84 c0                	test   %al,%al
80102552:	79 2c                	jns    80102580 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102554:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
8010255a:	f6 c2 40             	test   $0x40,%dl
8010255d:	75 05                	jne    80102564 <kbdgetc+0x34>
8010255f:	89 c1                	mov    %eax,%ecx
80102561:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102564:	0f b6 81 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%eax
8010256b:	83 c8 40             	or     $0x40,%eax
8010256e:	0f b6 c0             	movzbl %al,%eax
80102571:	f7 d0                	not    %eax
80102573:	21 d0                	and    %edx,%eax
80102575:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010257a:	31 c0                	xor    %eax,%eax
8010257c:	c3                   	ret    
8010257d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010258a:	f6 c3 40             	test   $0x40,%bl
8010258d:	74 09                	je     80102598 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102592:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102595:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102598:	0f b6 91 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%edx
  shift ^= togglecode[data];
8010259f:	0f b6 81 20 7a 10 80 	movzbl -0x7fef85e0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025a6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025a8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025aa:	89 d0                	mov    %edx,%eax
801025ac:	83 e0 03             	and    $0x3,%eax
801025af:	8b 04 85 00 7a 10 80 	mov    -0x7fef8600(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025b6:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025bc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025bf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025c3:	74 0b                	je     801025d0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025c5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c8:	83 fa 19             	cmp    $0x19,%edx
801025cb:	77 1b                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025cd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d0:	5b                   	pop    %ebx
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025d8:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
801025df:	31 c0                	xor    %eax,%eax
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	83 f9 19             	cmp    $0x19,%ecx
801025f1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025f4:	eb da                	jmp    801025d0 <kbdgetc+0xa0>
801025f6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102606:	c7 04 24 30 25 10 80 	movl   $0x80102530,(%esp)
8010260d:	e8 9e e1 ff ff       	call   801007b0 <consoleintr>
}
80102612:	c9                   	leave  
80102613:	c3                   	ret    
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102620:	55                   	push   %ebp
80102621:	89 c1                	mov    %eax,%ecx
80102623:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102625:	ba 70 00 00 00       	mov    $0x70,%edx
8010262a:	53                   	push   %ebx
8010262b:	31 c0                	xor    %eax,%eax
8010262d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010262e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102636:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 01                	mov    %eax,(%ecx)
8010263d:	b8 02 00 00 00       	mov    $0x2,%eax
80102642:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
80102646:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 41 04             	mov    %eax,0x4(%ecx)
8010264e:	b8 04 00 00 00       	mov    $0x4,%eax
80102653:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102654:	89 da                	mov    %ebx,%edx
80102656:	ec                   	in     (%dx),%al
80102657:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265a:	b2 70                	mov    $0x70,%dl
8010265c:	89 41 08             	mov    %eax,0x8(%ecx)
8010265f:	b8 07 00 00 00       	mov    $0x7,%eax
80102664:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102665:	89 da                	mov    %ebx,%edx
80102667:	ec                   	in     (%dx),%al
80102668:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266b:	b2 70                	mov    $0x70,%dl
8010266d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102670:	b8 08 00 00 00       	mov    $0x8,%eax
80102675:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102676:	89 da                	mov    %ebx,%edx
80102678:	ec                   	in     (%dx),%al
80102679:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267c:	b2 70                	mov    $0x70,%dl
8010267e:	89 41 10             	mov    %eax,0x10(%ecx)
80102681:	b8 09 00 00 00       	mov    $0x9,%eax
80102686:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102687:	89 da                	mov    %ebx,%edx
80102689:	ec                   	in     (%dx),%al
8010268a:	0f b6 d8             	movzbl %al,%ebx
8010268d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102690:	5b                   	pop    %ebx
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026a0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c0 00 00 00    	je     80102770 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 6f                	ja     80102778 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102758:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010275e:	80 e6 10             	and    $0x10,%dh
80102761:	75 f5                	jne    80102758 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102770:	5d                   	pop    %ebp
80102771:	c3                   	ret    
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102778:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010277f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102782:	8b 50 20             	mov    0x20(%eax),%edx
80102785:	eb 82                	jmp    80102709 <lapicinit+0x69>
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102790:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0c                	je     801027a8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010279c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010279f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801027a0:	c1 e8 18             	shr    $0x18,%eax
}
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801027a8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801027aa:	5d                   	pop    %ebp
801027ab:	c3                   	ret    
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027b0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0d                	je     801027c9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
801027cb:	90                   	nop
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
}
801027d3:	5d                   	pop    %ebp
801027d4:	c3                   	ret    
801027d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	89 e5                	mov    %esp,%ebp
801027e8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ed:	53                   	push   %ebx
801027ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027f4:	ee                   	out    %al,(%dx)
801027f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027fa:	b2 71                	mov    $0x71,%dl
801027fc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027fd:	31 c0                	xor    %eax,%eax
801027ff:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102805:	89 d8                	mov    %ebx,%eax
80102807:	c1 e8 04             	shr    $0x4,%eax
8010280a:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102810:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102815:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102818:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102824:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010282b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102831:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102838:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102847:	89 da                	mov    %ebx,%edx
80102849:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010284c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102852:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102855:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102867:	5b                   	pop    %ebx
80102868:	5d                   	pop    %ebp
80102869:	c3                   	ret    
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102870 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102870:	55                   	push   %ebp
80102871:	ba 70 00 00 00       	mov    $0x70,%edx
80102876:	89 e5                	mov    %esp,%ebp
80102878:	b8 0b 00 00 00       	mov    $0xb,%eax
8010287d:	57                   	push   %edi
8010287e:	56                   	push   %esi
8010287f:	53                   	push   %ebx
80102880:	83 ec 4c             	sub    $0x4c,%esp
80102883:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102884:	b2 71                	mov    $0x71,%dl
80102886:	ec                   	in     (%dx),%al
80102887:	88 45 b7             	mov    %al,-0x49(%ebp)
8010288a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010288d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102891:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102898:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010289d:	89 d8                	mov    %ebx,%eax
8010289f:	e8 7c fd ff ff       	call   80102620 <fill_rtcdate>
801028a4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a9:	89 f2                	mov    %esi,%edx
801028ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	ba 71 00 00 00       	mov    $0x71,%edx
801028b1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b2:	84 c0                	test   %al,%al
801028b4:	78 e7                	js     8010289d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028b6:	89 f8                	mov    %edi,%eax
801028b8:	e8 63 fd ff ff       	call   80102620 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028bd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028c4:	00 
801028c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028c9:	89 1c 24             	mov    %ebx,(%esp)
801028cc:	e8 0f 1b 00 00       	call   801043e0 <memcmp>
801028d1:	85 c0                	test   %eax,%eax
801028d3:	75 c3                	jne    80102898 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028d5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028d9:	75 78                	jne    80102953 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028db:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028de:	89 c2                	mov    %eax,%edx
801028e0:	83 e0 0f             	and    $0xf,%eax
801028e3:	c1 ea 04             	shr    $0x4,%edx
801028e6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028f2:	89 c2                	mov    %eax,%edx
801028f4:	83 e0 0f             	and    $0xf,%eax
801028f7:	c1 ea 04             	shr    $0x4,%edx
801028fa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102900:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102903:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102906:	89 c2                	mov    %eax,%edx
80102908:	83 e0 0f             	and    $0xf,%eax
8010290b:	c1 ea 04             	shr    $0x4,%edx
8010290e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102911:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102914:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	83 e0 0f             	and    $0xf,%eax
8010291f:	c1 ea 04             	shr    $0x4,%edx
80102922:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102925:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102928:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010292b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010292e:	89 c2                	mov    %eax,%edx
80102930:	83 e0 0f             	and    $0xf,%eax
80102933:	c1 ea 04             	shr    $0x4,%edx
80102936:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102939:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102942:	89 c2                	mov    %eax,%edx
80102944:	83 e0 0f             	and    $0xf,%eax
80102947:	c1 ea 04             	shr    $0x4,%edx
8010294a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102950:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102953:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102956:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102959:	89 01                	mov    %eax,(%ecx)
8010295b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010295e:	89 41 04             	mov    %eax,0x4(%ecx)
80102961:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102964:	89 41 08             	mov    %eax,0x8(%ecx)
80102967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010296a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010296d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102970:	89 41 10             	mov    %eax,0x10(%ecx)
80102973:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102976:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102979:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102980:	83 c4 4c             	add    $0x4c,%esp
80102983:	5b                   	pop    %ebx
80102984:	5e                   	pop    %esi
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
80102988:	66 90                	xchg   %ax,%ax
8010298a:	66 90                	xchg   %ax,%ax
8010298c:	66 90                	xchg   %ax,%ax
8010298e:	66 90                	xchg   %ax,%ax

80102990 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	57                   	push   %edi
80102994:	56                   	push   %esi
80102995:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102996:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102998:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010299b:	a1 c8 36 11 80       	mov    0x801136c8,%eax
801029a0:	85 c0                	test   %eax,%eax
801029a2:	7e 78                	jle    80102a1c <install_trans+0x8c>
801029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029a8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029ad:	01 d8                	add    %ebx,%eax
801029af:	83 c0 01             	add    $0x1,%eax
801029b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b6:	a1 c4 36 11 80       	mov    0x801136c4,%eax
801029bb:	89 04 24             	mov    %eax,(%esp)
801029be:	e8 0d d7 ff ff       	call   801000d0 <bread>
801029c3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c5:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029cc:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d3:	a1 c4 36 11 80       	mov    0x801136c4,%eax
801029d8:	89 04 24             	mov    %eax,(%esp)
801029db:	e8 f0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029e7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029e8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ea:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 34 1a 00 00       	call   80104430 <memmove>
    bwrite(dbuf);  // write dst to disk
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 9c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a04:	89 3c 24             	mov    %edi,(%esp)
80102a07:	e8 d4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a0c:	89 34 24             	mov    %esi,(%esp)
80102a0f:	e8 cc d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102a1a:	7f 8c                	jg     801029a8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a1c:	83 c4 1c             	add    $0x1c,%esp
80102a1f:	5b                   	pop    %ebx
80102a20:	5e                   	pop    %esi
80102a21:	5f                   	pop    %edi
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    
80102a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	57                   	push   %edi
80102a34:	56                   	push   %esi
80102a35:	53                   	push   %ebx
80102a36:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a39:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a42:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a47:	89 04 24             	mov    %eax,(%esp)
80102a4a:	e8 81 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a4f:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a55:	31 d2                	xor    %edx,%edx
80102a57:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a59:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a5b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a5e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a61:	7e 17                	jle    80102a7a <write_head+0x4a>
80102a63:	90                   	nop
80102a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a68:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102a6f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a73:	83 c2 01             	add    $0x1,%edx
80102a76:	39 da                	cmp    %ebx,%edx
80102a78:	75 ee                	jne    80102a68 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a7a:	89 3c 24             	mov    %edi,(%esp)
80102a7d:	e8 1e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a82:	89 3c 24             	mov    %edi,(%esp)
80102a85:	e8 56 d7 ff ff       	call   801001e0 <brelse>
}
80102a8a:	83 c4 1c             	add    $0x1c,%esp
80102a8d:	5b                   	pop    %ebx
80102a8e:	5e                   	pop    %esi
80102a8f:	5f                   	pop    %edi
80102a90:	5d                   	pop    %ebp
80102a91:	c3                   	ret    
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
80102aa5:	83 ec 30             	sub    $0x30,%esp
80102aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aab:	c7 44 24 04 20 7c 10 	movl   $0x80107c20,0x4(%esp)
80102ab2:	80 
80102ab3:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102aba:	e8 a1 16 00 00       	call   80104160 <initlock>
  readsb(dev, &sb);
80102abf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac6:	89 1c 24             	mov    %ebx,(%esp)
80102ac9:	e8 f2 e8 ff ff       	call   801013c0 <readsb>
  log.start = sb.logstart;
80102ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ad4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102ad7:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102add:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae1:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae7:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aec:	e8 df d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102af1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102af3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102af6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102af9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102afb:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b01:	7e 17                	jle    80102b1a <initlog+0x7a>
80102b03:	90                   	nop
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b08:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b0c:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b13:	83 c2 01             	add    $0x1,%edx
80102b16:	39 da                	cmp    %ebx,%edx
80102b18:	75 ee                	jne    80102b08 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b1a:	89 04 24             	mov    %eax,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b22:	e8 69 fe ff ff       	call   80102990 <install_trans>
  log.lh.n = 0;
80102b27:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102b2e:	00 00 00 
  write_head(); // clear the log
80102b31:	e8 fa fe ff ff       	call   80102a30 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b36:	83 c4 30             	add    $0x30,%esp
80102b39:	5b                   	pop    %ebx
80102b3a:	5e                   	pop    %esi
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b46:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b4d:	e8 fe 16 00 00       	call   80104250 <acquire>
80102b52:	eb 18                	jmp    80102b6c <begin_op+0x2c>
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	c7 44 24 04 80 36 11 	movl   $0x80113680,0x4(%esp)
80102b5f:	80 
80102b60:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b67:	e8 84 11 00 00       	call   80103cf0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b6c:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102b71:	85 c0                	test   %eax,%eax
80102b73:	75 e3                	jne    80102b58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b75:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102b7a:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102b80:	83 c0 01             	add    $0x1,%eax
80102b83:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b86:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b89:	83 fa 1e             	cmp    $0x1e,%edx
80102b8c:	7f ca                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8e:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b95:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102b9a:	e8 a1 17 00 00       	call   80104340 <release>
      break;
    }
  }
}
80102b9f:	c9                   	leave  
80102ba0:	c3                   	ret    
80102ba1:	eb 0d                	jmp    80102bb0 <end_op>
80102ba3:	90                   	nop
80102ba4:	90                   	nop
80102ba5:	90                   	nop
80102ba6:	90                   	nop
80102ba7:	90                   	nop
80102ba8:	90                   	nop
80102ba9:	90                   	nop
80102baa:	90                   	nop
80102bab:	90                   	nop
80102bac:	90                   	nop
80102bad:	90                   	nop
80102bae:	90                   	nop
80102baf:	90                   	nop

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102bc0:	e8 8b 16 00 00       	call   80104250 <acquire>
  log.outstanding -= 1;
80102bc5:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102bca:	8b 15 c0 36 11 80    	mov    0x801136c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd5:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102bda:	0f 85 f3 00 00 00    	jne    80102cd3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102be0:	85 c0                	test   %eax,%eax
80102be2:	0f 85 cb 00 00 00    	jne    80102cb3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be8:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bef:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bf1:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102bf8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bfb:	e8 40 17 00 00       	call   80104340 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c00:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c05:	85 c0                	test   %eax,%eax
80102c07:	0f 8e 90 00 00 00    	jle    80102c9d <end_op+0xed>
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c10:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c15:	01 d8                	add    %ebx,%eax
80102c17:	83 c0 01             	add    $0x1,%eax
80102c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1e:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c23:	89 04 24             	mov    %eax,(%esp)
80102c26:	e8 a5 d4 ff ff       	call   801000d0 <bread>
80102c2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c2d:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c34:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c3b:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c40:	89 04 24             	mov    %eax,(%esp)
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c48:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c4f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c50:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c52:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c55:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c59:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5c:	89 04 24             	mov    %eax,(%esp)
80102c5f:	e8 cc 17 00 00       	call   80104430 <memmove>
    bwrite(to);  // write the log
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 34 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c6c:	89 3c 24             	mov    %edi,(%esp)
80102c6f:	e8 6c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c74:	89 34 24             	mov    %esi,(%esp)
80102c77:	e8 64 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c7c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102c82:	7c 8c                	jl     80102c10 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 a7 fd ff ff       	call   80102a30 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 02 fd ff ff       	call   80102990 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 93 fd ff ff       	call   80102a30 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c9d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ca4:	e8 a7 15 00 00       	call   80104250 <acquire>
    log.committing = 0;
80102ca9:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102cb0:	00 00 00 
    wakeup(&log);
80102cb3:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cba:	e8 d1 11 00 00       	call   80103e90 <wakeup>
    release(&log.lock);
80102cbf:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cc6:	e8 75 16 00 00       	call   80104340 <release>
  }
}
80102ccb:	83 c4 1c             	add    $0x1c,%esp
80102cce:	5b                   	pop    %ebx
80102ccf:	5e                   	pop    %esi
80102cd0:	5f                   	pop    %edi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cd3:	c7 04 24 24 7c 10 80 	movl   $0x80107c24,(%esp)
80102cda:	e8 81 d6 ff ff       	call   80100360 <panic>
80102cdf:	90                   	nop

80102ce0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ce7:	a1 c8 36 11 80       	mov    0x801136c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cef:	83 f8 1d             	cmp    $0x1d,%eax
80102cf2:	0f 8f 98 00 00 00    	jg     80102d90 <log_write+0xb0>
80102cf8:	8b 0d b8 36 11 80    	mov    0x801136b8,%ecx
80102cfe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d01:	39 d0                	cmp    %edx,%eax
80102d03:	0f 8d 87 00 00 00    	jge    80102d90 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d09:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d0e:	85 c0                	test   %eax,%eax
80102d10:	0f 8e 86 00 00 00    	jle    80102d9c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d16:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d1d:	e8 2e 15 00 00       	call   80104250 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d22:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d28:	83 fa 00             	cmp    $0x0,%edx
80102d2b:	7e 54                	jle    80102d81 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d2d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d30:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d32:	39 0d cc 36 11 80    	cmp    %ecx,0x801136cc
80102d38:	75 0f                	jne    80102d49 <log_write+0x69>
80102d3a:	eb 3c                	jmp    80102d78 <log_write+0x98>
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d40:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d47:	74 2f                	je     80102d78 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d49:	83 c0 01             	add    $0x1,%eax
80102d4c:	39 d0                	cmp    %edx,%eax
80102d4e:	75 f0                	jne    80102d40 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d50:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d57:	83 c2 01             	add    $0x1,%edx
80102d5a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102d60:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d63:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102d6a:	83 c4 14             	add    $0x14,%esp
80102d6d:	5b                   	pop    %ebx
80102d6e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d6f:	e9 cc 15 00 00       	jmp    80104340 <release>
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d78:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102d7f:	eb df                	jmp    80102d60 <log_write+0x80>
80102d81:	8b 43 08             	mov    0x8(%ebx),%eax
80102d84:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102d89:	75 d5                	jne    80102d60 <log_write+0x80>
80102d8b:	eb ca                	jmp    80102d57 <log_write+0x77>
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d90:	c7 04 24 33 7c 10 80 	movl   $0x80107c33,(%esp)
80102d97:	e8 c4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d9c:	c7 04 24 49 7c 10 80 	movl   $0x80107c49,(%esp)
80102da3:	e8 b8 d5 ff ff       	call   80100360 <panic>
80102da8:	66 90                	xchg   %ax,%ax
80102daa:	66 90                	xchg   %ax,%ax
80102dac:	66 90                	xchg   %ax,%ax
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102db7:	e8 f4 08 00 00       	call   801036b0 <cpuid>
80102dbc:	89 c3                	mov    %eax,%ebx
80102dbe:	e8 ed 08 00 00       	call   801036b0 <cpuid>
80102dc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102dc7:	c7 04 24 64 7c 10 80 	movl   $0x80107c64,(%esp)
80102dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dd2:	e8 79 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dd7:	e8 64 28 00 00       	call   80105640 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ddc:	e8 4f 08 00 00       	call   80103630 <mycpu>
80102de1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102de3:	b8 01 00 00 00       	mov    $0x1,%eax
80102de8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102def:	e8 3c 0c 00 00       	call   80103a30 <scheduler>
80102df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e00 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e06:	e8 95 3a 00 00       	call   801068a0 <switchkvm>
  seginit();
80102e0b:	e8 00 38 00 00       	call   80106610 <seginit>
  lapicinit();
80102e10:	e8 8b f8 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102e15:	e8 96 ff ff ff       	call   80102db0 <mpmain>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e24:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e29:	83 e4 f0             	and    $0xfffffff0,%esp
80102e2c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e2f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e36:	80 
80102e37:	c7 04 24 f4 70 11 80 	movl   $0x801170f4,(%esp)
80102e3e:	e8 cd f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102e43:	e8 38 40 00 00       	call   80106e80 <kvmalloc>
  mpinit();        // detect other processors
80102e48:	e8 73 01 00 00       	call   80102fc0 <mpinit>
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e50:	e8 4b f8 ff ff       	call   801026a0 <lapicinit>
  seginit();       // segment descriptors
80102e55:	e8 b6 37 00 00       	call   80106610 <seginit>
  picinit();       // disable pic
80102e5a:	e8 21 03 00 00       	call   80103180 <picinit>
80102e5f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e60:	e8 cb f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102e65:	e8 e6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e6a:	e8 71 2c 00 00       	call   80105ae0 <uartinit>
80102e6f:	90                   	nop
  pinit();         // process table
80102e70:	e8 9b 07 00 00       	call   80103610 <pinit>
  shminit();       // shared memory
80102e75:	e8 c6 43 00 00       	call   80107240 <shminit>
  tvinit();        // trap vectors
80102e7a:	e8 21 27 00 00       	call   801055a0 <tvinit>
80102e7f:	90                   	nop
  binit();         // buffer cache
80102e80:	e8 bb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e85:	e8 e6 de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102e8a:	e8 a1 f1 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e8f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e96:	00 
80102e97:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102e9e:	80 
80102e9f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ea6:	e8 85 15 00 00       	call   80104430 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eab:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102eb2:	00 00 00 
80102eb5:	05 80 37 11 80       	add    $0x80113780,%eax
80102eba:	39 d8                	cmp    %ebx,%eax
80102ebc:	76 65                	jbe    80102f23 <main+0x103>
80102ebe:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102ec0:	e8 6b 07 00 00       	call   80103630 <mycpu>
80102ec5:	39 d8                	cmp    %ebx,%eax
80102ec7:	74 41                	je     80102f0a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ec9:	e8 02 f6 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102ece:	c7 05 f8 6f 00 80 00 	movl   $0x80102e00,0x80006ff8
80102ed5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ed8:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102edf:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ee2:	05 00 10 00 00       	add    $0x1000,%eax
80102ee7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102eec:	0f b6 03             	movzbl (%ebx),%eax
80102eef:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ef6:	00 
80102ef7:	89 04 24             	mov    %eax,(%esp)
80102efa:	e8 e1 f8 ff ff       	call   801027e0 <lapicstartap>
80102eff:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 f6                	je     80102f00 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f0a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f11:	00 00 00 
80102f14:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f1a:	05 80 37 11 80       	add    $0x80113780,%eax
80102f1f:	39 c3                	cmp    %eax,%ebx
80102f21:	72 9d                	jb     80102ec0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f23:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f2a:	8e 
80102f2b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f32:	e8 49 f5 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102f37:	e8 c4 07 00 00       	call   80103700 <userinit>
  mpmain();        // finish this processor's setup
80102f3c:	e8 6f fe ff ff       	call   80102db0 <mpmain>
80102f41:	66 90                	xchg   %ax,%ax
80102f43:	66 90                	xchg   %ax,%ax
80102f45:	66 90                	xchg   %ax,%ax
80102f47:	66 90                	xchg   %ax,%ax
80102f49:	66 90                	xchg   %ax,%ax
80102f4b:	66 90                	xchg   %ax,%ax
80102f4d:	66 90                	xchg   %ax,%ax
80102f4f:	90                   	nop

80102f50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f54:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f5a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f5b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f5e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f61:	39 de                	cmp    %ebx,%esi
80102f63:	73 3c                	jae    80102fa1 <mpsearch1+0x51>
80102f65:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f68:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f6f:	00 
80102f70:	c7 44 24 04 78 7c 10 	movl   $0x80107c78,0x4(%esp)
80102f77:	80 
80102f78:	89 34 24             	mov    %esi,(%esp)
80102f7b:	e8 60 14 00 00       	call   801043e0 <memcmp>
80102f80:	85 c0                	test   %eax,%eax
80102f82:	75 16                	jne    80102f9a <mpsearch1+0x4a>
80102f84:	31 c9                	xor    %ecx,%ecx
80102f86:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f88:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f8c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f8f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f91:	83 fa 10             	cmp    $0x10,%edx
80102f94:	75 f2                	jne    80102f88 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f96:	84 c9                	test   %cl,%cl
80102f98:	74 10                	je     80102faa <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f9a:	83 c6 10             	add    $0x10,%esi
80102f9d:	39 f3                	cmp    %esi,%ebx
80102f9f:	77 c7                	ja     80102f68 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fa1:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fa4:	31 c0                	xor    %eax,%eax
}
80102fa6:	5b                   	pop    %ebx
80102fa7:	5e                   	pop    %esi
80102fa8:	5d                   	pop    %ebp
80102fa9:	c3                   	ret    
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	89 f0                	mov    %esi,%eax
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5d                   	pop    %ebp
80102fb2:	c3                   	ret    
80102fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fc9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fd0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fd7:	c1 e0 08             	shl    $0x8,%eax
80102fda:	09 d0                	or     %edx,%eax
80102fdc:	c1 e0 04             	shl    $0x4,%eax
80102fdf:	85 c0                	test   %eax,%eax
80102fe1:	75 1b                	jne    80102ffe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fe3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ff1:	c1 e0 08             	shl    $0x8,%eax
80102ff4:	09 d0                	or     %edx,%eax
80102ff6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ff9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102ffe:	ba 00 04 00 00       	mov    $0x400,%edx
80103003:	e8 48 ff ff ff       	call   80102f50 <mpsearch1>
80103008:	85 c0                	test   %eax,%eax
8010300a:	89 c7                	mov    %eax,%edi
8010300c:	0f 84 22 01 00 00    	je     80103134 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103012:	8b 77 04             	mov    0x4(%edi),%esi
80103015:	85 f6                	test   %esi,%esi
80103017:	0f 84 30 01 00 00    	je     8010314d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010301d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103023:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010302a:	00 
8010302b:	c7 44 24 04 7d 7c 10 	movl   $0x80107c7d,0x4(%esp)
80103032:	80 
80103033:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103039:	e8 a2 13 00 00       	call   801043e0 <memcmp>
8010303e:	85 c0                	test   %eax,%eax
80103040:	0f 85 07 01 00 00    	jne    8010314d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103046:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010304d:	3c 04                	cmp    $0x4,%al
8010304f:	0f 85 0b 01 00 00    	jne    80103160 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103055:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010305c:	85 c0                	test   %eax,%eax
8010305e:	74 21                	je     80103081 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103060:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103062:	31 d2                	xor    %edx,%edx
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103068:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010306f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103070:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103073:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103075:	39 d0                	cmp    %edx,%eax
80103077:	7f ef                	jg     80103068 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103079:	84 c9                	test   %cl,%cl
8010307b:	0f 85 cc 00 00 00    	jne    8010314d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103084:	85 c0                	test   %eax,%eax
80103086:	0f 84 c1 00 00 00    	je     8010314d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010308c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103092:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103097:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030a3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030a9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030b0:	39 c2                	cmp    %eax,%edx
801030b2:	76 1b                	jbe    801030cf <mpinit+0x10f>
801030b4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030b7:	80 f9 04             	cmp    $0x4,%cl
801030ba:	77 74                	ja     80103130 <mpinit+0x170>
801030bc:	ff 24 8d bc 7c 10 80 	jmp    *-0x7fef8344(,%ecx,4)
801030c3:	90                   	nop
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030c8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030cb:	39 c2                	cmp    %eax,%edx
801030cd:	77 e5                	ja     801030b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030cf:	85 db                	test   %ebx,%ebx
801030d1:	0f 84 93 00 00 00    	je     8010316a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030d7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030db:	74 12                	je     801030ef <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dd:	ba 22 00 00 00       	mov    $0x22,%edx
801030e2:	b8 70 00 00 00       	mov    $0x70,%eax
801030e7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e8:	b2 23                	mov    $0x23,%dl
801030ea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030eb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ee:	ee                   	out    %al,(%dx)
  }
}
801030ef:	83 c4 1c             	add    $0x1c,%esp
801030f2:	5b                   	pop    %ebx
801030f3:	5e                   	pop    %esi
801030f4:	5f                   	pop    %edi
801030f5:	5d                   	pop    %ebp
801030f6:	c3                   	ret    
801030f7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030f8:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
801030fe:	83 fe 07             	cmp    $0x7,%esi
80103101:	7f 17                	jg     8010311a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103103:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103107:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010310d:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103114:	88 8e 80 37 11 80    	mov    %cl,-0x7feec880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010311a:	83 c0 14             	add    $0x14,%eax
      continue;
8010311d:	eb 91                	jmp    801030b0 <mpinit+0xf0>
8010311f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103120:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103124:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103127:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
8010312d:	eb 81                	jmp    801030b0 <mpinit+0xf0>
8010312f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103130:	31 db                	xor    %ebx,%ebx
80103132:	eb 83                	jmp    801030b7 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103134:	ba 00 00 01 00       	mov    $0x10000,%edx
80103139:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010313e:	e8 0d fe ff ff       	call   80102f50 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103143:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103145:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103147:	0f 85 c5 fe ff ff    	jne    80103012 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010314d:	c7 04 24 82 7c 10 80 	movl   $0x80107c82,(%esp)
80103154:	e8 07 d2 ff ff       	call   80100360 <panic>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103160:	3c 01                	cmp    $0x1,%al
80103162:	0f 84 ed fe ff ff    	je     80103055 <mpinit+0x95>
80103168:	eb e3                	jmp    8010314d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010316a:	c7 04 24 9c 7c 10 80 	movl   $0x80107c9c,(%esp)
80103171:	e8 ea d1 ff ff       	call   80100360 <panic>
80103176:	66 90                	xchg   %ax,%ax
80103178:	66 90                	xchg   %ax,%ax
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103180:	55                   	push   %ebp
80103181:	ba 21 00 00 00       	mov    $0x21,%edx
80103186:	89 e5                	mov    %esp,%ebp
80103188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010318d:	ee                   	out    %al,(%dx)
8010318e:	b2 a1                	mov    $0xa1,%dl
80103190:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103191:	5d                   	pop    %ebp
80103192:	c3                   	ret    
80103193:	66 90                	xchg   %ax,%ax
80103195:	66 90                	xchg   %ax,%ax
80103197:	66 90                	xchg   %ax,%ax
80103199:	66 90                	xchg   %ax,%ax
8010319b:	66 90                	xchg   %ax,%ax
8010319d:	66 90                	xchg   %ax,%ax
8010319f:	90                   	nop

801031a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	83 ec 1c             	sub    $0x1c,%esp
801031a9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031bb:	e8 d0 db ff ff       	call   80100d90 <filealloc>
801031c0:	85 c0                	test   %eax,%eax
801031c2:	89 06                	mov    %eax,(%esi)
801031c4:	0f 84 a4 00 00 00    	je     8010326e <pipealloc+0xce>
801031ca:	e8 c1 db ff ff       	call   80100d90 <filealloc>
801031cf:	85 c0                	test   %eax,%eax
801031d1:	89 03                	mov    %eax,(%ebx)
801031d3:	0f 84 87 00 00 00    	je     80103260 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031d9:	e8 f2 f2 ff ff       	call   801024d0 <kalloc>
801031de:	85 c0                	test   %eax,%eax
801031e0:	89 c7                	mov    %eax,%edi
801031e2:	74 7c                	je     80103260 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031e4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031eb:	00 00 00 
  p->writeopen = 1;
801031ee:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031f5:	00 00 00 
  p->nwrite = 0;
801031f8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ff:	00 00 00 
  p->nread = 0;
80103202:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103209:	00 00 00 
  initlock(&p->lock, "pipe");
8010320c:	89 04 24             	mov    %eax,(%esp)
8010320f:	c7 44 24 04 d0 7c 10 	movl   $0x80107cd0,0x4(%esp)
80103216:	80 
80103217:	e8 44 0f 00 00       	call   80104160 <initlock>
  (*f0)->type = FD_PIPE;
8010321c:	8b 06                	mov    (%esi),%eax
8010321e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103224:	8b 06                	mov    (%esi),%eax
80103226:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010322a:	8b 06                	mov    (%esi),%eax
8010322c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103230:	8b 06                	mov    (%esi),%eax
80103232:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103235:	8b 03                	mov    (%ebx),%eax
80103237:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010323d:	8b 03                	mov    (%ebx),%eax
8010323f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103243:	8b 03                	mov    (%ebx),%eax
80103245:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103249:	8b 03                	mov    (%ebx),%eax
  return 0;
8010324b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010324d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103250:	83 c4 1c             	add    $0x1c,%esp
80103253:	89 d8                	mov    %ebx,%eax
80103255:	5b                   	pop    %ebx
80103256:	5e                   	pop    %esi
80103257:	5f                   	pop    %edi
80103258:	5d                   	pop    %ebp
80103259:	c3                   	ret    
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103260:	8b 06                	mov    (%esi),%eax
80103262:	85 c0                	test   %eax,%eax
80103264:	74 08                	je     8010326e <pipealloc+0xce>
    fileclose(*f0);
80103266:	89 04 24             	mov    %eax,(%esp)
80103269:	e8 e2 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
8010326e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103270:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103275:	85 c0                	test   %eax,%eax
80103277:	74 d7                	je     80103250 <pipealloc+0xb0>
    fileclose(*f1);
80103279:	89 04 24             	mov    %eax,(%esp)
8010327c:	e8 cf db ff ff       	call   80100e50 <fileclose>
  return -1;
}
80103281:	83 c4 1c             	add    $0x1c,%esp
80103284:	89 d8                	mov    %ebx,%eax
80103286:	5b                   	pop    %ebx
80103287:	5e                   	pop    %esi
80103288:	5f                   	pop    %edi
80103289:	5d                   	pop    %ebp
8010328a:	c3                   	ret    
8010328b:	90                   	nop
8010328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103290 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	56                   	push   %esi
80103294:	53                   	push   %ebx
80103295:	83 ec 10             	sub    $0x10,%esp
80103298:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010329b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010329e:	89 1c 24             	mov    %ebx,(%esp)
801032a1:	e8 aa 0f 00 00       	call   80104250 <acquire>
  if(writable){
801032a6:	85 f6                	test   %esi,%esi
801032a8:	74 3e                	je     801032e8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032aa:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032b0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032b7:	00 00 00 
    wakeup(&p->nread);
801032ba:	89 04 24             	mov    %eax,(%esp)
801032bd:	e8 ce 0b 00 00       	call   80103e90 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032c2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032c8:	85 d2                	test   %edx,%edx
801032ca:	75 0a                	jne    801032d6 <pipeclose+0x46>
801032cc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 32                	je     80103308 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032df:	e9 5c 10 00 00       	jmp    80104340 <release>
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032e8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032ee:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032f5:	00 00 00 
    wakeup(&p->nwrite);
801032f8:	89 04 24             	mov    %eax,(%esp)
801032fb:	e8 90 0b 00 00       	call   80103e90 <wakeup>
80103300:	eb c0                	jmp    801032c2 <pipeclose+0x32>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103308:	89 1c 24             	mov    %ebx,(%esp)
8010330b:	e8 30 10 00 00       	call   80104340 <release>
    kfree((char*)p);
80103310:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103313:	83 c4 10             	add    $0x10,%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103319:	e9 02 f0 ff ff       	jmp    80102320 <kfree>
8010331e:	66 90                	xchg   %ax,%ax

80103320 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
80103329:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010332c:	89 1c 24             	mov    %ebx,(%esp)
8010332f:	e8 1c 0f 00 00       	call   80104250 <acquire>
  for(i = 0; i < n; i++){
80103334:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103337:	85 c9                	test   %ecx,%ecx
80103339:	0f 8e b2 00 00 00    	jle    801033f1 <pipewrite+0xd1>
8010333f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103342:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103348:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010334e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103354:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103357:	03 4d 10             	add    0x10(%ebp),%ecx
8010335a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010335d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103363:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103369:	39 c8                	cmp    %ecx,%eax
8010336b:	74 38                	je     801033a5 <pipewrite+0x85>
8010336d:	eb 55                	jmp    801033c4 <pipewrite+0xa4>
8010336f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103370:	e8 5b 03 00 00       	call   801036d0 <myproc>
80103375:	8b 40 24             	mov    0x24(%eax),%eax
80103378:	85 c0                	test   %eax,%eax
8010337a:	75 33                	jne    801033af <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010337c:	89 3c 24             	mov    %edi,(%esp)
8010337f:	e8 0c 0b 00 00       	call   80103e90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103384:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103388:	89 34 24             	mov    %esi,(%esp)
8010338b:	e8 60 09 00 00       	call   80103cf0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103390:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103396:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010339c:	05 00 02 00 00       	add    $0x200,%eax
801033a1:	39 c2                	cmp    %eax,%edx
801033a3:	75 23                	jne    801033c8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033a5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ab:	85 d2                	test   %edx,%edx
801033ad:	75 c1                	jne    80103370 <pipewrite+0x50>
        release(&p->lock);
801033af:	89 1c 24             	mov    %ebx,(%esp)
801033b2:	e8 89 0f 00 00       	call   80104340 <release>
        return -1;
801033b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033bc:	83 c4 1c             	add    $0x1c,%esp
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033cb:	8d 42 01             	lea    0x1(%edx),%eax
801033ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033d4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033da:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033de:	0f b6 09             	movzbl (%ecx),%ecx
801033e1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033e8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033eb:	0f 85 6c ff ff ff    	jne    8010335d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033f1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033f7:	89 04 24             	mov    %eax,(%esp)
801033fa:	e8 91 0a 00 00       	call   80103e90 <wakeup>
  release(&p->lock);
801033ff:	89 1c 24             	mov    %ebx,(%esp)
80103402:	e8 39 0f 00 00       	call   80104340 <release>
  return n;
80103407:	8b 45 10             	mov    0x10(%ebp),%eax
8010340a:	eb b0                	jmp    801033bc <pipewrite+0x9c>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103410 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010341f:	89 34 24             	mov    %esi,(%esp)
80103422:	e8 29 0e 00 00       	call   80104250 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103427:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103433:	75 5b                	jne    80103490 <piperead+0x80>
80103435:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010343b:	85 db                	test   %ebx,%ebx
8010343d:	74 51                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010343f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103445:	eb 25                	jmp    8010346c <piperead+0x5c>
80103447:	90                   	nop
80103448:	89 74 24 04          	mov    %esi,0x4(%esp)
8010344c:	89 1c 24             	mov    %ebx,(%esp)
8010344f:	e8 9c 08 00 00       	call   80103cf0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103454:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010345a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103460:	75 2e                	jne    80103490 <piperead+0x80>
80103462:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103468:	85 d2                	test   %edx,%edx
8010346a:	74 24                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
8010346c:	e8 5f 02 00 00       	call   801036d0 <myproc>
80103471:	8b 48 24             	mov    0x24(%eax),%ecx
80103474:	85 c9                	test   %ecx,%ecx
80103476:	74 d0                	je     80103448 <piperead+0x38>
      release(&p->lock);
80103478:	89 34 24             	mov    %esi,(%esp)
8010347b:	e8 c0 0e 00 00       	call   80104340 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103480:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103488:	5b                   	pop    %ebx
80103489:	5e                   	pop    %esi
8010348a:	5f                   	pop    %edi
8010348b:	5d                   	pop    %ebp
8010348c:	c3                   	ret    
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103490:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103493:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103495:	85 d2                	test   %edx,%edx
80103497:	7f 2b                	jg     801034c4 <piperead+0xb4>
80103499:	eb 31                	jmp    801034cc <piperead+0xbc>
8010349b:	90                   	nop
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034a0:	8d 48 01             	lea    0x1(%eax),%ecx
801034a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b6:	83 c3 01             	add    $0x1,%ebx
801034b9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034bc:	74 0e                	je     801034cc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ca:	75 d4                	jne    801034a0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034cc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034d2:	89 04 24             	mov    %eax,(%esp)
801034d5:	e8 b6 09 00 00       	call   80103e90 <wakeup>
  release(&p->lock);
801034da:	89 34 24             	mov    %esi,(%esp)
801034dd:	e8 5e 0e 00 00       	call   80104340 <release>
  return i;
}
801034e2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034e5:	89 d8                	mov    %ebx,%eax
}
801034e7:	5b                   	pop    %ebx
801034e8:	5e                   	pop    %esi
801034e9:	5f                   	pop    %edi
801034ea:	5d                   	pop    %ebp
801034eb:	c3                   	ret    
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034f9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034fc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103503:	e8 48 0d 00 00       	call   80104250 <acquire>
80103508:	eb 14                	jmp    8010351e <allocproc+0x2e>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103510:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103516:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010351c:	74 7a                	je     80103598 <allocproc+0xa8>
    if(p->state == UNUSED)
8010351e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103521:	85 c0                	test   %eax,%eax
80103523:	75 eb                	jne    80103510 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103525:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010352a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103531:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103538:	8d 50 01             	lea    0x1(%eax),%edx
8010353b:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103541:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103544:	e8 f7 0d 00 00       	call   80104340 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103549:	e8 82 ef ff ff       	call   801024d0 <kalloc>
8010354e:	85 c0                	test   %eax,%eax
80103550:	89 43 08             	mov    %eax,0x8(%ebx)
80103553:	74 57                	je     801035ac <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103555:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010355b:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103560:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103563:	c7 40 14 95 55 10 80 	movl   $0x80105595,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010356a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103571:	00 
80103572:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103579:	00 
8010357a:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010357d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103580:	e8 0b 0e 00 00       	call   80104390 <memset>
  p->context->eip = (uint)forkret;
80103585:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103588:	c7 40 10 c0 35 10 80 	movl   $0x801035c0,0x10(%eax)

  return p;
8010358f:	89 d8                	mov    %ebx,%eax
}
80103591:	83 c4 14             	add    $0x14,%esp
80103594:	5b                   	pop    %ebx
80103595:	5d                   	pop    %ebp
80103596:	c3                   	ret    
80103597:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103598:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010359f:	e8 9c 0d 00 00       	call   80104340 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035a4:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801035a7:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035a9:	5b                   	pop    %ebx
801035aa:	5d                   	pop    %ebp
801035ab:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801035ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035b3:	eb dc                	jmp    80103591 <allocproc+0xa1>
801035b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035c6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801035cd:	e8 6e 0d 00 00       	call   80104340 <release>

  if (first) {
801035d2:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	75 05                	jne    801035e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035db:	c9                   	leave  
801035dc:	c3                   	ret    
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035e7:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801035ee:	00 00 00 
    iinit(ROOTDEV);
801035f1:	e8 aa de ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
801035f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035fd:	e8 9e f4 ff ff       	call   80102aa0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103602:	c9                   	leave  
80103603:	c3                   	ret    
80103604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010360a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103610 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103616:	c7 44 24 04 d5 7c 10 	movl   $0x80107cd5,0x4(%esp)
8010361d:	80 
8010361e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103625:	e8 36 0b 00 00       	call   80104160 <initlock>
}
8010362a:	c9                   	leave  
8010362b:	c3                   	ret    
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103630 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103638:	9c                   	pushf  
80103639:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010363a:	f6 c4 02             	test   $0x2,%ah
8010363d:	75 57                	jne    80103696 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010363f:	e8 4c f1 ff ff       	call   80102790 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103644:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
8010364a:	85 f6                	test   %esi,%esi
8010364c:	7e 3c                	jle    8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010364e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103655:	39 c2                	cmp    %eax,%edx
80103657:	74 2d                	je     80103686 <mycpu+0x56>
80103659:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010365e:	31 d2                	xor    %edx,%edx
80103660:	83 c2 01             	add    $0x1,%edx
80103663:	39 f2                	cmp    %esi,%edx
80103665:	74 23                	je     8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103667:	0f b6 19             	movzbl (%ecx),%ebx
8010366a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103670:	39 c3                	cmp    %eax,%ebx
80103672:	75 ec                	jne    80103660 <mycpu+0x30>
      return &cpus[i];
80103674:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	5b                   	pop    %ebx
8010367e:	5e                   	pop    %esi
8010367f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103680:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103685:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103686:	31 d2                	xor    %edx,%edx
80103688:	eb ea                	jmp    80103674 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010368a:	c7 04 24 dc 7c 10 80 	movl   $0x80107cdc,(%esp)
80103691:	e8 ca cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103696:	c7 04 24 b8 7d 10 80 	movl   $0x80107db8,(%esp)
8010369d:	e8 be cc ff ff       	call   80100360 <panic>
801036a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036b0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036b6:	e8 75 ff ff ff       	call   80103630 <mycpu>
}
801036bb:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036bc:	2d 80 37 11 80       	sub    $0x80113780,%eax
801036c1:	c1 f8 04             	sar    $0x4,%eax
801036c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ca:	c3                   	ret    
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036d0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036d7:	e8 34 0b 00 00       	call   80104210 <pushcli>
  c = mycpu();
801036dc:	e8 4f ff ff ff       	call   80103630 <mycpu>
  p = c->proc;
801036e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036e7:	e8 e4 0b 00 00       	call   801042d0 <popcli>
  return p;
}
801036ec:	83 c4 04             	add    $0x4,%esp
801036ef:	89 d8                	mov    %ebx,%eax
801036f1:	5b                   	pop    %ebx
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
80103704:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
	int page_id;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103707:	e8 e4 fd ff ff       	call   801034f0 <allocproc>
8010370c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010370e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103713:	e8 d8 36 00 00       	call   80106df0 <setupkvm>
80103718:	85 c0                	test   %eax,%eax
8010371a:	89 43 04             	mov    %eax,0x4(%ebx)
8010371d:	0f 84 2b 01 00 00    	je     8010384e <userinit+0x14e>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103723:	89 04 24             	mov    %eax,(%esp)
80103726:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010372d:	00 
8010372e:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
80103735:	80 
80103736:	e8 95 32 00 00       	call   801069d0 <inituvm>
  p->sz = PGSIZE;
8010373b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->tstack = 0; // For CS153 lab2 part 1
80103741:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103748:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010374f:	00 
80103750:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103757:	00 
80103758:	8b 43 18             	mov    0x18(%ebx),%eax
8010375b:	89 04 24             	mov    %eax,(%esp)
8010375e:	e8 2d 0c 00 00       	call   80104390 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103763:	8b 43 18             	mov    0x18(%ebx),%eax
80103766:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010376b:	b9 23 00 00 00       	mov    $0x23,%ecx
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->tstack = 0; // For CS153 lab2 part 1
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103770:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010377b:	8b 43 18             	mov    0x18(%ebx),%eax
8010377e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103782:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103786:	8b 43 18             	mov    0x18(%ebx),%eax
80103789:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010378d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103791:	8b 43 18             	mov    0x18(%ebx),%eax
80103794:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010379b:	8b 43 18             	mov    0x18(%ebx),%eax
8010379e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037a5:	8b 43 18             	mov    0x18(%ebx),%eax
801037a8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037af:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037b2:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801037b9:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037bc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037c3:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037c6:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
801037cd:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037d0:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801037d7:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037da:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
801037e1:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037e4:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801037eb:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037ee:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
801037f5:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037f8:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801037ff:	00 00 00 
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103802:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103809:	00 
8010380a:	c7 44 24 04 05 7d 10 	movl   $0x80107d05,0x4(%esp)
80103811:	80 
80103812:	89 04 24             	mov    %eax,(%esp)
80103815:	e8 56 0d 00 00       	call   80104570 <safestrcpy>
  p->cwd = namei("/");
8010381a:	c7 04 24 0e 7d 10 80 	movl   $0x80107d0e,(%esp)
80103821:	e8 0a e7 ff ff       	call   80101f30 <namei>
80103826:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103829:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103830:	e8 1b 0a 00 00       	call   80104250 <acquire>

  p->state = RUNNABLE;
80103835:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010383c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103843:	e8 f8 0a 00 00       	call   80104340 <release>
}
80103848:	83 c4 14             	add    $0x14,%esp
8010384b:	5b                   	pop    %ebx
8010384c:	5d                   	pop    %ebp
8010384d:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
8010384e:	c7 04 24 ec 7c 10 80 	movl   $0x80107cec,(%esp)
80103855:	e8 06 cb ff ff       	call   80100360 <panic>
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103860 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
80103865:	53                   	push   %ebx
80103866:	83 ec 1c             	sub    $0x1c,%esp
80103869:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint sz;
  struct proc *curproc = myproc();
8010386c:	e8 5f fe ff ff       	call   801036d0 <myproc>
80103871:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103873:	8b 30                	mov    (%eax),%esi
  if(curproc->tstack != 0)
80103875:	8b 40 7c             	mov    0x7c(%eax),%eax
80103878:	85 c0                	test   %eax,%eax
8010387a:	74 10                	je     8010388c <growproc+0x2c>
   {
	  if(sz +n >= curproc->tstack-PGSIZE)
8010387c:	8d 14 37             	lea    (%edi,%esi,1),%edx
8010387f:	2d 00 10 00 00       	sub    $0x1000,%eax
80103884:	39 c2                	cmp    %eax,%edx
80103886:	0f 83 84 00 00 00    	jae    80103910 <growproc+0xb0>
		  return -1;
   }
	resetpteu(curproc->pgdir,(char *)sz);
8010388c:	89 74 24 04          	mov    %esi,0x4(%esp)
80103890:	8b 43 04             	mov    0x4(%ebx),%eax
80103893:	89 04 24             	mov    %eax,(%esp)
80103896:	e8 45 36 00 00       	call   80106ee0 <resetpteu>
  if(n > 0){
8010389b:	83 ff 00             	cmp    $0x0,%edi
8010389e:	7e 50                	jle    801038f0 <growproc+0x90>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038a0:	01 f7                	add    %esi,%edi
801038a2:	89 74 24 04          	mov    %esi,0x4(%esp)
801038a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801038aa:	8b 43 04             	mov    0x4(%ebx),%eax
801038ad:	89 04 24             	mov    %eax,(%esp)
801038b0:	e8 7b 32 00 00       	call   80106b30 <allocuvm>
801038b5:	85 c0                	test   %eax,%eax
801038b7:	89 c6                	mov    %eax,%esi
801038b9:	74 55                	je     80103910 <growproc+0xb0>
      return -1;
		if(sz+PGSIZE<=curproc->tstack) return -1;
801038bb:	8d 80 00 10 00 00    	lea    0x1000(%eax),%eax
801038c1:	3b 43 7c             	cmp    0x7c(%ebx),%eax
801038c4:	76 4a                	jbe    80103910 <growproc+0xb0>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
	clearpteu(curproc->pgdir,(char *)sz);
801038c6:	89 74 24 04          	mov    %esi,0x4(%esp)
801038ca:	8b 43 04             	mov    0x4(%ebx),%eax
801038cd:	89 04 24             	mov    %eax,(%esp)
801038d0:	e8 cb 35 00 00       	call   80106ea0 <clearpteu>
  curproc->sz = sz;
801038d5:	89 33                	mov    %esi,(%ebx)
  switchuvm(curproc);
801038d7:	89 1c 24             	mov    %ebx,(%esp)
801038da:	e8 e1 2f 00 00       	call   801068c0 <switchuvm>
  return 0;
801038df:	31 c0                	xor    %eax,%eax
}
801038e1:	83 c4 1c             	add    $0x1c,%esp
801038e4:	5b                   	pop    %ebx
801038e5:	5e                   	pop    %esi
801038e6:	5f                   	pop    %edi
801038e7:	5d                   	pop    %ebp
801038e8:	c3                   	ret    
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	resetpteu(curproc->pgdir,(char *)sz);
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
		if(sz+PGSIZE<=curproc->tstack) return -1;
  } else if(n < 0){
801038f0:	74 d4                	je     801038c6 <growproc+0x66>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038f2:	01 f7                	add    %esi,%edi
801038f4:	89 74 24 04          	mov    %esi,0x4(%esp)
801038f8:	89 7c 24 08          	mov    %edi,0x8(%esp)
801038fc:	8b 43 04             	mov    0x4(%ebx),%eax
801038ff:	89 04 24             	mov    %eax,(%esp)
80103902:	e8 49 34 00 00       	call   80106d50 <deallocuvm>
80103907:	85 c0                	test   %eax,%eax
80103909:	89 c6                	mov    %eax,%esi
8010390b:	75 b9                	jne    801038c6 <growproc+0x66>
8010390d:	8d 76 00             	lea    0x0(%esi),%esi
  struct proc *curproc = myproc();
  sz = curproc->sz;
  if(curproc->tstack != 0)
   {
	  if(sz +n >= curproc->tstack-PGSIZE)
		  return -1;
80103910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103915:	eb ca                	jmp    801038e1 <growproc+0x81>
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103920 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	57                   	push   %edi
80103924:	56                   	push   %esi
80103925:	53                   	push   %ebx
80103926:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103929:	e8 a2 fd ff ff       	call   801036d0 <myproc>
8010392e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103930:	e8 bb fb ff ff       	call   801034f0 <allocproc>
80103935:	85 c0                	test   %eax,%eax
80103937:	89 c7                	mov    %eax,%edi
80103939:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010393c:	0f 84 c4 00 00 00    	je     80103a06 <fork+0xe6>
    return -1;
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
80103942:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103945:	89 44 24 08          	mov    %eax,0x8(%esp)
80103949:	8b 03                	mov    (%ebx),%eax
8010394b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010394f:	8b 43 04             	mov    0x4(%ebx),%eax
80103952:	89 04 24             	mov    %eax,(%esp)
80103955:	e8 c6 35 00 00       	call   80106f20 <copyuvm>
8010395a:	85 c0                	test   %eax,%eax
8010395c:	89 47 04             	mov    %eax,0x4(%edi)
8010395f:	0f 84 a8 00 00 00    	je     80103a0d <fork+0xed>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
80103965:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103968:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010396b:	89 41 7c             	mov    %eax,0x7c(%ecx)
  np->sz = curproc->sz;
8010396e:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103970:	8b 79 18             	mov    0x18(%ecx),%edi
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
80103973:	89 59 14             	mov    %ebx,0x14(%ecx)
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
80103976:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103978:	8b 73 18             	mov    0x18(%ebx),%esi
8010397b:	89 c8                	mov    %ecx,%eax
8010397d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103982:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103984:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103986:	8b 40 18             	mov    0x18(%eax),%eax
80103989:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103990:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103994:	85 c0                	test   %eax,%eax
80103996:	74 0f                	je     801039a7 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103998:	89 04 24             	mov    %eax,(%esp)
8010399b:	e8 60 d4 ff ff       	call   80100e00 <filedup>
801039a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039a3:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039a7:	83 c6 01             	add    $0x1,%esi
801039aa:	83 fe 10             	cmp    $0x10,%esi
801039ad:	75 e1                	jne    80103990 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039af:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039b2:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039b5:	89 04 24             	mov    %eax,(%esp)
801039b8:	e8 f3 dc ff ff       	call   801016b0 <idup>
801039bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039c0:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039c3:	8d 47 6c             	lea    0x6c(%edi),%eax
801039c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801039ca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039d1:	00 
801039d2:	89 04 24             	mov    %eax,(%esp)
801039d5:	e8 96 0b 00 00       	call   80104570 <safestrcpy>

  pid = np->pid;
801039da:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039dd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801039e4:	e8 67 08 00 00       	call   80104250 <acquire>

  np->state = RUNNABLE;
801039e9:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039f0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801039f7:	e8 44 09 00 00       	call   80104340 <release>

  return pid;
801039fc:	89 d8                	mov    %ebx,%eax
}
801039fe:	83 c4 1c             	add    $0x1c,%esp
80103a01:	5b                   	pop    %ebx
80103a02:	5e                   	pop    %esi
80103a03:	5f                   	pop    %edi
80103a04:	5d                   	pop    %ebp
80103a05:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a0b:	eb f1                	jmp    801039fe <fork+0xde>
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
    kfree(np->kstack);
80103a0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a10:	8b 47 08             	mov    0x8(%edi),%eax
80103a13:	89 04 24             	mov    %eax,(%esp)
80103a16:	e8 05 e9 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a20:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a27:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a2e:	eb ce                	jmp    801039fe <fork+0xde>

80103a30 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a39:	e8 f2 fb ff ff       	call   80103630 <mycpu>
80103a3e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a40:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a47:	00 00 00 
80103a4a:	8d 78 04             	lea    0x4(%eax),%edi
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a50:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a51:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a58:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a5d:	e8 ee 07 00 00       	call   80104250 <acquire>
80103a62:	eb 12                	jmp    80103a76 <scheduler+0x46>
80103a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a68:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103a6e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103a74:	74 52                	je     80103ac8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103a76:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a7a:	75 ec                	jne    80103a68 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a7c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a82:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a85:	81 c3 a0 00 00 00    	add    $0xa0,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a8b:	e8 30 2e 00 00       	call   801068c0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a90:	8b 83 7c ff ff ff    	mov    -0x84(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a96:	c7 83 6c ff ff ff 04 	movl   $0x4,-0x94(%ebx)
80103a9d:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103aa0:	89 3c 24             	mov    %edi,(%esp)
80103aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aa7:	e8 1f 0b 00 00       	call   801045cb <swtch>
      switchkvm();
80103aac:	e8 ef 2d 00 00       	call   801068a0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab1:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ab7:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103abe:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac1:	75 b3                	jne    80103a76 <scheduler+0x46>
80103ac3:	90                   	nop
80103ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ac8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103acf:	e8 6c 08 00 00       	call   80104340 <release>

  }
80103ad4:	e9 77 ff ff ff       	jmp    80103a50 <scheduler+0x20>
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103ae8:	e8 e3 fb ff ff       	call   801036d0 <myproc>

  if(!holding(&ptable.lock))
80103aed:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103af4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103af6:	e8 e5 06 00 00       	call   801041e0 <holding>
80103afb:	85 c0                	test   %eax,%eax
80103afd:	74 4f                	je     80103b4e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103aff:	e8 2c fb ff ff       	call   80103630 <mycpu>
80103b04:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b0b:	75 65                	jne    80103b72 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103b0d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b11:	74 53                	je     80103b66 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b13:	9c                   	pushf  
80103b14:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b15:	f6 c4 02             	test   $0x2,%ah
80103b18:	75 40                	jne    80103b5a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b1a:	e8 11 fb ff ff       	call   80103630 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b1f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b22:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b28:	e8 03 fb ff ff       	call   80103630 <mycpu>
80103b2d:	8b 40 04             	mov    0x4(%eax),%eax
80103b30:	89 1c 24             	mov    %ebx,(%esp)
80103b33:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b37:	e8 8f 0a 00 00       	call   801045cb <swtch>
  mycpu()->intena = intena;
80103b3c:	e8 ef fa ff ff       	call   80103630 <mycpu>
80103b41:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b47:	83 c4 10             	add    $0x10,%esp
80103b4a:	5b                   	pop    %ebx
80103b4b:	5e                   	pop    %esi
80103b4c:	5d                   	pop    %ebp
80103b4d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b4e:	c7 04 24 10 7d 10 80 	movl   $0x80107d10,(%esp)
80103b55:	e8 06 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b5a:	c7 04 24 3c 7d 10 80 	movl   $0x80107d3c,(%esp)
80103b61:	e8 fa c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b66:	c7 04 24 2e 7d 10 80 	movl   $0x80107d2e,(%esp)
80103b6d:	e8 ee c7 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b72:	c7 04 24 22 7d 10 80 	movl   $0x80107d22,(%esp)
80103b79:	e8 e2 c7 ff ff       	call   80100360 <panic>
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  if(curproc == initproc)
80103b84:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b86:	53                   	push   %ebx
80103b87:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b8a:	e8 41 fb ff ff       	call   801036d0 <myproc>
  struct proc *p;
  int fd;
  if(curproc == initproc)
80103b8f:	3b 05 b8 b5 10 80    	cmp    0x8010b5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b95:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;
  if(curproc == initproc)
80103b97:	0f 84 fd 00 00 00    	je     80103c9a <exit+0x11a>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 10                	je     80103bb8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ba8:	89 04 24             	mov    %eax,(%esp)
80103bab:	e8 a0 d2 ff ff       	call   80100e50 <fileclose>
      curproc->ofile[fd] = 0;
80103bb0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103bb7:	00 
  int fd;
  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bb8:	83 c6 01             	add    $0x1,%esi
80103bbb:	83 fe 10             	cmp    $0x10,%esi
80103bbe:	75 e0                	jne    80103ba0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bc0:	e8 7b ef ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103bc5:	8b 43 68             	mov    0x68(%ebx),%eax
80103bc8:	89 04 24             	mov    %eax,(%esp)
80103bcb:	e8 30 dc ff ff       	call   80101800 <iput>
  end_op();
80103bd0:	e8 db ef ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103bd5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103bdc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103be3:	e8 68 06 00 00       	call   80104250 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103be8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103beb:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103bf0:	eb 14                	jmp    80103c06 <exit+0x86>
80103bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bf8:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103bfe:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103c04:	74 20                	je     80103c26 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103c06:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c0a:	75 ec                	jne    80103bf8 <exit+0x78>
80103c0c:	3b 42 20             	cmp    0x20(%edx),%eax
80103c0f:	75 e7                	jne    80103bf8 <exit+0x78>
      p->state = RUNNABLE;
80103c11:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c18:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103c1e:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103c24:	75 e0                	jne    80103c06 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c26:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103c2b:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
80103c30:	eb 14                	jmp    80103c46 <exit+0xc6>
80103c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c38:	81 c1 a0 00 00 00    	add    $0xa0,%ecx
80103c3e:	81 f9 54 65 11 80    	cmp    $0x80116554,%ecx
80103c44:	74 3c                	je     80103c82 <exit+0x102>
    if(p->parent == curproc){
80103c46:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c49:	75 ed                	jne    80103c38 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c4b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c4f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c52:	75 e4                	jne    80103c38 <exit+0xb8>
80103c54:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103c59:	eb 13                	jmp    80103c6e <exit+0xee>
80103c5b:	90                   	nop
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c60:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103c66:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103c6c:	74 ca                	je     80103c38 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c6e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c72:	75 ec                	jne    80103c60 <exit+0xe0>
80103c74:	3b 42 20             	cmp    0x20(%edx),%eax
80103c77:	75 e7                	jne    80103c60 <exit+0xe0>
      p->state = RUNNABLE;
80103c79:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c80:	eb de                	jmp    80103c60 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c82:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c89:	e8 52 fe ff ff       	call   80103ae0 <sched>
  panic("zombie exit");
80103c8e:	c7 04 24 5d 7d 10 80 	movl   $0x80107d5d,(%esp)
80103c95:	e8 c6 c6 ff ff       	call   80100360 <panic>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  if(curproc == initproc)
    panic("init exiting");
80103c9a:	c7 04 24 50 7d 10 80 	movl   $0x80107d50,(%esp)
80103ca1:	e8 ba c6 ff ff       	call   80100360 <panic>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cb6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cbd:	e8 8e 05 00 00       	call   80104250 <acquire>
  myproc()->state = RUNNABLE;
80103cc2:	e8 09 fa ff ff       	call   801036d0 <myproc>
80103cc7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cce:	e8 0d fe ff ff       	call   80103ae0 <sched>
  release(&ptable.lock);
80103cd3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cda:	e8 61 06 00 00       	call   80104340 <release>
}
80103cdf:	c9                   	leave  
80103ce0:	c3                   	ret    
80103ce1:	eb 0d                	jmp    80103cf0 <sleep>
80103ce3:	90                   	nop
80103ce4:	90                   	nop
80103ce5:	90                   	nop
80103ce6:	90                   	nop
80103ce7:	90                   	nop
80103ce8:	90                   	nop
80103ce9:	90                   	nop
80103cea:	90                   	nop
80103ceb:	90                   	nop
80103cec:	90                   	nop
80103ced:	90                   	nop
80103cee:	90                   	nop
80103cef:	90                   	nop

80103cf0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
80103cf9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103cff:	e8 cc f9 ff ff       	call   801036d0 <myproc>
  
  if(p == 0)
80103d04:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103d06:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103d08:	0f 84 7c 00 00 00    	je     80103d8a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103d0e:	85 f6                	test   %esi,%esi
80103d10:	74 6c                	je     80103d7e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d12:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103d18:	74 46                	je     80103d60 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d1a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d21:	e8 2a 05 00 00       	call   80104250 <acquire>
    release(lk);
80103d26:	89 34 24             	mov    %esi,(%esp)
80103d29:	e8 12 06 00 00       	call   80104340 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d2e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d31:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d38:	e8 a3 fd ff ff       	call   80103ae0 <sched>

  // Tidy up.
  p->chan = 0;
80103d3d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d44:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d4b:	e8 f0 05 00 00       	call   80104340 <release>
    acquire(lk);
80103d50:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103d53:	83 c4 1c             	add    $0x1c,%esp
80103d56:	5b                   	pop    %ebx
80103d57:	5e                   	pop    %esi
80103d58:	5f                   	pop    %edi
80103d59:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d5a:	e9 f1 04 00 00       	jmp    80104250 <acquire>
80103d5f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d60:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d63:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d6a:	e8 71 fd ff ff       	call   80103ae0 <sched>

  // Tidy up.
  p->chan = 0;
80103d6f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d76:	83 c4 1c             	add    $0x1c,%esp
80103d79:	5b                   	pop    %ebx
80103d7a:	5e                   	pop    %esi
80103d7b:	5f                   	pop    %edi
80103d7c:	5d                   	pop    %ebp
80103d7d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d7e:	c7 04 24 6f 7d 10 80 	movl   $0x80107d6f,(%esp)
80103d85:	e8 d6 c5 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d8a:	c7 04 24 69 7d 10 80 	movl   $0x80107d69,(%esp)
80103d91:	e8 ca c5 ff ff       	call   80100360 <panic>
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
80103da5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103da8:	e8 23 f9 ff ff       	call   801036d0 <myproc>
  
  acquire(&ptable.lock);
80103dad:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103db4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103db6:	e8 95 04 00 00       	call   80104250 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dbb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dbd:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103dc2:	eb 12                	jmp    80103dd6 <wait+0x36>
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103dce:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103dd4:	74 22                	je     80103df8 <wait+0x58>
      if(p->parent != curproc)
80103dd6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103dd9:	75 ed                	jne    80103dc8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103ddb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ddf:	74 34                	je     80103e15 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103de7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dec:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103df2:	75 e2                	jne    80103dd6 <wait+0x36>
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103df8:	85 c0                	test   %eax,%eax
80103dfa:	74 6e                	je     80103e6a <wait+0xca>
80103dfc:	8b 46 24             	mov    0x24(%esi),%eax
80103dff:	85 c0                	test   %eax,%eax
80103e01:	75 67                	jne    80103e6a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e03:	c7 44 24 04 20 3d 11 	movl   $0x80113d20,0x4(%esp)
80103e0a:	80 
80103e0b:	89 34 24             	mov    %esi,(%esp)
80103e0e:	e8 dd fe ff ff       	call   80103cf0 <sleep>
  }
80103e13:	eb a6                	jmp    80103dbb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e15:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e18:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e1b:	89 04 24             	mov    %eax,(%esp)
80103e1e:	e8 fd e4 ff ff       	call   80102320 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e23:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e26:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e2d:	89 04 24             	mov    %eax,(%esp)
80103e30:	e8 3b 2f 00 00       	call   80106d70 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103e35:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e3c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e43:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e4a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e4e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e55:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e5c:	e8 df 04 00 00       	call   80104340 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e61:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e64:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e66:	5b                   	pop    %ebx
80103e67:	5e                   	pop    %esi
80103e68:	5d                   	pop    %ebp
80103e69:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e6a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e71:	e8 ca 04 00 00       	call   80104340 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e76:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e7e:	5b                   	pop    %ebx
80103e7f:	5e                   	pop    %esi
80103e80:	5d                   	pop    %ebp
80103e81:	c3                   	ret    
80103e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 14             	sub    $0x14,%esp
80103e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e9a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ea1:	e8 aa 03 00 00       	call   80104250 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea6:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103eab:	eb 0f                	jmp    80103ebc <wakeup+0x2c>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
80103eb0:	05 a0 00 00 00       	add    $0xa0,%eax
80103eb5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103eba:	74 24                	je     80103ee0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103ebc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ec0:	75 ee                	jne    80103eb0 <wakeup+0x20>
80103ec2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ec5:	75 e9                	jne    80103eb0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ec7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ece:	05 a0 00 00 00       	add    $0xa0,%eax
80103ed3:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103ed8:	75 e2                	jne    80103ebc <wakeup+0x2c>
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ee0:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103ee7:	83 c4 14             	add    $0x14,%esp
80103eea:	5b                   	pop    %ebx
80103eeb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103eec:	e9 4f 04 00 00       	jmp    80104340 <release>
80103ef1:	eb 0d                	jmp    80103f00 <kill>
80103ef3:	90                   	nop
80103ef4:	90                   	nop
80103ef5:	90                   	nop
80103ef6:	90                   	nop
80103ef7:	90                   	nop
80103ef8:	90                   	nop
80103ef9:	90                   	nop
80103efa:	90                   	nop
80103efb:	90                   	nop
80103efc:	90                   	nop
80103efd:	90                   	nop
80103efe:	90                   	nop
80103eff:	90                   	nop

80103f00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 14             	sub    $0x14,%esp
80103f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f0a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f11:	e8 3a 03 00 00       	call   80104250 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f1b:	eb 0f                	jmp    80103f2c <kill+0x2c>
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
80103f20:	05 a0 00 00 00       	add    $0xa0,%eax
80103f25:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103f2a:	74 3c                	je     80103f68 <kill+0x68>
    if(p->pid == pid){
80103f2c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f2f:	75 ef                	jne    80103f20 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f31:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f35:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f3c:	74 1a                	je     80103f58 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f3e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f45:	e8 f6 03 00 00       	call   80104340 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f4a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f4d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f4f:	5b                   	pop    %ebx
80103f50:	5d                   	pop    %ebp
80103f51:	c3                   	ret    
80103f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f58:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f5f:	eb dd                	jmp    80103f3e <kill+0x3e>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f68:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f6f:	e8 cc 03 00 00       	call   80104340 <release>
  return -1;
}
80103f74:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f7c:	5b                   	pop    %ebx
80103f7d:	5d                   	pop    %ebp
80103f7e:	c3                   	ret    
80103f7f:	90                   	nop

80103f80 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80103f8b:	83 ec 4c             	sub    $0x4c,%esp
80103f8e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f91:	eb 23                	jmp    80103fb6 <procdump+0x36>
80103f93:	90                   	nop
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f98:	c7 04 24 7f 82 10 80 	movl   $0x8010827f,(%esp)
80103f9f:	e8 ac c6 ff ff       	call   80100650 <cprintf>
80103fa4:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103faa:	81 fb c0 65 11 80    	cmp    $0x801165c0,%ebx
80103fb0:	0f 84 8a 00 00 00    	je     80104040 <procdump+0xc0>
    if(p->state == UNUSED)
80103fb6:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fb9:	85 c0                	test   %eax,%eax
80103fbb:	74 e7                	je     80103fa4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fbd:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fc0:	ba 80 7d 10 80       	mov    $0x80107d80,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fc5:	77 11                	ja     80103fd8 <procdump+0x58>
80103fc7:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fce:	b8 80 7d 10 80       	mov    $0x80107d80,%eax
80103fd3:	85 d2                	test   %edx,%edx
80103fd5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fd8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fdf:	89 54 24 08          	mov    %edx,0x8(%esp)
80103fe3:	c7 04 24 84 7d 10 80 	movl   $0x80107d84,(%esp)
80103fea:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fee:	e8 5d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103ff3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ff7:	75 9f                	jne    80103f98 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ff9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104000:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104003:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104006:	8b 40 0c             	mov    0xc(%eax),%eax
80104009:	83 c0 08             	add    $0x8,%eax
8010400c:	89 04 24             	mov    %eax,(%esp)
8010400f:	e8 6c 01 00 00       	call   80104180 <getcallerpcs>
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104018:	8b 17                	mov    (%edi),%edx
8010401a:	85 d2                	test   %edx,%edx
8010401c:	0f 84 76 ff ff ff    	je     80103f98 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104022:	89 54 24 04          	mov    %edx,0x4(%esp)
80104026:	83 c7 04             	add    $0x4,%edi
80104029:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
80104030:	e8 1b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104035:	39 f7                	cmp    %esi,%edi
80104037:	75 df                	jne    80104018 <procdump+0x98>
80104039:	e9 5a ff ff ff       	jmp    80103f98 <procdump+0x18>
8010403e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104040:	83 c4 4c             	add    $0x4c,%esp
80104043:	5b                   	pop    %ebx
80104044:	5e                   	pop    %esi
80104045:	5f                   	pop    %edi
80104046:	5d                   	pop    %ebp
80104047:	c3                   	ret    
80104048:	66 90                	xchg   %ax,%ax
8010404a:	66 90                	xchg   %ax,%ax
8010404c:	66 90                	xchg   %ax,%ax
8010404e:	66 90                	xchg   %ax,%ax

80104050 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 14             	sub    $0x14,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010405a:	c7 44 24 04 f8 7d 10 	movl   $0x80107df8,0x4(%esp)
80104061:	80 
80104062:	8d 43 04             	lea    0x4(%ebx),%eax
80104065:	89 04 24             	mov    %eax,(%esp)
80104068:	e8 f3 00 00 00       	call   80104160 <initlock>
  lk->name = name;
8010406d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104070:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104076:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010407d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104080:	83 c4 14             	add    $0x14,%esp
80104083:	5b                   	pop    %ebx
80104084:	5d                   	pop    %ebp
80104085:	c3                   	ret    
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
80104095:	83 ec 10             	sub    $0x10,%esp
80104098:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010409b:	8d 73 04             	lea    0x4(%ebx),%esi
8010409e:	89 34 24             	mov    %esi,(%esp)
801040a1:	e8 aa 01 00 00       	call   80104250 <acquire>
  while (lk->locked) {
801040a6:	8b 13                	mov    (%ebx),%edx
801040a8:	85 d2                	test   %edx,%edx
801040aa:	74 16                	je     801040c2 <acquiresleep+0x32>
801040ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040b0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040b4:	89 1c 24             	mov    %ebx,(%esp)
801040b7:	e8 34 fc ff ff       	call   80103cf0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040bc:	8b 03                	mov    (%ebx),%eax
801040be:	85 c0                	test   %eax,%eax
801040c0:	75 ee                	jne    801040b0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040c2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040c8:	e8 03 f6 ff ff       	call   801036d0 <myproc>
801040cd:	8b 40 10             	mov    0x10(%eax),%eax
801040d0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040d3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040d6:	83 c4 10             	add    $0x10,%esp
801040d9:	5b                   	pop    %ebx
801040da:	5e                   	pop    %esi
801040db:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040dc:	e9 5f 02 00 00       	jmp    80104340 <release>
801040e1:	eb 0d                	jmp    801040f0 <releasesleep>
801040e3:	90                   	nop
801040e4:	90                   	nop
801040e5:	90                   	nop
801040e6:	90                   	nop
801040e7:	90                   	nop
801040e8:	90                   	nop
801040e9:	90                   	nop
801040ea:	90                   	nop
801040eb:	90                   	nop
801040ec:	90                   	nop
801040ed:	90                   	nop
801040ee:	90                   	nop
801040ef:	90                   	nop

801040f0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
801040f5:	83 ec 10             	sub    $0x10,%esp
801040f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040fb:	8d 73 04             	lea    0x4(%ebx),%esi
801040fe:	89 34 24             	mov    %esi,(%esp)
80104101:	e8 4a 01 00 00       	call   80104250 <acquire>
  lk->locked = 0;
80104106:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010410c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104113:	89 1c 24             	mov    %ebx,(%esp)
80104116:	e8 75 fd ff ff       	call   80103e90 <wakeup>
  release(&lk->lk);
8010411b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	5b                   	pop    %ebx
80104122:	5e                   	pop    %esi
80104123:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104124:	e9 17 02 00 00       	jmp    80104340 <release>
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	83 ec 10             	sub    $0x10,%esp
80104138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010413b:	8d 73 04             	lea    0x4(%ebx),%esi
8010413e:	89 34 24             	mov    %esi,(%esp)
80104141:	e8 0a 01 00 00       	call   80104250 <acquire>
  r = lk->locked;
80104146:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104148:	89 34 24             	mov    %esi,(%esp)
8010414b:	e8 f0 01 00 00       	call   80104340 <release>
  return r;
}
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	89 d8                	mov    %ebx,%eax
80104155:	5b                   	pop    %ebx
80104156:	5e                   	pop    %esi
80104157:	5d                   	pop    %ebp
80104158:	c3                   	ret    
80104159:	66 90                	xchg   %ax,%ax
8010415b:	66 90                	xchg   %ax,%ax
8010415d:	66 90                	xchg   %ax,%ax
8010415f:	90                   	nop

80104160 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104166:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010416f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104172:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104179:	5d                   	pop    %ebp
8010417a:	c3                   	ret    
8010417b:	90                   	nop
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104180 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104189:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010418a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010418d:	31 c0                	xor    %eax,%eax
8010418f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104190:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104196:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010419c:	77 1a                	ja     801041b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010419e:	8b 5a 04             	mov    0x4(%edx),%ebx
801041a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041a9:	83 f8 0a             	cmp    $0xa,%eax
801041ac:	75 e2                	jne    80104190 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ae:	5b                   	pop    %ebx
801041af:	5d                   	pop    %ebp
801041b0:	c3                   	ret    
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041bf:	83 c0 01             	add    $0x1,%eax
801041c2:	83 f8 0a             	cmp    $0xa,%eax
801041c5:	74 e7                	je     801041ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801041c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ce:	83 c0 01             	add    $0x1,%eax
801041d1:	83 f8 0a             	cmp    $0xa,%eax
801041d4:	75 e2                	jne    801041b8 <getcallerpcs+0x38>
801041d6:	eb d6                	jmp    801041ae <getcallerpcs+0x2e>
801041d8:	90                   	nop
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041e0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041e0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801041e1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041e3:	89 e5                	mov    %esp,%ebp
801041e5:	53                   	push   %ebx
801041e6:	83 ec 04             	sub    $0x4,%esp
801041e9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801041ec:	8b 0a                	mov    (%edx),%ecx
801041ee:	85 c9                	test   %ecx,%ecx
801041f0:	74 10                	je     80104202 <holding+0x22>
801041f2:	8b 5a 08             	mov    0x8(%edx),%ebx
801041f5:	e8 36 f4 ff ff       	call   80103630 <mycpu>
801041fa:	39 c3                	cmp    %eax,%ebx
801041fc:	0f 94 c0             	sete   %al
801041ff:	0f b6 c0             	movzbl %al,%eax
}
80104202:	83 c4 04             	add    $0x4,%esp
80104205:	5b                   	pop    %ebx
80104206:	5d                   	pop    %ebp
80104207:	c3                   	ret    
80104208:	90                   	nop
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104210 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 04             	sub    $0x4,%esp
80104217:	9c                   	pushf  
80104218:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104219:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010421a:	e8 11 f4 ff ff       	call   80103630 <mycpu>
8010421f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104225:	85 c0                	test   %eax,%eax
80104227:	75 11                	jne    8010423a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104229:	e8 02 f4 ff ff       	call   80103630 <mycpu>
8010422e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104234:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010423a:	e8 f1 f3 ff ff       	call   80103630 <mycpu>
8010423f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104246:	83 c4 04             	add    $0x4,%esp
80104249:	5b                   	pop    %ebx
8010424a:	5d                   	pop    %ebp
8010424b:	c3                   	ret    
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104250 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104257:	e8 b4 ff ff ff       	call   80104210 <pushcli>
  if(holding(lk))
8010425c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010425f:	8b 02                	mov    (%edx),%eax
80104261:	85 c0                	test   %eax,%eax
80104263:	75 43                	jne    801042a8 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104265:	b9 01 00 00 00       	mov    $0x1,%ecx
8010426a:	eb 07                	jmp    80104273 <acquire+0x23>
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104270:	8b 55 08             	mov    0x8(%ebp),%edx
80104273:	89 c8                	mov    %ecx,%eax
80104275:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104278:	85 c0                	test   %eax,%eax
8010427a:	75 f4                	jne    80104270 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010427c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104281:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104284:	e8 a7 f3 ff ff       	call   80103630 <mycpu>
80104289:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010428c:	8b 45 08             	mov    0x8(%ebp),%eax
8010428f:	83 c0 0c             	add    $0xc,%eax
80104292:	89 44 24 04          	mov    %eax,0x4(%esp)
80104296:	8d 45 08             	lea    0x8(%ebp),%eax
80104299:	89 04 24             	mov    %eax,(%esp)
8010429c:	e8 df fe ff ff       	call   80104180 <getcallerpcs>
}
801042a1:	83 c4 14             	add    $0x14,%esp
801042a4:	5b                   	pop    %ebx
801042a5:	5d                   	pop    %ebp
801042a6:	c3                   	ret    
801042a7:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042a8:	8b 5a 08             	mov    0x8(%edx),%ebx
801042ab:	e8 80 f3 ff ff       	call   80103630 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042b0:	39 c3                	cmp    %eax,%ebx
801042b2:	74 05                	je     801042b9 <acquire+0x69>
801042b4:	8b 55 08             	mov    0x8(%ebp),%edx
801042b7:	eb ac                	jmp    80104265 <acquire+0x15>
    panic("acquire");
801042b9:	c7 04 24 03 7e 10 80 	movl   $0x80107e03,(%esp)
801042c0:	e8 9b c0 ff ff       	call   80100360 <panic>
801042c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042d0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042d6:	9c                   	pushf  
801042d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042d8:	f6 c4 02             	test   $0x2,%ah
801042db:	75 49                	jne    80104326 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042dd:	e8 4e f3 ff ff       	call   80103630 <mycpu>
801042e2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042e8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042eb:	85 d2                	test   %edx,%edx
801042ed:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801042f3:	78 25                	js     8010431a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042f5:	e8 36 f3 ff ff       	call   80103630 <mycpu>
801042fa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104300:	85 d2                	test   %edx,%edx
80104302:	74 04                	je     80104308 <popcli+0x38>
    sti();
}
80104304:	c9                   	leave  
80104305:	c3                   	ret    
80104306:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104308:	e8 23 f3 ff ff       	call   80103630 <mycpu>
8010430d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104313:	85 c0                	test   %eax,%eax
80104315:	74 ed                	je     80104304 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104317:	fb                   	sti    
    sti();
}
80104318:	c9                   	leave  
80104319:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010431a:	c7 04 24 22 7e 10 80 	movl   $0x80107e22,(%esp)
80104321:	e8 3a c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104326:	c7 04 24 0b 7e 10 80 	movl   $0x80107e0b,(%esp)
8010432d:	e8 2e c0 ff ff       	call   80100360 <panic>
80104332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	83 ec 10             	sub    $0x10,%esp
80104348:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010434b:	8b 03                	mov    (%ebx),%eax
8010434d:	85 c0                	test   %eax,%eax
8010434f:	75 0f                	jne    80104360 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104351:	c7 04 24 29 7e 10 80 	movl   $0x80107e29,(%esp)
80104358:	e8 03 c0 ff ff       	call   80100360 <panic>
8010435d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104360:	8b 73 08             	mov    0x8(%ebx),%esi
80104363:	e8 c8 f2 ff ff       	call   80103630 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104368:	39 c6                	cmp    %eax,%esi
8010436a:	75 e5                	jne    80104351 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010436c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104373:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010437a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010437f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	5b                   	pop    %ebx
80104389:	5e                   	pop    %esi
8010438a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010438b:	e9 40 ff ff ff       	jmp    801042d0 <popcli>

80104390 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	8b 55 08             	mov    0x8(%ebp),%edx
80104396:	57                   	push   %edi
80104397:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010439a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010439b:	f6 c2 03             	test   $0x3,%dl
8010439e:	75 05                	jne    801043a5 <memset+0x15>
801043a0:	f6 c1 03             	test   $0x3,%cl
801043a3:	74 13                	je     801043b8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043a5:	89 d7                	mov    %edx,%edi
801043a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043aa:	fc                   	cld    
801043ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043ad:	5b                   	pop    %ebx
801043ae:	89 d0                	mov    %edx,%eax
801043b0:	5f                   	pop    %edi
801043b1:	5d                   	pop    %ebp
801043b2:	c3                   	ret    
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043bc:	c1 e9 02             	shr    $0x2,%ecx
801043bf:	89 f8                	mov    %edi,%eax
801043c1:	89 fb                	mov    %edi,%ebx
801043c3:	c1 e0 18             	shl    $0x18,%eax
801043c6:	c1 e3 10             	shl    $0x10,%ebx
801043c9:	09 d8                	or     %ebx,%eax
801043cb:	09 f8                	or     %edi,%eax
801043cd:	c1 e7 08             	shl    $0x8,%edi
801043d0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043d2:	89 d7                	mov    %edx,%edi
801043d4:	fc                   	cld    
801043d5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801043d7:	5b                   	pop    %ebx
801043d8:	89 d0                	mov    %edx,%eax
801043da:	5f                   	pop    %edi
801043db:	5d                   	pop    %ebp
801043dc:	c3                   	ret    
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	8b 45 10             	mov    0x10(%ebp),%eax
801043e6:	57                   	push   %edi
801043e7:	56                   	push   %esi
801043e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043eb:	53                   	push   %ebx
801043ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043ef:	85 c0                	test   %eax,%eax
801043f1:	8d 78 ff             	lea    -0x1(%eax),%edi
801043f4:	74 26                	je     8010441c <memcmp+0x3c>
    if(*s1 != *s2)
801043f6:	0f b6 03             	movzbl (%ebx),%eax
801043f9:	31 d2                	xor    %edx,%edx
801043fb:	0f b6 0e             	movzbl (%esi),%ecx
801043fe:	38 c8                	cmp    %cl,%al
80104400:	74 16                	je     80104418 <memcmp+0x38>
80104402:	eb 24                	jmp    80104428 <memcmp+0x48>
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104408:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010440d:	83 c2 01             	add    $0x1,%edx
80104410:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104414:	38 c8                	cmp    %cl,%al
80104416:	75 10                	jne    80104428 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104418:	39 fa                	cmp    %edi,%edx
8010441a:	75 ec                	jne    80104408 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010441c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010441d:	31 c0                	xor    %eax,%eax
}
8010441f:	5e                   	pop    %esi
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret    
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104428:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104429:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010442b:	5e                   	pop    %esi
8010442c:	5f                   	pop    %edi
8010442d:	5d                   	pop    %ebp
8010442e:	c3                   	ret    
8010442f:	90                   	nop

80104430 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	8b 45 08             	mov    0x8(%ebp),%eax
80104437:	56                   	push   %esi
80104438:	8b 75 0c             	mov    0xc(%ebp),%esi
8010443b:	53                   	push   %ebx
8010443c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010443f:	39 c6                	cmp    %eax,%esi
80104441:	73 35                	jae    80104478 <memmove+0x48>
80104443:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104446:	39 c8                	cmp    %ecx,%eax
80104448:	73 2e                	jae    80104478 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010444a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010444c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010444f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104452:	74 1b                	je     8010446f <memmove+0x3f>
80104454:	f7 db                	neg    %ebx
80104456:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104459:	01 fb                	add    %edi,%ebx
8010445b:	90                   	nop
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104460:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104464:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104467:	83 ea 01             	sub    $0x1,%edx
8010446a:	83 fa ff             	cmp    $0xffffffff,%edx
8010446d:	75 f1                	jne    80104460 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010446f:	5b                   	pop    %ebx
80104470:	5e                   	pop    %esi
80104471:	5f                   	pop    %edi
80104472:	5d                   	pop    %ebp
80104473:	c3                   	ret    
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104478:	31 d2                	xor    %edx,%edx
8010447a:	85 db                	test   %ebx,%ebx
8010447c:	74 f1                	je     8010446f <memmove+0x3f>
8010447e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104480:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104484:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104487:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010448a:	39 da                	cmp    %ebx,%edx
8010448c:	75 f2                	jne    80104480 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010448e:	5b                   	pop    %ebx
8010448f:	5e                   	pop    %esi
80104490:	5f                   	pop    %edi
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    
80104493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044a3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044a4:	e9 87 ff ff ff       	jmp    80104430 <memmove>
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	8b 75 10             	mov    0x10(%ebp),%esi
801044b7:	53                   	push   %ebx
801044b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044be:	85 f6                	test   %esi,%esi
801044c0:	74 30                	je     801044f2 <strncmp+0x42>
801044c2:	0f b6 01             	movzbl (%ecx),%eax
801044c5:	84 c0                	test   %al,%al
801044c7:	74 2f                	je     801044f8 <strncmp+0x48>
801044c9:	0f b6 13             	movzbl (%ebx),%edx
801044cc:	38 d0                	cmp    %dl,%al
801044ce:	75 46                	jne    80104516 <strncmp+0x66>
801044d0:	8d 51 01             	lea    0x1(%ecx),%edx
801044d3:	01 ce                	add    %ecx,%esi
801044d5:	eb 14                	jmp    801044eb <strncmp+0x3b>
801044d7:	90                   	nop
801044d8:	0f b6 02             	movzbl (%edx),%eax
801044db:	84 c0                	test   %al,%al
801044dd:	74 31                	je     80104510 <strncmp+0x60>
801044df:	0f b6 19             	movzbl (%ecx),%ebx
801044e2:	83 c2 01             	add    $0x1,%edx
801044e5:	38 d8                	cmp    %bl,%al
801044e7:	75 17                	jne    80104500 <strncmp+0x50>
    n--, p++, q++;
801044e9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044eb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044ed:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044f0:	75 e6                	jne    801044d8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044f2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801044f3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801044f5:	5e                   	pop    %esi
801044f6:	5d                   	pop    %ebp
801044f7:	c3                   	ret    
801044f8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044fb:	31 c0                	xor    %eax,%eax
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104500:	0f b6 d3             	movzbl %bl,%edx
80104503:	29 d0                	sub    %edx,%eax
}
80104505:	5b                   	pop    %ebx
80104506:	5e                   	pop    %esi
80104507:	5d                   	pop    %ebp
80104508:	c3                   	ret    
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104510:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104514:	eb ea                	jmp    80104500 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104516:	89 d3                	mov    %edx,%ebx
80104518:	eb e6                	jmp    80104500 <strncmp+0x50>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
80104526:	56                   	push   %esi
80104527:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010452a:	53                   	push   %ebx
8010452b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010452e:	89 c2                	mov    %eax,%edx
80104530:	eb 19                	jmp    8010454b <strncpy+0x2b>
80104532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104538:	83 c3 01             	add    $0x1,%ebx
8010453b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010453f:	83 c2 01             	add    $0x1,%edx
80104542:	84 c9                	test   %cl,%cl
80104544:	88 4a ff             	mov    %cl,-0x1(%edx)
80104547:	74 09                	je     80104552 <strncpy+0x32>
80104549:	89 f1                	mov    %esi,%ecx
8010454b:	85 c9                	test   %ecx,%ecx
8010454d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104550:	7f e6                	jg     80104538 <strncpy+0x18>
    ;
  while(n-- > 0)
80104552:	31 c9                	xor    %ecx,%ecx
80104554:	85 f6                	test   %esi,%esi
80104556:	7e 0f                	jle    80104567 <strncpy+0x47>
    *s++ = 0;
80104558:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010455c:	89 f3                	mov    %esi,%ebx
8010455e:	83 c1 01             	add    $0x1,%ecx
80104561:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104563:	85 db                	test   %ebx,%ebx
80104565:	7f f1                	jg     80104558 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104567:	5b                   	pop    %ebx
80104568:	5e                   	pop    %esi
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104576:	56                   	push   %esi
80104577:	8b 45 08             	mov    0x8(%ebp),%eax
8010457a:	53                   	push   %ebx
8010457b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010457e:	85 c9                	test   %ecx,%ecx
80104580:	7e 26                	jle    801045a8 <safestrcpy+0x38>
80104582:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104586:	89 c1                	mov    %eax,%ecx
80104588:	eb 17                	jmp    801045a1 <safestrcpy+0x31>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104590:	83 c2 01             	add    $0x1,%edx
80104593:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104597:	83 c1 01             	add    $0x1,%ecx
8010459a:	84 db                	test   %bl,%bl
8010459c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010459f:	74 04                	je     801045a5 <safestrcpy+0x35>
801045a1:	39 f2                	cmp    %esi,%edx
801045a3:	75 eb                	jne    80104590 <safestrcpy+0x20>
    ;
  *s = 0;
801045a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045a8:	5b                   	pop    %ebx
801045a9:	5e                   	pop    %esi
801045aa:	5d                   	pop    %ebp
801045ab:	c3                   	ret    
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <strlen>:

int
strlen(const char *s)
{
801045b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045b1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045b3:	89 e5                	mov    %esp,%ebp
801045b5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045b8:	80 3a 00             	cmpb   $0x0,(%edx)
801045bb:	74 0c                	je     801045c9 <strlen+0x19>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
801045c0:	83 c0 01             	add    $0x1,%eax
801045c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045c7:	75 f7                	jne    801045c0 <strlen+0x10>
    ;
  return n;
}
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    

801045cb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045d3:	55                   	push   %ebp
  pushl %ebx
801045d4:	53                   	push   %ebx
  pushl %esi
801045d5:	56                   	push   %esi
  pushl %edi
801045d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045db:	5f                   	pop    %edi
  popl %esi
801045dc:	5e                   	pop    %esi
  popl %ebx
801045dd:	5b                   	pop    %ebx
  popl %ebp
801045de:	5d                   	pop    %ebp
  ret
801045df:	c3                   	ret    

801045e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 04             	sub    $0x4,%esp
801045e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
801045ea:	e8 e1 f0 ff ff       	call   801036d0 <myproc>
 	if(addr >= curproc->tstack && addr+4 <= USEREND){ // FOR CS153 lab2 part1
801045ef:	39 58 7c             	cmp    %ebx,0x7c(%eax)
801045f2:	77 1c                	ja     80104610 <fetchint+0x30>
801045f4:	8d 53 04             	lea    0x4(%ebx),%edx
801045f7:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
801045fd:	77 11                	ja     80104610 <fetchint+0x30>
		goto exe;
	}
 	else if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
	exe:
  *ip = *(int*)(addr);
801045ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104602:	8b 13                	mov    (%ebx),%edx
80104604:	89 10                	mov    %edx,(%eax)
  return 0;
80104606:	31 c0                	xor    %eax,%eax
}
80104608:	83 c4 04             	add    $0x4,%esp
8010460b:	5b                   	pop    %ebx
8010460c:	5d                   	pop    %ebp
8010460d:	c3                   	ret    
8010460e:	66 90                	xchg   %ax,%ax
{
	struct proc *curproc = myproc();
 	if(addr >= curproc->tstack && addr+4 <= USEREND){ // FOR CS153 lab2 part1
		goto exe;
	}
 	else if(addr >= curproc->sz || addr+4 > curproc->sz)
80104610:	8b 00                	mov    (%eax),%eax
80104612:	39 c3                	cmp    %eax,%ebx
80104614:	73 07                	jae    8010461d <fetchint+0x3d>
80104616:	8d 53 04             	lea    0x4(%ebx),%edx
80104619:	39 d0                	cmp    %edx,%eax
8010461b:	73 e2                	jae    801045ff <fetchint+0x1f>
    return -1;
8010461d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104622:	eb e4                	jmp    80104608 <fetchint+0x28>
80104624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010462a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104630 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010463a:	e8 91 f0 ff ff       	call   801036d0 <myproc>
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
8010463f:	39 58 7c             	cmp    %ebx,0x7c(%eax)
80104642:	77 44                	ja     80104688 <fetchstr+0x58>
80104644:	8d 53 04             	lea    0x4(%ebx),%edx
80104647:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
8010464d:	77 39                	ja     80104688 <fetchstr+0x58>
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
8010464f:	8b 55 0c             	mov    0xc(%ebp),%edx
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
80104652:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
80104658:	89 d8                	mov    %ebx,%eax
8010465a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
8010465c:	77 1e                	ja     8010467c <fetchstr+0x4c>
    if(*s == 0)
8010465e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104661:	75 0f                	jne    80104672 <fetchstr+0x42>
80104663:	eb 2b                	jmp    80104690 <fetchstr+0x60>
80104665:	8d 76 00             	lea    0x0(%esi),%esi
80104668:	80 38 00             	cmpb   $0x0,(%eax)
8010466b:	90                   	nop
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104670:	74 1e                	je     80104690 <fetchstr+0x60>
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
80104672:	83 c0 01             	add    $0x1,%eax
80104675:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010467a:	75 ec                	jne    80104668 <fetchstr+0x38>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010467c:	83 c4 04             	add    $0x4,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
8010467f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104684:	5b                   	pop    %ebx
80104685:	5d                   	pop    %ebp
80104686:	c3                   	ret    
80104687:	90                   	nop
{
  char *s, *ep;
  struct proc *curproc = myproc();
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
80104688:	3b 18                	cmp    (%eax),%ebx
8010468a:	72 c3                	jb     8010464f <fetchstr+0x1f>
8010468c:	eb ee                	jmp    8010467c <fetchstr+0x4c>
8010468e:	66 90                	xchg   %ax,%ax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104690:	83 c4 04             	add    $0x4,%esp
	exe:
  *pp = (char*)addr;
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104693:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104695:	5b                   	pop    %ebx
80104696:	5d                   	pop    %ebp
80104697:	c3                   	ret    
80104698:	90                   	nop
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	8b 75 0c             	mov    0xc(%ebp),%esi
801046a7:	53                   	push   %ebx
801046a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046ab:	e8 20 f0 ff ff       	call   801036d0 <myproc>
801046b0:	89 75 0c             	mov    %esi,0xc(%ebp)
801046b3:	8b 40 18             	mov    0x18(%eax),%eax
801046b6:	8b 40 44             	mov    0x44(%eax),%eax
801046b9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046bd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801046c0:	5b                   	pop    %ebx
801046c1:	5e                   	pop    %esi
801046c2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046c3:	e9 18 ff ff ff       	jmp    801045e0 <fetchint>
801046c8:	90                   	nop
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	83 ec 20             	sub    $0x20,%esp
801046d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801046db:	e8 f0 ef ff ff       	call   801036d0 <myproc>
  if(size < 0 || argint(n, &i) < 0)
801046e0:	85 db                	test   %ebx,%ebx
801046e2:	78 4c                	js     80104730 <argptr+0x60>
801046e4:	89 c6                	mov    %eax,%esi
801046e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046ed:	8b 45 08             	mov    0x8(%ebp),%eax
801046f0:	89 04 24             	mov    %eax,(%esp)
801046f3:	e8 a8 ff ff ff       	call   801046a0 <argint>
801046f8:	85 c0                	test   %eax,%eax
801046fa:	78 34                	js     80104730 <argptr+0x60>
    return -1;
 	if(i >= curproc->tstack && i+size <= USEREND) // FOR CS153 lab2 part1 
801046fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ff:	3b 56 7c             	cmp    0x7c(%esi),%edx
80104702:	73 1c                	jae    80104720 <argptr+0x50>
    	 goto exe;
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104704:	8b 06                	mov    (%esi),%eax
80104706:	39 c2                	cmp    %eax,%edx
80104708:	73 26                	jae    80104730 <argptr+0x60>
8010470a:	01 d3                	add    %edx,%ebx
8010470c:	39 d8                	cmp    %ebx,%eax
8010470e:	72 20                	jb     80104730 <argptr+0x60>
    return -1;
	exe:
  *pp = (char*)i;
80104710:	8b 45 0c             	mov    0xc(%ebp),%eax
80104713:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104715:	83 c4 20             	add    $0x20,%esp
    	 goto exe;
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
80104718:	31 c0                	xor    %eax,%eax
}
8010471a:	5b                   	pop    %ebx
8010471b:	5e                   	pop    %esi
8010471c:	5d                   	pop    %ebp
8010471d:	c3                   	ret    
8010471e:	66 90                	xchg   %ax,%ax
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
 	if(i >= curproc->tstack && i+size <= USEREND) // FOR CS153 lab2 part1 
80104720:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80104723:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80104728:	76 e6                	jbe    80104710 <argptr+0x40>
8010472a:	eb d8                	jmp    80104704 <argptr+0x34>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
}
80104730:	83 c4 20             	add    $0x20,%esp
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
80104733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
}
80104738:	5b                   	pop    %ebx
80104739:	5e                   	pop    %esi
8010473a:	5d                   	pop    %ebp
8010473b:	c3                   	ret    
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010474d:	8b 45 08             	mov    0x8(%ebp),%eax
80104750:	89 04 24             	mov    %eax,(%esp)
80104753:	e8 48 ff ff ff       	call   801046a0 <argint>
80104758:	85 c0                	test   %eax,%eax
8010475a:	78 14                	js     80104770 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010475c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	89 04 24             	mov    %eax,(%esp)
80104769:	e8 c2 fe ff ff       	call   80104630 <fetchstr>
}
8010476e:	c9                   	leave  
8010476f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104775:	c9                   	leave  
80104776:	c3                   	ret    
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104788:	e8 43 ef ff ff       	call   801036d0 <myproc>

  num = curproc->tf->eax;
8010478d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104790:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104792:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104795:	8d 50 ff             	lea    -0x1(%eax),%edx
80104798:	83 fa 16             	cmp    $0x16,%edx
8010479b:	77 1b                	ja     801047b8 <syscall+0x38>
8010479d:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
801047a4:	85 d2                	test   %edx,%edx
801047a6:	74 10                	je     801047b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801047a8:	ff d2                	call   *%edx
801047aa:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	5b                   	pop    %ebx
801047b1:	5e                   	pop    %esi
801047b2:	5d                   	pop    %ebp
801047b3:	c3                   	ret    
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801047bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047bf:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047c3:	8b 43 10             	mov    0x10(%ebx),%eax
801047c6:	c7 04 24 31 7e 10 80 	movl   $0x80107e31,(%esp)
801047cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801047d1:	e8 7a be ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047d6:	8b 43 18             	mov    0x18(%ebx),%eax
801047d9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	5b                   	pop    %ebx
801047e4:	5e                   	pop    %esi
801047e5:	5d                   	pop    %ebp
801047e6:	c3                   	ret    
801047e7:	66 90                	xchg   %ax,%ax
801047e9:	66 90                	xchg   %ax,%ax
801047eb:	66 90                	xchg   %ax,%ax
801047ed:	66 90                	xchg   %ax,%ax
801047ef:	90                   	nop

801047f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	89 c3                	mov    %eax,%ebx
801047f6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801047f9:	e8 d2 ee ff ff       	call   801036d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801047fe:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104800:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104804:	85 c9                	test   %ecx,%ecx
80104806:	74 18                	je     80104820 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104808:	83 c2 01             	add    $0x1,%edx
8010480b:	83 fa 10             	cmp    $0x10,%edx
8010480e:	75 f0                	jne    80104800 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104810:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104818:	5b                   	pop    %ebx
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104820:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104824:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104827:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104829:	5b                   	pop    %ebx
8010482a:	5d                   	pop    %ebp
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	53                   	push   %ebx
80104836:	83 ec 4c             	sub    $0x4c,%esp
80104839:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010483c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010483f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104842:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104846:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104849:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010484c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010484f:	e8 fc d6 ff ff       	call   80101f50 <nameiparent>
80104854:	85 c0                	test   %eax,%eax
80104856:	89 c7                	mov    %eax,%edi
80104858:	0f 84 da 00 00 00    	je     80104938 <create+0x108>
    return 0;
  ilock(dp);
8010485e:	89 04 24             	mov    %eax,(%esp)
80104861:	e8 7a ce ff ff       	call   801016e0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104866:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104869:	89 44 24 08          	mov    %eax,0x8(%esp)
8010486d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104871:	89 3c 24             	mov    %edi,(%esp)
80104874:	e8 77 d3 ff ff       	call   80101bf0 <dirlookup>
80104879:	85 c0                	test   %eax,%eax
8010487b:	89 c6                	mov    %eax,%esi
8010487d:	74 41                	je     801048c0 <create+0x90>
    iunlockput(dp);
8010487f:	89 3c 24             	mov    %edi,(%esp)
80104882:	e8 b9 d0 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80104887:	89 34 24             	mov    %esi,(%esp)
8010488a:	e8 51 ce ff ff       	call   801016e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010488f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104894:	75 12                	jne    801048a8 <create+0x78>
80104896:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010489b:	89 f0                	mov    %esi,%eax
8010489d:	75 09                	jne    801048a8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010489f:	83 c4 4c             	add    $0x4c,%esp
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5f                   	pop    %edi
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    
801048a7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801048a8:	89 34 24             	mov    %esi,(%esp)
801048ab:	e8 90 d0 ff ff       	call   80101940 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048b0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048b3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048b5:	5b                   	pop    %ebx
801048b6:	5e                   	pop    %esi
801048b7:	5f                   	pop    %edi
801048b8:	5d                   	pop    %ebp
801048b9:	c3                   	ret    
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801048c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048c8:	8b 07                	mov    (%edi),%eax
801048ca:	89 04 24             	mov    %eax,(%esp)
801048cd:	e8 7e cc ff ff       	call   80101550 <ialloc>
801048d2:	85 c0                	test   %eax,%eax
801048d4:	89 c6                	mov    %eax,%esi
801048d6:	0f 84 bf 00 00 00    	je     8010499b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801048dc:	89 04 24             	mov    %eax,(%esp)
801048df:	e8 fc cd ff ff       	call   801016e0 <ilock>
  ip->major = major;
801048e4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801048e8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048ec:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048f0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048f4:	b8 01 00 00 00       	mov    $0x1,%eax
801048f9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048fd:	89 34 24             	mov    %esi,(%esp)
80104900:	e8 1b cd ff ff       	call   80101620 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104905:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010490a:	74 34                	je     80104940 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010490c:	8b 46 04             	mov    0x4(%esi),%eax
8010490f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104913:	89 3c 24             	mov    %edi,(%esp)
80104916:	89 44 24 08          	mov    %eax,0x8(%esp)
8010491a:	e8 31 d5 ff ff       	call   80101e50 <dirlink>
8010491f:	85 c0                	test   %eax,%eax
80104921:	78 6c                	js     8010498f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104923:	89 3c 24             	mov    %edi,(%esp)
80104926:	e8 15 d0 ff ff       	call   80101940 <iunlockput>

  return ip;
}
8010492b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010492e:	89 f0                	mov    %esi,%eax
}
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5f                   	pop    %edi
80104933:	5d                   	pop    %ebp
80104934:	c3                   	ret    
80104935:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104938:	31 c0                	xor    %eax,%eax
8010493a:	e9 60 ff ff ff       	jmp    8010489f <create+0x6f>
8010493f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104940:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104945:	89 3c 24             	mov    %edi,(%esp)
80104948:	e8 d3 cc ff ff       	call   80101620 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010494d:	8b 46 04             	mov    0x4(%esi),%eax
80104950:	c7 44 24 04 dc 7e 10 	movl   $0x80107edc,0x4(%esp)
80104957:	80 
80104958:	89 34 24             	mov    %esi,(%esp)
8010495b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010495f:	e8 ec d4 ff ff       	call   80101e50 <dirlink>
80104964:	85 c0                	test   %eax,%eax
80104966:	78 1b                	js     80104983 <create+0x153>
80104968:	8b 47 04             	mov    0x4(%edi),%eax
8010496b:	c7 44 24 04 db 7e 10 	movl   $0x80107edb,0x4(%esp)
80104972:	80 
80104973:	89 34 24             	mov    %esi,(%esp)
80104976:	89 44 24 08          	mov    %eax,0x8(%esp)
8010497a:	e8 d1 d4 ff ff       	call   80101e50 <dirlink>
8010497f:	85 c0                	test   %eax,%eax
80104981:	79 89                	jns    8010490c <create+0xdc>
      panic("create dots");
80104983:	c7 04 24 cf 7e 10 80 	movl   $0x80107ecf,(%esp)
8010498a:	e8 d1 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010498f:	c7 04 24 de 7e 10 80 	movl   $0x80107ede,(%esp)
80104996:	e8 c5 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010499b:	c7 04 24 c0 7e 10 80 	movl   $0x80107ec0,(%esp)
801049a2:	e8 b9 b9 ff ff       	call   80100360 <panic>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	89 c6                	mov    %eax,%esi
801049b6:	53                   	push   %ebx
801049b7:	89 d3                	mov    %edx,%ebx
801049b9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ca:	e8 d1 fc ff ff       	call   801046a0 <argint>
801049cf:	85 c0                	test   %eax,%eax
801049d1:	78 2d                	js     80104a00 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049d3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049d7:	77 27                	ja     80104a00 <argfd.constprop.0+0x50>
801049d9:	e8 f2 ec ff ff       	call   801036d0 <myproc>
801049de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049e1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049e5:	85 c0                	test   %eax,%eax
801049e7:	74 17                	je     80104a00 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801049e9:	85 f6                	test   %esi,%esi
801049eb:	74 02                	je     801049ef <argfd.constprop.0+0x3f>
    *pfd = fd;
801049ed:	89 16                	mov    %edx,(%esi)
  if(pf)
801049ef:	85 db                	test   %ebx,%ebx
801049f1:	74 1d                	je     80104a10 <argfd.constprop.0+0x60>
    *pf = f;
801049f3:	89 03                	mov    %eax,(%ebx)
  return 0;
801049f5:	31 c0                	xor    %eax,%eax
}
801049f7:	83 c4 20             	add    $0x20,%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104a08:	5b                   	pop    %ebx
80104a09:	5e                   	pop    %esi
80104a0a:	5d                   	pop    %ebp
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a10:	31 c0                	xor    %eax,%eax
80104a12:	eb e3                	jmp    801049f7 <argfd.constprop.0+0x47>
80104a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a20 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a20:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a21:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	53                   	push   %ebx
80104a26:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a29:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a2c:	e8 7f ff ff ff       	call   801049b0 <argfd.constprop.0>
80104a31:	85 c0                	test   %eax,%eax
80104a33:	78 23                	js     80104a58 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a38:	e8 b3 fd ff ff       	call   801047f0 <fdalloc>
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	89 c3                	mov    %eax,%ebx
80104a41:	78 15                	js     80104a58 <sys_dup+0x38>
    return -1;
  filedup(f);
80104a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a46:	89 04 24             	mov    %eax,(%esp)
80104a49:	e8 b2 c3 ff ff       	call   80100e00 <filedup>
  return fd;
80104a4e:	89 d8                	mov    %ebx,%eax
}
80104a50:	83 c4 24             	add    $0x24,%esp
80104a53:	5b                   	pop    %ebx
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a5d:	eb f1                	jmp    80104a50 <sys_dup+0x30>
80104a5f:	90                   	nop

80104a60 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104a60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a61:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a6b:	e8 40 ff ff ff       	call   801049b0 <argfd.constprop.0>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 54                	js     80104ac8 <sys_read+0x68>
80104a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a82:	e8 19 fc ff ff       	call   801046a0 <argint>
80104a87:	85 c0                	test   %eax,%eax
80104a89:	78 3d                	js     80104ac8 <sys_read+0x68>
80104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa0:	e8 2b fc ff ff       	call   801046d0 <argptr>
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	78 1f                	js     80104ac8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aba:	89 04 24             	mov    %eax,(%esp)
80104abd:	e8 9e c4 ff ff       	call   80100f60 <fileread>
}
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_write>:

int
sys_write(void)
{
80104ad0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ad1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ad8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104adb:	e8 d0 fe ff ff       	call   801049b0 <argfd.constprop.0>
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	78 54                	js     80104b38 <sys_write+0x68>
80104ae4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104af2:	e8 a9 fb ff ff       	call   801046a0 <argint>
80104af7:	85 c0                	test   %eax,%eax
80104af9:	78 3d                	js     80104b38 <sys_write+0x68>
80104afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b10:	e8 bb fb ff ff       	call   801046d0 <argptr>
80104b15:	85 c0                	test   %eax,%eax
80104b17:	78 1f                	js     80104b38 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b2a:	89 04 24             	mov    %eax,(%esp)
80104b2d:	e8 ce c4 ff ff       	call   80101000 <filewrite>
}
80104b32:	c9                   	leave  
80104b33:	c3                   	ret    
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b3d:	c9                   	leave  
80104b3e:	c3                   	ret    
80104b3f:	90                   	nop

80104b40 <sys_close>:

int
sys_close(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b4c:	e8 5f fe ff ff       	call   801049b0 <argfd.constprop.0>
80104b51:	85 c0                	test   %eax,%eax
80104b53:	78 23                	js     80104b78 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104b55:	e8 76 eb ff ff       	call   801036d0 <myproc>
80104b5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b5d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b64:	00 
  fileclose(f);
80104b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b68:	89 04 24             	mov    %eax,(%esp)
80104b6b:	e8 e0 c2 ff ff       	call   80100e50 <fileclose>
  return 0;
80104b70:	31 c0                	xor    %eax,%eax
}
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <sys_fstat>:

int
sys_fstat(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b8b:	e8 20 fe ff ff       	call   801049b0 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 34                	js     80104bc8 <sys_fstat+0x48>
80104b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b97:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b9e:	00 
80104b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104baa:	e8 21 fb ff ff       	call   801046d0 <argptr>
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	78 15                	js     80104bc8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbd:	89 04 24             	mov    %eax,(%esp)
80104bc0:	e8 4b c3 ff ff       	call   80100f10 <filestat>
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    
80104bcf:	90                   	nop

80104bd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bd9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104be7:	e8 54 fb ff ff       	call   80104740 <argstr>
80104bec:	85 c0                	test   %eax,%eax
80104bee:	0f 88 e6 00 00 00    	js     80104cda <sys_link+0x10a>
80104bf4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c02:	e8 39 fb ff ff       	call   80104740 <argstr>
80104c07:	85 c0                	test   %eax,%eax
80104c09:	0f 88 cb 00 00 00    	js     80104cda <sys_link+0x10a>
    return -1;

  begin_op();
80104c0f:	e8 2c df ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104c14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c17:	89 04 24             	mov    %eax,(%esp)
80104c1a:	e8 11 d3 ff ff       	call   80101f30 <namei>
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	89 c3                	mov    %eax,%ebx
80104c23:	0f 84 ac 00 00 00    	je     80104cd5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c29:	89 04 24             	mov    %eax,(%esp)
80104c2c:	e8 af ca ff ff       	call   801016e0 <ilock>
  if(ip->type == T_DIR){
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	0f 84 91 00 00 00    	je     80104ccd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c41:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c44:	89 1c 24             	mov    %ebx,(%esp)
80104c47:	e8 d4 c9 ff ff       	call   80101620 <iupdate>
  iunlock(ip);
80104c4c:	89 1c 24             	mov    %ebx,(%esp)
80104c4f:	e8 6c cb ff ff       	call   801017c0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c57:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c5b:	89 04 24             	mov    %eax,(%esp)
80104c5e:	e8 ed d2 ff ff       	call   80101f50 <nameiparent>
80104c63:	85 c0                	test   %eax,%eax
80104c65:	89 c6                	mov    %eax,%esi
80104c67:	74 4f                	je     80104cb8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 6f ca ff ff       	call   801016e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c71:	8b 03                	mov    (%ebx),%eax
80104c73:	39 06                	cmp    %eax,(%esi)
80104c75:	75 39                	jne    80104cb0 <sys_link+0xe0>
80104c77:	8b 43 04             	mov    0x4(%ebx),%eax
80104c7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c7e:	89 34 24             	mov    %esi,(%esp)
80104c81:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c85:	e8 c6 d1 ff ff       	call   80101e50 <dirlink>
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 22                	js     80104cb0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c8e:	89 34 24             	mov    %esi,(%esp)
80104c91:	e8 aa cc ff ff       	call   80101940 <iunlockput>
  iput(ip);
80104c96:	89 1c 24             	mov    %ebx,(%esp)
80104c99:	e8 62 cb ff ff       	call   80101800 <iput>

  end_op();
80104c9e:	e8 0d df ff ff       	call   80102bb0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ca3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104ca6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ca8:	5b                   	pop    %ebx
80104ca9:	5e                   	pop    %esi
80104caa:	5f                   	pop    %edi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cb0:	89 34 24             	mov    %esi,(%esp)
80104cb3:	e8 88 cc ff ff       	call   80101940 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104cb8:	89 1c 24             	mov    %ebx,(%esp)
80104cbb:	e8 20 ca ff ff       	call   801016e0 <ilock>
  ip->nlink--;
80104cc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cc5:	89 1c 24             	mov    %ebx,(%esp)
80104cc8:	e8 53 c9 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104ccd:	89 1c 24             	mov    %ebx,(%esp)
80104cd0:	e8 6b cc ff ff       	call   80101940 <iunlockput>
  end_op();
80104cd5:	e8 d6 de ff ff       	call   80102bb0 <end_op>
  return -1;
}
80104cda:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5f                   	pop    %edi
80104ce5:	5d                   	pop    %ebp
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104cf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d07:	e8 34 fa ff ff       	call   80104740 <argstr>
80104d0c:	85 c0                	test   %eax,%eax
80104d0e:	0f 88 76 01 00 00    	js     80104e8a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d14:	e8 27 de ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d19:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d1c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d23:	89 04 24             	mov    %eax,(%esp)
80104d26:	e8 25 d2 ff ff       	call   80101f50 <nameiparent>
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d30:	0f 84 4f 01 00 00    	je     80104e85 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d36:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d39:	89 34 24             	mov    %esi,(%esp)
80104d3c:	e8 9f c9 ff ff       	call   801016e0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d41:	c7 44 24 04 dc 7e 10 	movl   $0x80107edc,0x4(%esp)
80104d48:	80 
80104d49:	89 1c 24             	mov    %ebx,(%esp)
80104d4c:	e8 6f ce ff ff       	call   80101bc0 <namecmp>
80104d51:	85 c0                	test   %eax,%eax
80104d53:	0f 84 21 01 00 00    	je     80104e7a <sys_unlink+0x18a>
80104d59:	c7 44 24 04 db 7e 10 	movl   $0x80107edb,0x4(%esp)
80104d60:	80 
80104d61:	89 1c 24             	mov    %ebx,(%esp)
80104d64:	e8 57 ce ff ff       	call   80101bc0 <namecmp>
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	0f 84 09 01 00 00    	je     80104e7a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d78:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d7c:	89 34 24             	mov    %esi,(%esp)
80104d7f:	e8 6c ce ff ff       	call   80101bf0 <dirlookup>
80104d84:	85 c0                	test   %eax,%eax
80104d86:	89 c3                	mov    %eax,%ebx
80104d88:	0f 84 ec 00 00 00    	je     80104e7a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d8e:	89 04 24             	mov    %eax,(%esp)
80104d91:	e8 4a c9 ff ff       	call   801016e0 <ilock>

  if(ip->nlink < 1)
80104d96:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d9b:	0f 8e 24 01 00 00    	jle    80104ec5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104da1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104da6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104da9:	74 7d                	je     80104e28 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104dab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104db2:	00 
80104db3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dba:	00 
80104dbb:	89 34 24             	mov    %esi,(%esp)
80104dbe:	e8 cd f5 ff ff       	call   80104390 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104dc6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dcd:	00 
80104dce:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd9:	89 04 24             	mov    %eax,(%esp)
80104ddc:	e8 af cc ff ff       	call   80101a90 <writei>
80104de1:	83 f8 10             	cmp    $0x10,%eax
80104de4:	0f 85 cf 00 00 00    	jne    80104eb9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104dea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104def:	0f 84 a3 00 00 00    	je     80104e98 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104df5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104df8:	89 04 24             	mov    %eax,(%esp)
80104dfb:	e8 40 cb ff ff       	call   80101940 <iunlockput>

  ip->nlink--;
80104e00:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e05:	89 1c 24             	mov    %ebx,(%esp)
80104e08:	e8 13 c8 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104e0d:	89 1c 24             	mov    %ebx,(%esp)
80104e10:	e8 2b cb ff ff       	call   80101940 <iunlockput>

  end_op();
80104e15:	e8 96 dd ff ff       	call   80102bb0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e1a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e1d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5f                   	pop    %edi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e28:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e2c:	0f 86 79 ff ff ff    	jbe    80104dab <sys_unlink+0xbb>
80104e32:	bf 20 00 00 00       	mov    $0x20,%edi
80104e37:	eb 15                	jmp    80104e4e <sys_unlink+0x15e>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	8d 57 10             	lea    0x10(%edi),%edx
80104e43:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e46:	0f 83 5f ff ff ff    	jae    80104dab <sys_unlink+0xbb>
80104e4c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e4e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e55:	00 
80104e56:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e5a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e5e:	89 1c 24             	mov    %ebx,(%esp)
80104e61:	e8 2a cb ff ff       	call   80101990 <readi>
80104e66:	83 f8 10             	cmp    $0x10,%eax
80104e69:	75 42                	jne    80104ead <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e6b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e70:	74 ce                	je     80104e40 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e72:	89 1c 24             	mov    %ebx,(%esp)
80104e75:	e8 c6 ca ff ff       	call   80101940 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e7d:	89 04 24             	mov    %eax,(%esp)
80104e80:	e8 bb ca ff ff       	call   80101940 <iunlockput>
  end_op();
80104e85:	e8 26 dd ff ff       	call   80102bb0 <end_op>
  return -1;
}
80104e8a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e92:	5b                   	pop    %ebx
80104e93:	5e                   	pop    %esi
80104e94:	5f                   	pop    %edi
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    
80104e97:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104e98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e9b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104ea0:	89 04 24             	mov    %eax,(%esp)
80104ea3:	e8 78 c7 ff ff       	call   80101620 <iupdate>
80104ea8:	e9 48 ff ff ff       	jmp    80104df5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104ead:	c7 04 24 00 7f 10 80 	movl   $0x80107f00,(%esp)
80104eb4:	e8 a7 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104eb9:	c7 04 24 12 7f 10 80 	movl   $0x80107f12,(%esp)
80104ec0:	e8 9b b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ec5:	c7 04 24 ee 7e 10 80 	movl   $0x80107eee,(%esp)
80104ecc:	e8 8f b4 ff ff       	call   80100360 <panic>
80104ed1:	eb 0d                	jmp    80104ee0 <sys_open>
80104ed3:	90                   	nop
80104ed4:	90                   	nop
80104ed5:	90                   	nop
80104ed6:	90                   	nop
80104ed7:	90                   	nop
80104ed8:	90                   	nop
80104ed9:	90                   	nop
80104eda:	90                   	nop
80104edb:	90                   	nop
80104edc:	90                   	nop
80104edd:	90                   	nop
80104ede:	90                   	nop
80104edf:	90                   	nop

80104ee0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ee9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104eec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef7:	e8 44 f8 ff ff       	call   80104740 <argstr>
80104efc:	85 c0                	test   %eax,%eax
80104efe:	0f 88 d1 00 00 00    	js     80104fd5 <sys_open+0xf5>
80104f04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f12:	e8 89 f7 ff ff       	call   801046a0 <argint>
80104f17:	85 c0                	test   %eax,%eax
80104f19:	0f 88 b6 00 00 00    	js     80104fd5 <sys_open+0xf5>
    return -1;

  begin_op();
80104f1f:	e8 1c dc ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
80104f24:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f28:	0f 85 82 00 00 00    	jne    80104fb0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f31:	89 04 24             	mov    %eax,(%esp)
80104f34:	e8 f7 cf ff ff       	call   80101f30 <namei>
80104f39:	85 c0                	test   %eax,%eax
80104f3b:	89 c6                	mov    %eax,%esi
80104f3d:	0f 84 8d 00 00 00    	je     80104fd0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f43:	89 04 24             	mov    %eax,(%esp)
80104f46:	e8 95 c7 ff ff       	call   801016e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f50:	0f 84 92 00 00 00    	je     80104fe8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f56:	e8 35 be ff ff       	call   80100d90 <filealloc>
80104f5b:	85 c0                	test   %eax,%eax
80104f5d:	89 c3                	mov    %eax,%ebx
80104f5f:	0f 84 93 00 00 00    	je     80104ff8 <sys_open+0x118>
80104f65:	e8 86 f8 ff ff       	call   801047f0 <fdalloc>
80104f6a:	85 c0                	test   %eax,%eax
80104f6c:	89 c7                	mov    %eax,%edi
80104f6e:	0f 88 94 00 00 00    	js     80105008 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f74:	89 34 24             	mov    %esi,(%esp)
80104f77:	e8 44 c8 ff ff       	call   801017c0 <iunlock>
  end_op();
80104f7c:	e8 2f dc ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
80104f81:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104f8a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f8d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104f94:	89 c2                	mov    %eax,%edx
80104f96:	83 e2 01             	and    $0x1,%edx
80104f99:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f9c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f9e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104fa1:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fa3:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104fa7:	83 c4 2c             	add    $0x2c,%esp
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5f                   	pop    %edi
80104fad:	5d                   	pop    %ebp
80104fae:	c3                   	ret    
80104faf:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fb3:	31 c9                	xor    %ecx,%ecx
80104fb5:	ba 02 00 00 00       	mov    $0x2,%edx
80104fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc1:	e8 6a f8 ff ff       	call   80104830 <create>
    if(ip == 0){
80104fc6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fc8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104fca:	75 8a                	jne    80104f56 <sys_open+0x76>
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104fd0:	e8 db db ff ff       	call   80102bb0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fd5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret    
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104feb:	85 c0                	test   %eax,%eax
80104fed:	0f 84 63 ff ff ff    	je     80104f56 <sys_open+0x76>
80104ff3:	90                   	nop
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80104ff8:	89 34 24             	mov    %esi,(%esp)
80104ffb:	e8 40 c9 ff ff       	call   80101940 <iunlockput>
80105000:	eb ce                	jmp    80104fd0 <sys_open+0xf0>
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105008:	89 1c 24             	mov    %ebx,(%esp)
8010500b:	e8 40 be ff ff       	call   80100e50 <fileclose>
80105010:	eb e6                	jmp    80104ff8 <sys_open+0x118>
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105026:	e8 15 db ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010502b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010502e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105032:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105039:	e8 02 f7 ff ff       	call   80104740 <argstr>
8010503e:	85 c0                	test   %eax,%eax
80105040:	78 2e                	js     80105070 <sys_mkdir+0x50>
80105042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105045:	31 c9                	xor    %ecx,%ecx
80105047:	ba 01 00 00 00       	mov    $0x1,%edx
8010504c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105053:	e8 d8 f7 ff ff       	call   80104830 <create>
80105058:	85 c0                	test   %eax,%eax
8010505a:	74 14                	je     80105070 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010505c:	89 04 24             	mov    %eax,(%esp)
8010505f:	e8 dc c8 ff ff       	call   80101940 <iunlockput>
  end_op();
80105064:	e8 47 db ff ff       	call   80102bb0 <end_op>
  return 0;
80105069:	31 c0                	xor    %eax,%eax
}
8010506b:	c9                   	leave  
8010506c:	c3                   	ret    
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105070:	e8 3b db ff ff       	call   80102bb0 <end_op>
    return -1;
80105075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_mknod>:

int
sys_mknod(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105086:	e8 b5 da ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010508b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010508e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105099:	e8 a2 f6 ff ff       	call   80104740 <argstr>
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 5e                	js     80105100 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050b0:	e8 eb f5 ff ff       	call   801046a0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 47                	js     80105100 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050c7:	e8 d4 f5 ff ff       	call   801046a0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050cc:	85 c0                	test   %eax,%eax
801050ce:	78 30                	js     80105100 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050d0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050d4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050d9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050dd:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050e3:	e8 48 f7 ff ff       	call   80104830 <create>
801050e8:	85 c0                	test   %eax,%eax
801050ea:	74 14                	je     80105100 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050ec:	89 04 24             	mov    %eax,(%esp)
801050ef:	e8 4c c8 ff ff       	call   80101940 <iunlockput>
  end_op();
801050f4:	e8 b7 da ff ff       	call   80102bb0 <end_op>
  return 0;
801050f9:	31 c0                	xor    %eax,%eax
}
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105100:	e8 ab da ff ff       	call   80102bb0 <end_op>
    return -1;
80105105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_chdir>:

int
sys_chdir(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105118:	e8 b3 e5 ff ff       	call   801036d0 <myproc>
8010511d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010511f:	e8 1c da ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105124:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105127:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105132:	e8 09 f6 ff ff       	call   80104740 <argstr>
80105137:	85 c0                	test   %eax,%eax
80105139:	78 4a                	js     80105185 <sys_chdir+0x75>
8010513b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513e:	89 04 24             	mov    %eax,(%esp)
80105141:	e8 ea cd ff ff       	call   80101f30 <namei>
80105146:	85 c0                	test   %eax,%eax
80105148:	89 c3                	mov    %eax,%ebx
8010514a:	74 39                	je     80105185 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010514c:	89 04 24             	mov    %eax,(%esp)
8010514f:	e8 8c c5 ff ff       	call   801016e0 <ilock>
  if(ip->type != T_DIR){
80105154:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105159:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010515c:	75 22                	jne    80105180 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010515e:	e8 5d c6 ff ff       	call   801017c0 <iunlock>
  iput(curproc->cwd);
80105163:	8b 46 68             	mov    0x68(%esi),%eax
80105166:	89 04 24             	mov    %eax,(%esp)
80105169:	e8 92 c6 ff ff       	call   80101800 <iput>
  end_op();
8010516e:	e8 3d da ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
  return 0;
80105173:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105175:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105178:	83 c4 20             	add    $0x20,%esp
8010517b:	5b                   	pop    %ebx
8010517c:	5e                   	pop    %esi
8010517d:	5d                   	pop    %ebp
8010517e:	c3                   	ret    
8010517f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105180:	e8 bb c7 ff ff       	call   80101940 <iunlockput>
    end_op();
80105185:	e8 26 da ff ff       	call   80102bb0 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010518a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105192:	5b                   	pop    %ebx
80105193:	5e                   	pop    %esi
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    
80105196:	8d 76 00             	lea    0x0(%esi),%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_exec>:

int
sys_exec(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
801051a6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051ac:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051bd:	e8 7e f5 ff ff       	call   80104740 <argstr>
801051c2:	85 c0                	test   %eax,%eax
801051c4:	0f 88 84 00 00 00    	js     8010524e <sys_exec+0xae>
801051ca:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051db:	e8 c0 f4 ff ff       	call   801046a0 <argint>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 6a                	js     8010524e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051ea:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051ec:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051f3:	00 
801051f4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105201:	00 
80105202:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105208:	89 04 24             	mov    %eax,(%esp)
8010520b:	e8 80 f1 ff ff       	call   80104390 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105210:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105216:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010521a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010521d:	89 04 24             	mov    %eax,(%esp)
80105220:	e8 bb f3 ff ff       	call   801045e0 <fetchint>
80105225:	85 c0                	test   %eax,%eax
80105227:	78 25                	js     8010524e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105229:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010522f:	85 c0                	test   %eax,%eax
80105231:	74 2d                	je     80105260 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105233:	89 74 24 04          	mov    %esi,0x4(%esp)
80105237:	89 04 24             	mov    %eax,(%esp)
8010523a:	e8 f1 f3 ff ff       	call   80104630 <fetchstr>
8010523f:	85 c0                	test   %eax,%eax
80105241:	78 0b                	js     8010524e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105243:	83 c3 01             	add    $0x1,%ebx
80105246:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105249:	83 fb 20             	cmp    $0x20,%ebx
8010524c:	75 c2                	jne    80105210 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010524e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105254:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105259:	5b                   	pop    %ebx
8010525a:	5e                   	pop    %esi
8010525b:	5f                   	pop    %edi
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105260:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105266:	89 44 24 04          	mov    %eax,0x4(%esp)
8010526a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105270:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105277:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010527b:	89 04 24             	mov    %eax,(%esp)
8010527e:	e8 1d b7 ff ff       	call   801009a0 <exec>
}
80105283:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105289:	5b                   	pop    %ebx
8010528a:	5e                   	pop    %esi
8010528b:	5f                   	pop    %edi
8010528c:	5d                   	pop    %ebp
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax

80105290 <sys_pipe>:

int
sys_pipe(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	53                   	push   %ebx
80105294:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105297:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010529a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801052a1:	00 
801052a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801052a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052ad:	e8 1e f4 ff ff       	call   801046d0 <argptr>
801052b2:	85 c0                	test   %eax,%eax
801052b4:	78 6d                	js     80105323 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c0:	89 04 24             	mov    %eax,(%esp)
801052c3:	e8 d8 de ff ff       	call   801031a0 <pipealloc>
801052c8:	85 c0                	test   %eax,%eax
801052ca:	78 57                	js     80105323 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cf:	e8 1c f5 ff ff       	call   801047f0 <fdalloc>
801052d4:	85 c0                	test   %eax,%eax
801052d6:	89 c3                	mov    %eax,%ebx
801052d8:	78 33                	js     8010530d <sys_pipe+0x7d>
801052da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052dd:	e8 0e f5 ff ff       	call   801047f0 <fdalloc>
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 1a                	js     80105300 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052e9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801052eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052ee:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801052f1:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801052f4:	31 c0                	xor    %eax,%eax
}
801052f6:	5b                   	pop    %ebx
801052f7:	5d                   	pop    %ebp
801052f8:	c3                   	ret    
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105300:	e8 cb e3 ff ff       	call   801036d0 <myproc>
80105305:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010530c:	00 
    fileclose(rf);
8010530d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105310:	89 04 24             	mov    %eax,(%esp)
80105313:	e8 38 bb ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531b:	89 04 24             	mov    %eax,(%esp)
8010531e:	e8 2d bb ff ff       	call   80100e50 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105323:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010532b:	5b                   	pop    %ebx
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret    
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105336:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105339:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105344:	e8 57 f3 ff ff       	call   801046a0 <argint>
80105349:	85 c0                	test   %eax,%eax
8010534b:	78 33                	js     80105380 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010534d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105350:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105357:	00 
80105358:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105363:	e8 68 f3 ff ff       	call   801046d0 <argptr>
80105368:	85 c0                	test   %eax,%eax
8010536a:	78 14                	js     80105380 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010536c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105376:	89 04 24             	mov    %eax,(%esp)
80105379:	e8 72 20 00 00       	call   801073f0 <shm_open>
}
8010537e:	c9                   	leave  
8010537f:	c3                   	ret    
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_shm_close>:

int sys_shm_close(void) {
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105396:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105399:	89 44 24 04          	mov    %eax,0x4(%esp)
8010539d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a4:	e8 f7 f2 ff ff       	call   801046a0 <argint>
801053a9:	85 c0                	test   %eax,%eax
801053ab:	78 13                	js     801053c0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801053ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b0:	89 04 24             	mov    %eax,(%esp)
801053b3:	e8 e8 21 00 00       	call   801075a0 <shm_close>
}
801053b8:	c9                   	leave  
801053b9:	c3                   	ret    
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_fork>:

int
sys_fork(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801053d3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
801053d4:	e9 47 e5 ff ff       	jmp    80103920 <fork>
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_exit>:
}

int
sys_exit(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053e6:	e8 95 e7 ff ff       	call   80103b80 <exit>
  return 0;  // not reached
}
801053eb:	31 c0                	xor    %eax,%eax
801053ed:	c9                   	leave  
801053ee:	c3                   	ret    
801053ef:	90                   	nop

801053f0 <sys_wait>:

int
sys_wait(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801053f3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801053f4:	e9 a7 e9 ff ff       	jmp    80103da0 <wait>
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_kill>:
}

int
sys_kill(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105406:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010540d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105414:	e8 87 f2 ff ff       	call   801046a0 <argint>
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 13                	js     80105430 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010541d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105420:	89 04 24             	mov    %eax,(%esp)
80105423:	e8 d8 ea ff ff       	call   80103f00 <kill>
}
80105428:	c9                   	leave  
80105429:	c3                   	ret    
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_getpid>:

int
sys_getpid(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105446:	e8 85 e2 ff ff       	call   801036d0 <myproc>
8010544b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010544e:	c9                   	leave  
8010544f:	c3                   	ret    

80105450 <sys_sbrk>:

int
sys_sbrk(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105457:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010545e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105465:	e8 36 f2 ff ff       	call   801046a0 <argint>
8010546a:	85 c0                	test   %eax,%eax
8010546c:	78 22                	js     80105490 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010546e:	e8 5d e2 ff ff       	call   801036d0 <myproc>
  if(growproc(n) < 0)
80105473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105476:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105478:	89 14 24             	mov    %edx,(%esp)
8010547b:	e8 e0 e3 ff ff       	call   80103860 <growproc>
80105480:	85 c0                	test   %eax,%eax
80105482:	78 0c                	js     80105490 <sys_sbrk+0x40>
    return -1;
  return addr;
80105484:	89 d8                	mov    %ebx,%eax
}
80105486:	83 c4 24             	add    $0x24,%esp
80105489:	5b                   	pop    %ebx
8010548a:	5d                   	pop    %ebp
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105495:	eb ef                	jmp    80105486 <sys_sbrk+0x36>
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801054a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054b5:	e8 e6 f1 ff ff       	call   801046a0 <argint>
801054ba:	85 c0                	test   %eax,%eax
801054bc:	78 7e                	js     8010553c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801054be:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801054c5:	e8 86 ed ff ff       	call   80104250 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801054cd:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while(ticks - ticks0 < n){
801054d3:	85 d2                	test   %edx,%edx
801054d5:	75 29                	jne    80105500 <sys_sleep+0x60>
801054d7:	eb 4f                	jmp    80105528 <sys_sleep+0x88>
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054e0:	c7 44 24 04 60 65 11 	movl   $0x80116560,0x4(%esp)
801054e7:	80 
801054e8:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
801054ef:	e8 fc e7 ff ff       	call   80103cf0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054f4:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
801054f9:	29 d8                	sub    %ebx,%eax
801054fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054fe:	73 28                	jae    80105528 <sys_sleep+0x88>
    if(myproc()->killed){
80105500:	e8 cb e1 ff ff       	call   801036d0 <myproc>
80105505:	8b 40 24             	mov    0x24(%eax),%eax
80105508:	85 c0                	test   %eax,%eax
8010550a:	74 d4                	je     801054e0 <sys_sleep+0x40>
      release(&tickslock);
8010550c:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105513:	e8 28 ee ff ff       	call   80104340 <release>
      return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010551d:	83 c4 24             	add    $0x24,%esp
80105520:	5b                   	pop    %ebx
80105521:	5d                   	pop    %ebp
80105522:	c3                   	ret    
80105523:	90                   	nop
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105528:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010552f:	e8 0c ee ff ff       	call   80104340 <release>
  return 0;
}
80105534:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105537:	31 c0                	xor    %eax,%eax
}
80105539:	5b                   	pop    %ebx
8010553a:	5d                   	pop    %ebp
8010553b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010553c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105541:	eb da                	jmp    8010551d <sys_sleep+0x7d>
80105543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	53                   	push   %ebx
80105554:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105557:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010555e:	e8 ed ec ff ff       	call   80104250 <acquire>
  xticks = ticks;
80105563:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
80105569:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105570:	e8 cb ed ff ff       	call   80104340 <release>
  return xticks;
}
80105575:	83 c4 14             	add    $0x14,%esp
80105578:	89 d8                	mov    %ebx,%eax
8010557a:	5b                   	pop    %ebx
8010557b:	5d                   	pop    %ebp
8010557c:	c3                   	ret    

8010557d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010557d:	1e                   	push   %ds
  pushl %es
8010557e:	06                   	push   %es
  pushl %fs
8010557f:	0f a0                	push   %fs
  pushl %gs
80105581:	0f a8                	push   %gs
  pushal
80105583:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105584:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105588:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010558a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010558c:	54                   	push   %esp
  call trap
8010558d:	e8 de 00 00 00       	call   80105670 <trap>
  addl $4, %esp
80105592:	83 c4 04             	add    $0x4,%esp

80105595 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105595:	61                   	popa   
  popl %gs
80105596:	0f a9                	pop    %gs
  popl %fs
80105598:	0f a1                	pop    %fs
  popl %es
8010559a:	07                   	pop    %es
  popl %ds
8010559b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010559c:	83 c4 08             	add    $0x8,%esp
  iret
8010559f:	cf                   	iret   

801055a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055a0:	31 c0                	xor    %eax,%eax
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801055a8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801055af:	b9 08 00 00 00       	mov    $0x8,%ecx
801055b4:	66 89 0c c5 a2 65 11 	mov    %cx,-0x7fee9a5e(,%eax,8)
801055bb:	80 
801055bc:	c6 04 c5 a4 65 11 80 	movb   $0x0,-0x7fee9a5c(,%eax,8)
801055c3:	00 
801055c4:	c6 04 c5 a5 65 11 80 	movb   $0x8e,-0x7fee9a5b(,%eax,8)
801055cb:	8e 
801055cc:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
801055d3:	80 
801055d4:	c1 ea 10             	shr    $0x10,%edx
801055d7:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
801055de:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055df:	83 c0 01             	add    $0x1,%eax
801055e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801055e7:	75 bf                	jne    801055a8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055e9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055ea:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055ef:	89 e5                	mov    %esp,%ebp
801055f1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055f4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801055f9:	c7 44 24 04 21 7f 10 	movl   $0x80107f21,0x4(%esp)
80105600:	80 
80105601:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105608:	66 89 15 a2 67 11 80 	mov    %dx,0x801167a2
8010560f:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
80105615:	c1 e8 10             	shr    $0x10,%eax
80105618:	c6 05 a4 67 11 80 00 	movb   $0x0,0x801167a4
8010561f:	c6 05 a5 67 11 80 ef 	movb   $0xef,0x801167a5
80105626:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6

  initlock(&tickslock, "time");
8010562c:	e8 2f eb ff ff       	call   80104160 <initlock>
}
80105631:	c9                   	leave  
80105632:	c3                   	ret    
80105633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <idtinit>:



void
idtinit(void)
{
80105640:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105641:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105646:	89 e5                	mov    %esp,%ebp
80105648:	83 ec 10             	sub    $0x10,%esp
8010564b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010564f:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
80105654:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105658:	c1 e8 10             	shr    $0x10,%eax
8010565b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010565f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105662:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	53                   	push   %ebx
80105676:	83 ec 4c             	sub    $0x4c,%esp
80105679:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
8010567c:	e8 4f e0 ff ff       	call   801036d0 <myproc>
80105681:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
80105683:	8b 43 30             	mov    0x30(%ebx),%eax
80105686:	83 f8 40             	cmp    $0x40,%eax
80105689:	0f 84 09 02 00 00    	je     80105898 <trap+0x228>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010568f:	83 e8 0e             	sub    $0xe,%eax
80105692:	83 f8 31             	cmp    $0x31,%eax
80105695:	77 09                	ja     801056a0 <trap+0x30>
80105697:	ff 24 85 00 81 10 80 	jmp    *-0x7fef7f00(,%eax,4)
8010569e:	66 90                	xchg   %ax,%ax
			break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801056a0:	e8 2b e0 ff ff       	call   801036d0 <myproc>
801056a5:	85 c0                	test   %eax,%eax
801056a7:	0f 84 7c 03 00 00    	je     80105a29 <trap+0x3b9>
801056ad:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056b1:	0f 84 72 03 00 00    	je     80105a29 <trap+0x3b9>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801056b7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056ba:	8b 53 38             	mov    0x38(%ebx),%edx
801056bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801056c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801056c3:	e8 e8 df ff ff       	call   801036b0 <cpuid>
801056c8:	8b 73 30             	mov    0x30(%ebx),%esi
801056cb:	89 c7                	mov    %eax,%edi
801056cd:	8b 43 34             	mov    0x34(%ebx),%eax
801056d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056d3:	e8 f8 df ff ff       	call   801036d0 <myproc>
801056d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801056db:	e8 f0 df ff ff       	call   801036d0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056e0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801056e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
801056ed:	89 7c 24 14          	mov    %edi,0x14(%esp)
801056f1:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801056f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056f8:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056fb:	89 54 24 18          	mov    %edx,0x18(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056ff:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105703:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105707:	8b 40 10             	mov    0x10(%eax),%eax
8010570a:	c7 04 24 bc 80 10 80 	movl   $0x801080bc,(%esp)
80105711:	89 44 24 04          	mov    %eax,0x4(%esp)
80105715:	e8 36 af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010571a:	e8 b1 df ff ff       	call   801036d0 <myproc>
8010571f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105726:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105728:	e8 a3 df ff ff       	call   801036d0 <myproc>
8010572d:	85 c0                	test   %eax,%eax
8010572f:	74 0c                	je     8010573d <trap+0xcd>
80105731:	e8 9a df ff ff       	call   801036d0 <myproc>
80105736:	8b 50 24             	mov    0x24(%eax),%edx
80105739:	85 d2                	test   %edx,%edx
8010573b:	75 4b                	jne    80105788 <trap+0x118>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010573d:	e8 8e df ff ff       	call   801036d0 <myproc>
80105742:	85 c0                	test   %eax,%eax
80105744:	74 0c                	je     80105752 <trap+0xe2>
80105746:	e8 85 df ff ff       	call   801036d0 <myproc>
8010574b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010574f:	90                   	nop
80105750:	74 4e                	je     801057a0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105752:	e8 79 df ff ff       	call   801036d0 <myproc>
80105757:	85 c0                	test   %eax,%eax
80105759:	74 22                	je     8010577d <trap+0x10d>
8010575b:	90                   	nop
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105760:	e8 6b df ff ff       	call   801036d0 <myproc>
80105765:	8b 40 24             	mov    0x24(%eax),%eax
80105768:	85 c0                	test   %eax,%eax
8010576a:	74 11                	je     8010577d <trap+0x10d>
8010576c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105770:	83 e0 03             	and    $0x3,%eax
80105773:	66 83 f8 03          	cmp    $0x3,%ax
80105777:	0f 84 4c 01 00 00    	je     801058c9 <trap+0x259>
    exit();
}
8010577d:	83 c4 4c             	add    $0x4c,%esp
80105780:	5b                   	pop    %ebx
80105781:	5e                   	pop    %esi
80105782:	5f                   	pop    %edi
80105783:	5d                   	pop    %ebp
80105784:	c3                   	ret    
80105785:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105788:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010578c:	83 e0 03             	and    $0x3,%eax
8010578f:	66 83 f8 03          	cmp    $0x3,%ax
80105793:	75 a8                	jne    8010573d <trap+0xcd>
    exit();
80105795:	e8 e6 e3 ff ff       	call   80103b80 <exit>
8010579a:	eb a1                	jmp    8010573d <trap+0xcd>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057a4:	75 ac                	jne    80105752 <trap+0xe2>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801057a6:	e8 05 e5 ff ff       	call   80103cb0 <yield>
801057ab:	eb a5                	jmp    80105752 <trap+0xe2>
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
801057b0:	85 f6                	test   %esi,%esi
801057b2:	0f 84 e8 fe ff ff    	je     801056a0 <trap+0x30>
801057b8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057bc:	83 e0 03             	and    $0x3,%eax
801057bf:	66 83 f8 03          	cmp    $0x3,%ax
801057c3:	0f 84 47 01 00 00    	je     80105910 <trap+0x2a0>
801057c9:	0f 20 d2             	mov    %cr2,%edx
801057cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
			break;
		}else if (curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
801057cf:	8b 7b 38             	mov    0x38(%ebx),%edi
801057d2:	e8 d9 de ff ff       	call   801036b0 <cpuid>
801057d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801057da:	89 7c 24 18          	mov    %edi,0x18(%esp)
801057de:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801057e2:	89 44 24 14          	mov    %eax,0x14(%esp)
801057e6:	8b 43 34             	mov    0x34(%ebx),%eax
801057e9:	89 44 24 10          	mov    %eax,0x10(%esp)
801057ed:	8b 43 30             	mov    0x30(%ebx),%eax
801057f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
801057f4:	8d 46 6c             	lea    0x6c(%esi),%eax
801057f7:	89 44 24 08          	mov    %eax,0x8(%esp)
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
			break;
		}else if (curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
801057fb:	8b 46 10             	mov    0x10(%esi),%eax
801057fe:	c7 04 24 28 80 10 80 	movl   $0x80108028,(%esp)
80105805:	89 44 24 04          	mov    %eax,0x4(%esp)
80105809:	e8 42 ae ff ff       	call   80100650 <cprintf>
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
						  rcr2());                                          
			curproc->killed = 1;
8010580e:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105815:	e9 0e ff ff ff       	jmp    80105728 <trap+0xb8>
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105820:	e8 8b de ff ff       	call   801036b0 <cpuid>
80105825:	85 c0                	test   %eax,%eax
80105827:	0f 84 b3 00 00 00    	je     801058e0 <trap+0x270>
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105830:	e8 7b cf ff ff       	call   801027b0 <lapiceoi>
    break;
80105835:	e9 ee fe ff ff       	jmp    80105728 <trap+0xb8>
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105840:	e8 bb cd ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105845:	e8 66 cf ff ff       	call   801027b0 <lapiceoi>
    break;
8010584a:	e9 d9 fe ff ff       	jmp    80105728 <trap+0xb8>
8010584f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105850:	e8 2b 03 00 00       	call   80105b80 <uartintr>
    lapiceoi();
80105855:	e8 56 cf ff ff       	call   801027b0 <lapiceoi>
    break;
8010585a:	e9 c9 fe ff ff       	jmp    80105728 <trap+0xb8>
8010585f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105860:	8b 7b 38             	mov    0x38(%ebx),%edi
80105863:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105867:	e8 44 de ff ff       	call   801036b0 <cpuid>
8010586c:	c7 04 24 2c 7f 10 80 	movl   $0x80107f2c,(%esp)
80105873:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105877:	89 74 24 08          	mov    %esi,0x8(%esp)
8010587b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010587f:	e8 cc ad ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105884:	e8 27 cf ff ff       	call   801027b0 <lapiceoi>
    break;
80105889:	e9 9a fe ff ff       	jmp    80105728 <trap+0xb8>
8010588e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105890:	e8 1b c8 ff ff       	call   801020b0 <ideintr>
80105895:	eb 96                	jmp    8010582d <trap+0x1bd>
80105897:	90                   	nop
80105898:	90                   	nop
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801058a0:	e8 2b de ff ff       	call   801036d0 <myproc>
801058a5:	8b 70 24             	mov    0x24(%eax),%esi
801058a8:	85 f6                	test   %esi,%esi
801058aa:	75 2c                	jne    801058d8 <trap+0x268>
      exit();
    myproc()->tf = tf;
801058ac:	e8 1f de ff ff       	call   801036d0 <myproc>
801058b1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801058b4:	e8 c7 ee ff ff       	call   80104780 <syscall>
    if(myproc()->killed)
801058b9:	e8 12 de ff ff       	call   801036d0 <myproc>
801058be:	8b 48 24             	mov    0x24(%eax),%ecx
801058c1:	85 c9                	test   %ecx,%ecx
801058c3:	0f 84 b4 fe ff ff    	je     8010577d <trap+0x10d>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801058c9:	83 c4 4c             	add    $0x4c,%esp
801058cc:	5b                   	pop    %ebx
801058cd:	5e                   	pop    %esi
801058ce:	5f                   	pop    %edi
801058cf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801058d0:	e9 ab e2 ff ff       	jmp    80103b80 <exit>
801058d5:	8d 76 00             	lea    0x0(%esi),%esi
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801058d8:	e8 a3 e2 ff ff       	call   80103b80 <exit>
801058dd:	eb cd                	jmp    801058ac <trap+0x23c>
801058df:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801058e0:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801058e7:	e8 64 e9 ff ff       	call   80104250 <acquire>
      ticks++;
      wakeup(&ticks);
801058ec:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801058f3:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
801058fa:	e8 91 e5 ff ff       	call   80103e90 <wakeup>
      release(&tickslock);
801058ff:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105906:	e8 35 ea ff ff       	call   80104340 <release>
8010590b:	e9 1d ff ff ff       	jmp    8010582d <trap+0x1bd>
    lapiceoi();
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
			if(curproc->tf->esp < curproc->tstack){ // Check to see if stack size matches esp and if it doesn't it makes it the same
80105910:	8b 46 18             	mov    0x18(%esi),%eax
80105913:	8b 56 7c             	mov    0x7c(%esi),%edx
80105916:	8b 40 44             	mov    0x44(%eax),%eax
80105919:	39 d0                	cmp    %edx,%eax
8010591b:	0f 83 95 00 00 00    	jae    801059b6 <trap+0x346>
				uint rep = ((curproc->tstack - curproc->tf->esp)/PGSIZE)+1;
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
80105921:	8b 0e                	mov    (%esi),%ecx
80105923:	8d b9 00 20 00 00    	lea    0x2000(%ecx),%edi
80105929:	39 f8                	cmp    %edi,%eax
8010592b:	73 2b                	jae    80105958 <trap+0x2e8>
8010592d:	0f 20 d7             	mov    %cr2,%edi
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105930:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105934:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105938:	89 54 24 08          	mov    %edx,0x8(%esp)
8010593c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105940:	c7 04 24 50 7f 10 80 	movl   $0x80107f50,(%esp)
80105947:	e8 04 ad ff ff       	call   80100650 <cprintf>
					curproc->killed = 1;
8010594c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
					break;
80105953:	e9 d0 fd ff ff       	jmp    80105728 <trap+0xb8>
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
			if(curproc->tf->esp < curproc->tstack){ // Check to see if stack size matches esp and if it doesn't it makes it the same
				uint rep = ((curproc->tstack - curproc->tf->esp)/PGSIZE)+1;
80105958:	89 d7                	mov    %edx,%edi
8010595a:	29 c7                	sub    %eax,%edi
8010595c:	89 f8                	mov    %edi,%eax
8010595e:	c1 e8 0c             	shr    $0xc,%eax
80105961:	83 c0 01             	add    $0x1,%eax
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
					curproc->killed = 1;
					break;
				}
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
80105964:	89 44 24 08          	mov    %eax,0x8(%esp)
80105968:	89 54 24 04          	mov    %edx,0x4(%esp)
8010596c:	8b 46 04             	mov    0x4(%esi),%eax
8010596f:	89 04 24             	mov    %eax,(%esp)
80105972:	e8 39 18 00 00       	call   801071b0 <addstackpage>
80105977:	83 f8 01             	cmp    $0x1,%eax
8010597a:	0f 84 a8 fd ff ff    	je     80105728 <trap+0xb8>
80105980:	0f 20 d0             	mov    %cr2,%eax
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105983:	89 44 24 10          	mov    %eax,0x10(%esp)
80105987:	8b 06                	mov    (%esi),%eax
80105989:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010598d:	8b 46 7c             	mov    0x7c(%esi),%eax
80105990:	89 44 24 08          	mov    %eax,0x8(%esp)
80105994:	8b 46 18             	mov    0x18(%esi),%eax
80105997:	8b 40 44             	mov    0x44(%eax),%eax
8010599a:	c7 04 24 8c 7f 10 80 	movl   $0x80107f8c,(%esp)
801059a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801059a5:	e8 a6 ac ff ff       	call   80100650 <cprintf>
				curproc->killed = 1;
801059aa:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
				break;
801059b1:	e9 72 fd ff ff       	jmp    80105728 <trap+0xb8>
801059b6:	0f 20 d1             	mov    %cr2,%ecx
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059b9:	8b 53 38             	mov    0x38(%ebx),%edx
801059bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
801059bf:	89 55 d8             	mov    %edx,-0x28(%ebp)
801059c2:	e8 e9 dc ff ff       	call   801036b0 <cpuid>
801059c7:	8b 7b 34             	mov    0x34(%ebx),%edi
801059ca:	89 7d e0             	mov    %edi,-0x20(%ebp)
801059cd:	8b 7b 30             	mov    0x30(%ebx),%edi
801059d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059d3:	e8 f8 dc ff ff       	call   801036d0 <myproc>
801059d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059db:	e8 f0 dc ff ff       	call   801036d0 <myproc>
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059e0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
801059e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
801059e6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059ea:	8b 7d dc             	mov    -0x24(%ebp),%edi
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059ed:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801059f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059f4:	89 54 24 18          	mov    %edx,0x18(%esp)
801059f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059fb:	83 c7 6c             	add    $0x6c,%edi
801059fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
80105a02:	89 4c 24 14          	mov    %ecx,0x14(%esp)
80105a06:	89 54 24 10          	mov    %edx,0x10(%esp)
80105a0a:	8b 40 10             	mov    0x10(%eax),%eax
80105a0d:	c7 04 24 c8 7f 10 80 	movl   $0x80107fc8,(%esp)
80105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a18:	e8 33 ac ff ff       	call   80100650 <cprintf>
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
80105a1d:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105a24:	e9 ff fc ff ff       	jmp    80105728 <trap+0xb8>
80105a29:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a2c:	8b 73 38             	mov    0x38(%ebx),%esi
80105a2f:	e8 7c dc ff ff       	call   801036b0 <cpuid>
80105a34:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105a38:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a40:	8b 43 30             	mov    0x30(%ebx),%eax
80105a43:	c7 04 24 88 80 10 80 	movl   $0x80108088,(%esp)
80105a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a4e:	e8 fd ab ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105a53:	c7 04 24 26 7f 10 80 	movl   $0x80107f26,(%esp)
80105a5a:	e8 01 a9 ff ff       	call   80100360 <panic>
80105a5f:	90                   	nop

80105a60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a60:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a65:	55                   	push   %ebp
80105a66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	74 14                	je     80105a80 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a72:	a8 01                	test   $0x1,%al
80105a74:	74 0a                	je     80105a80 <uartgetc+0x20>
80105a76:	b2 f8                	mov    $0xf8,%dl
80105a78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a79:	0f b6 c0             	movzbl %al,%eax
}
80105a7c:	5d                   	pop    %ebp
80105a7d:	c3                   	ret    
80105a7e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a85:	5d                   	pop    %ebp
80105a86:	c3                   	ret    
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105a90:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105a95:	85 c0                	test   %eax,%eax
80105a97:	74 3f                	je     80105ad8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105a99:	55                   	push   %ebp
80105a9a:	89 e5                	mov    %esp,%ebp
80105a9c:	56                   	push   %esi
80105a9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105aa2:	53                   	push   %ebx
  int i;

  if(!uart)
80105aa3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105aa8:	83 ec 10             	sub    $0x10,%esp
80105aab:	eb 14                	jmp    80105ac1 <uartputc+0x31>
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ab0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105ab7:	e8 14 cd ff ff       	call   801027d0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105abc:	83 eb 01             	sub    $0x1,%ebx
80105abf:	74 07                	je     80105ac8 <uartputc+0x38>
80105ac1:	89 f2                	mov    %esi,%edx
80105ac3:	ec                   	in     (%dx),%al
80105ac4:	a8 20                	test   $0x20,%al
80105ac6:	74 e8                	je     80105ab0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105ac8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105acc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ad1:	ee                   	out    %al,(%dx)
}
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	5b                   	pop    %ebx
80105ad6:	5e                   	pop    %esi
80105ad7:	5d                   	pop    %ebp
80105ad8:	f3 c3                	repz ret 
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ae0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	31 c9                	xor    %ecx,%ecx
80105ae3:	89 e5                	mov    %esp,%ebp
80105ae5:	89 c8                	mov    %ecx,%eax
80105ae7:	57                   	push   %edi
80105ae8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105aed:	56                   	push   %esi
80105aee:	89 fa                	mov    %edi,%edx
80105af0:	53                   	push   %ebx
80105af1:	83 ec 1c             	sub    $0x1c,%esp
80105af4:	ee                   	out    %al,(%dx)
80105af5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105afa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105aff:	89 f2                	mov    %esi,%edx
80105b01:	ee                   	out    %al,(%dx)
80105b02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b07:	b2 f8                	mov    $0xf8,%dl
80105b09:	ee                   	out    %al,(%dx)
80105b0a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105b0f:	89 c8                	mov    %ecx,%eax
80105b11:	89 da                	mov    %ebx,%edx
80105b13:	ee                   	out    %al,(%dx)
80105b14:	b8 03 00 00 00       	mov    $0x3,%eax
80105b19:	89 f2                	mov    %esi,%edx
80105b1b:	ee                   	out    %al,(%dx)
80105b1c:	b2 fc                	mov    $0xfc,%dl
80105b1e:	89 c8                	mov    %ecx,%eax
80105b20:	ee                   	out    %al,(%dx)
80105b21:	b8 01 00 00 00       	mov    $0x1,%eax
80105b26:	89 da                	mov    %ebx,%edx
80105b28:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b29:	b2 fd                	mov    $0xfd,%dl
80105b2b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b2c:	3c ff                	cmp    $0xff,%al
80105b2e:	74 42                	je     80105b72 <uartinit+0x92>
    return;
  uart = 1;
80105b30:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105b37:	00 00 00 
80105b3a:	89 fa                	mov    %edi,%edx
80105b3c:	ec                   	in     (%dx),%al
80105b3d:	b2 f8                	mov    $0xf8,%dl
80105b3f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b47:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b48:	bb c8 81 10 80       	mov    $0x801081c8,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b4d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105b54:	e8 87 c7 ff ff       	call   801022e0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b59:	b8 78 00 00 00       	mov    $0x78,%eax
80105b5e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105b60:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b63:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105b66:	e8 25 ff ff ff       	call   80105a90 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b6b:	0f be 03             	movsbl (%ebx),%eax
80105b6e:	84 c0                	test   %al,%al
80105b70:	75 ee                	jne    80105b60 <uartinit+0x80>
    uartputc(*p);
}
80105b72:	83 c4 1c             	add    $0x1c,%esp
80105b75:	5b                   	pop    %ebx
80105b76:	5e                   	pop    %esi
80105b77:	5f                   	pop    %edi
80105b78:	5d                   	pop    %ebp
80105b79:	c3                   	ret    
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b80 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105b86:	c7 04 24 60 5a 10 80 	movl   $0x80105a60,(%esp)
80105b8d:	e8 1e ac ff ff       	call   801007b0 <consoleintr>
}
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    

80105b94 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b94:	6a 00                	push   $0x0
  pushl $0
80105b96:	6a 00                	push   $0x0
  jmp alltraps
80105b98:	e9 e0 f9 ff ff       	jmp    8010557d <alltraps>

80105b9d <vector1>:
.globl vector1
vector1:
  pushl $0
80105b9d:	6a 00                	push   $0x0
  pushl $1
80105b9f:	6a 01                	push   $0x1
  jmp alltraps
80105ba1:	e9 d7 f9 ff ff       	jmp    8010557d <alltraps>

80105ba6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $2
80105ba8:	6a 02                	push   $0x2
  jmp alltraps
80105baa:	e9 ce f9 ff ff       	jmp    8010557d <alltraps>

80105baf <vector3>:
.globl vector3
vector3:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $3
80105bb1:	6a 03                	push   $0x3
  jmp alltraps
80105bb3:	e9 c5 f9 ff ff       	jmp    8010557d <alltraps>

80105bb8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105bb8:	6a 00                	push   $0x0
  pushl $4
80105bba:	6a 04                	push   $0x4
  jmp alltraps
80105bbc:	e9 bc f9 ff ff       	jmp    8010557d <alltraps>

80105bc1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105bc1:	6a 00                	push   $0x0
  pushl $5
80105bc3:	6a 05                	push   $0x5
  jmp alltraps
80105bc5:	e9 b3 f9 ff ff       	jmp    8010557d <alltraps>

80105bca <vector6>:
.globl vector6
vector6:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $6
80105bcc:	6a 06                	push   $0x6
  jmp alltraps
80105bce:	e9 aa f9 ff ff       	jmp    8010557d <alltraps>

80105bd3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $7
80105bd5:	6a 07                	push   $0x7
  jmp alltraps
80105bd7:	e9 a1 f9 ff ff       	jmp    8010557d <alltraps>

80105bdc <vector8>:
.globl vector8
vector8:
  pushl $8
80105bdc:	6a 08                	push   $0x8
  jmp alltraps
80105bde:	e9 9a f9 ff ff       	jmp    8010557d <alltraps>

80105be3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $9
80105be5:	6a 09                	push   $0x9
  jmp alltraps
80105be7:	e9 91 f9 ff ff       	jmp    8010557d <alltraps>

80105bec <vector10>:
.globl vector10
vector10:
  pushl $10
80105bec:	6a 0a                	push   $0xa
  jmp alltraps
80105bee:	e9 8a f9 ff ff       	jmp    8010557d <alltraps>

80105bf3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bf3:	6a 0b                	push   $0xb
  jmp alltraps
80105bf5:	e9 83 f9 ff ff       	jmp    8010557d <alltraps>

80105bfa <vector12>:
.globl vector12
vector12:
  pushl $12
80105bfa:	6a 0c                	push   $0xc
  jmp alltraps
80105bfc:	e9 7c f9 ff ff       	jmp    8010557d <alltraps>

80105c01 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c01:	6a 0d                	push   $0xd
  jmp alltraps
80105c03:	e9 75 f9 ff ff       	jmp    8010557d <alltraps>

80105c08 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c08:	6a 0e                	push   $0xe
  jmp alltraps
80105c0a:	e9 6e f9 ff ff       	jmp    8010557d <alltraps>

80105c0f <vector15>:
.globl vector15
vector15:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $15
80105c11:	6a 0f                	push   $0xf
  jmp alltraps
80105c13:	e9 65 f9 ff ff       	jmp    8010557d <alltraps>

80105c18 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $16
80105c1a:	6a 10                	push   $0x10
  jmp alltraps
80105c1c:	e9 5c f9 ff ff       	jmp    8010557d <alltraps>

80105c21 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c21:	6a 11                	push   $0x11
  jmp alltraps
80105c23:	e9 55 f9 ff ff       	jmp    8010557d <alltraps>

80105c28 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $18
80105c2a:	6a 12                	push   $0x12
  jmp alltraps
80105c2c:	e9 4c f9 ff ff       	jmp    8010557d <alltraps>

80105c31 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $19
80105c33:	6a 13                	push   $0x13
  jmp alltraps
80105c35:	e9 43 f9 ff ff       	jmp    8010557d <alltraps>

80105c3a <vector20>:
.globl vector20
vector20:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $20
80105c3c:	6a 14                	push   $0x14
  jmp alltraps
80105c3e:	e9 3a f9 ff ff       	jmp    8010557d <alltraps>

80105c43 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $21
80105c45:	6a 15                	push   $0x15
  jmp alltraps
80105c47:	e9 31 f9 ff ff       	jmp    8010557d <alltraps>

80105c4c <vector22>:
.globl vector22
vector22:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $22
80105c4e:	6a 16                	push   $0x16
  jmp alltraps
80105c50:	e9 28 f9 ff ff       	jmp    8010557d <alltraps>

80105c55 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $23
80105c57:	6a 17                	push   $0x17
  jmp alltraps
80105c59:	e9 1f f9 ff ff       	jmp    8010557d <alltraps>

80105c5e <vector24>:
.globl vector24
vector24:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $24
80105c60:	6a 18                	push   $0x18
  jmp alltraps
80105c62:	e9 16 f9 ff ff       	jmp    8010557d <alltraps>

80105c67 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $25
80105c69:	6a 19                	push   $0x19
  jmp alltraps
80105c6b:	e9 0d f9 ff ff       	jmp    8010557d <alltraps>

80105c70 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $26
80105c72:	6a 1a                	push   $0x1a
  jmp alltraps
80105c74:	e9 04 f9 ff ff       	jmp    8010557d <alltraps>

80105c79 <vector27>:
.globl vector27
vector27:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $27
80105c7b:	6a 1b                	push   $0x1b
  jmp alltraps
80105c7d:	e9 fb f8 ff ff       	jmp    8010557d <alltraps>

80105c82 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $28
80105c84:	6a 1c                	push   $0x1c
  jmp alltraps
80105c86:	e9 f2 f8 ff ff       	jmp    8010557d <alltraps>

80105c8b <vector29>:
.globl vector29
vector29:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $29
80105c8d:	6a 1d                	push   $0x1d
  jmp alltraps
80105c8f:	e9 e9 f8 ff ff       	jmp    8010557d <alltraps>

80105c94 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $30
80105c96:	6a 1e                	push   $0x1e
  jmp alltraps
80105c98:	e9 e0 f8 ff ff       	jmp    8010557d <alltraps>

80105c9d <vector31>:
.globl vector31
vector31:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $31
80105c9f:	6a 1f                	push   $0x1f
  jmp alltraps
80105ca1:	e9 d7 f8 ff ff       	jmp    8010557d <alltraps>

80105ca6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $32
80105ca8:	6a 20                	push   $0x20
  jmp alltraps
80105caa:	e9 ce f8 ff ff       	jmp    8010557d <alltraps>

80105caf <vector33>:
.globl vector33
vector33:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $33
80105cb1:	6a 21                	push   $0x21
  jmp alltraps
80105cb3:	e9 c5 f8 ff ff       	jmp    8010557d <alltraps>

80105cb8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $34
80105cba:	6a 22                	push   $0x22
  jmp alltraps
80105cbc:	e9 bc f8 ff ff       	jmp    8010557d <alltraps>

80105cc1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $35
80105cc3:	6a 23                	push   $0x23
  jmp alltraps
80105cc5:	e9 b3 f8 ff ff       	jmp    8010557d <alltraps>

80105cca <vector36>:
.globl vector36
vector36:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $36
80105ccc:	6a 24                	push   $0x24
  jmp alltraps
80105cce:	e9 aa f8 ff ff       	jmp    8010557d <alltraps>

80105cd3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $37
80105cd5:	6a 25                	push   $0x25
  jmp alltraps
80105cd7:	e9 a1 f8 ff ff       	jmp    8010557d <alltraps>

80105cdc <vector38>:
.globl vector38
vector38:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $38
80105cde:	6a 26                	push   $0x26
  jmp alltraps
80105ce0:	e9 98 f8 ff ff       	jmp    8010557d <alltraps>

80105ce5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $39
80105ce7:	6a 27                	push   $0x27
  jmp alltraps
80105ce9:	e9 8f f8 ff ff       	jmp    8010557d <alltraps>

80105cee <vector40>:
.globl vector40
vector40:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $40
80105cf0:	6a 28                	push   $0x28
  jmp alltraps
80105cf2:	e9 86 f8 ff ff       	jmp    8010557d <alltraps>

80105cf7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $41
80105cf9:	6a 29                	push   $0x29
  jmp alltraps
80105cfb:	e9 7d f8 ff ff       	jmp    8010557d <alltraps>

80105d00 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $42
80105d02:	6a 2a                	push   $0x2a
  jmp alltraps
80105d04:	e9 74 f8 ff ff       	jmp    8010557d <alltraps>

80105d09 <vector43>:
.globl vector43
vector43:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $43
80105d0b:	6a 2b                	push   $0x2b
  jmp alltraps
80105d0d:	e9 6b f8 ff ff       	jmp    8010557d <alltraps>

80105d12 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $44
80105d14:	6a 2c                	push   $0x2c
  jmp alltraps
80105d16:	e9 62 f8 ff ff       	jmp    8010557d <alltraps>

80105d1b <vector45>:
.globl vector45
vector45:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $45
80105d1d:	6a 2d                	push   $0x2d
  jmp alltraps
80105d1f:	e9 59 f8 ff ff       	jmp    8010557d <alltraps>

80105d24 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $46
80105d26:	6a 2e                	push   $0x2e
  jmp alltraps
80105d28:	e9 50 f8 ff ff       	jmp    8010557d <alltraps>

80105d2d <vector47>:
.globl vector47
vector47:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $47
80105d2f:	6a 2f                	push   $0x2f
  jmp alltraps
80105d31:	e9 47 f8 ff ff       	jmp    8010557d <alltraps>

80105d36 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $48
80105d38:	6a 30                	push   $0x30
  jmp alltraps
80105d3a:	e9 3e f8 ff ff       	jmp    8010557d <alltraps>

80105d3f <vector49>:
.globl vector49
vector49:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $49
80105d41:	6a 31                	push   $0x31
  jmp alltraps
80105d43:	e9 35 f8 ff ff       	jmp    8010557d <alltraps>

80105d48 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $50
80105d4a:	6a 32                	push   $0x32
  jmp alltraps
80105d4c:	e9 2c f8 ff ff       	jmp    8010557d <alltraps>

80105d51 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $51
80105d53:	6a 33                	push   $0x33
  jmp alltraps
80105d55:	e9 23 f8 ff ff       	jmp    8010557d <alltraps>

80105d5a <vector52>:
.globl vector52
vector52:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $52
80105d5c:	6a 34                	push   $0x34
  jmp alltraps
80105d5e:	e9 1a f8 ff ff       	jmp    8010557d <alltraps>

80105d63 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $53
80105d65:	6a 35                	push   $0x35
  jmp alltraps
80105d67:	e9 11 f8 ff ff       	jmp    8010557d <alltraps>

80105d6c <vector54>:
.globl vector54
vector54:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $54
80105d6e:	6a 36                	push   $0x36
  jmp alltraps
80105d70:	e9 08 f8 ff ff       	jmp    8010557d <alltraps>

80105d75 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $55
80105d77:	6a 37                	push   $0x37
  jmp alltraps
80105d79:	e9 ff f7 ff ff       	jmp    8010557d <alltraps>

80105d7e <vector56>:
.globl vector56
vector56:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $56
80105d80:	6a 38                	push   $0x38
  jmp alltraps
80105d82:	e9 f6 f7 ff ff       	jmp    8010557d <alltraps>

80105d87 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $57
80105d89:	6a 39                	push   $0x39
  jmp alltraps
80105d8b:	e9 ed f7 ff ff       	jmp    8010557d <alltraps>

80105d90 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $58
80105d92:	6a 3a                	push   $0x3a
  jmp alltraps
80105d94:	e9 e4 f7 ff ff       	jmp    8010557d <alltraps>

80105d99 <vector59>:
.globl vector59
vector59:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $59
80105d9b:	6a 3b                	push   $0x3b
  jmp alltraps
80105d9d:	e9 db f7 ff ff       	jmp    8010557d <alltraps>

80105da2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $60
80105da4:	6a 3c                	push   $0x3c
  jmp alltraps
80105da6:	e9 d2 f7 ff ff       	jmp    8010557d <alltraps>

80105dab <vector61>:
.globl vector61
vector61:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $61
80105dad:	6a 3d                	push   $0x3d
  jmp alltraps
80105daf:	e9 c9 f7 ff ff       	jmp    8010557d <alltraps>

80105db4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $62
80105db6:	6a 3e                	push   $0x3e
  jmp alltraps
80105db8:	e9 c0 f7 ff ff       	jmp    8010557d <alltraps>

80105dbd <vector63>:
.globl vector63
vector63:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $63
80105dbf:	6a 3f                	push   $0x3f
  jmp alltraps
80105dc1:	e9 b7 f7 ff ff       	jmp    8010557d <alltraps>

80105dc6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $64
80105dc8:	6a 40                	push   $0x40
  jmp alltraps
80105dca:	e9 ae f7 ff ff       	jmp    8010557d <alltraps>

80105dcf <vector65>:
.globl vector65
vector65:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $65
80105dd1:	6a 41                	push   $0x41
  jmp alltraps
80105dd3:	e9 a5 f7 ff ff       	jmp    8010557d <alltraps>

80105dd8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $66
80105dda:	6a 42                	push   $0x42
  jmp alltraps
80105ddc:	e9 9c f7 ff ff       	jmp    8010557d <alltraps>

80105de1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $67
80105de3:	6a 43                	push   $0x43
  jmp alltraps
80105de5:	e9 93 f7 ff ff       	jmp    8010557d <alltraps>

80105dea <vector68>:
.globl vector68
vector68:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $68
80105dec:	6a 44                	push   $0x44
  jmp alltraps
80105dee:	e9 8a f7 ff ff       	jmp    8010557d <alltraps>

80105df3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $69
80105df5:	6a 45                	push   $0x45
  jmp alltraps
80105df7:	e9 81 f7 ff ff       	jmp    8010557d <alltraps>

80105dfc <vector70>:
.globl vector70
vector70:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $70
80105dfe:	6a 46                	push   $0x46
  jmp alltraps
80105e00:	e9 78 f7 ff ff       	jmp    8010557d <alltraps>

80105e05 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $71
80105e07:	6a 47                	push   $0x47
  jmp alltraps
80105e09:	e9 6f f7 ff ff       	jmp    8010557d <alltraps>

80105e0e <vector72>:
.globl vector72
vector72:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $72
80105e10:	6a 48                	push   $0x48
  jmp alltraps
80105e12:	e9 66 f7 ff ff       	jmp    8010557d <alltraps>

80105e17 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $73
80105e19:	6a 49                	push   $0x49
  jmp alltraps
80105e1b:	e9 5d f7 ff ff       	jmp    8010557d <alltraps>

80105e20 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $74
80105e22:	6a 4a                	push   $0x4a
  jmp alltraps
80105e24:	e9 54 f7 ff ff       	jmp    8010557d <alltraps>

80105e29 <vector75>:
.globl vector75
vector75:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $75
80105e2b:	6a 4b                	push   $0x4b
  jmp alltraps
80105e2d:	e9 4b f7 ff ff       	jmp    8010557d <alltraps>

80105e32 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $76
80105e34:	6a 4c                	push   $0x4c
  jmp alltraps
80105e36:	e9 42 f7 ff ff       	jmp    8010557d <alltraps>

80105e3b <vector77>:
.globl vector77
vector77:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $77
80105e3d:	6a 4d                	push   $0x4d
  jmp alltraps
80105e3f:	e9 39 f7 ff ff       	jmp    8010557d <alltraps>

80105e44 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $78
80105e46:	6a 4e                	push   $0x4e
  jmp alltraps
80105e48:	e9 30 f7 ff ff       	jmp    8010557d <alltraps>

80105e4d <vector79>:
.globl vector79
vector79:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $79
80105e4f:	6a 4f                	push   $0x4f
  jmp alltraps
80105e51:	e9 27 f7 ff ff       	jmp    8010557d <alltraps>

80105e56 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $80
80105e58:	6a 50                	push   $0x50
  jmp alltraps
80105e5a:	e9 1e f7 ff ff       	jmp    8010557d <alltraps>

80105e5f <vector81>:
.globl vector81
vector81:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $81
80105e61:	6a 51                	push   $0x51
  jmp alltraps
80105e63:	e9 15 f7 ff ff       	jmp    8010557d <alltraps>

80105e68 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $82
80105e6a:	6a 52                	push   $0x52
  jmp alltraps
80105e6c:	e9 0c f7 ff ff       	jmp    8010557d <alltraps>

80105e71 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $83
80105e73:	6a 53                	push   $0x53
  jmp alltraps
80105e75:	e9 03 f7 ff ff       	jmp    8010557d <alltraps>

80105e7a <vector84>:
.globl vector84
vector84:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $84
80105e7c:	6a 54                	push   $0x54
  jmp alltraps
80105e7e:	e9 fa f6 ff ff       	jmp    8010557d <alltraps>

80105e83 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $85
80105e85:	6a 55                	push   $0x55
  jmp alltraps
80105e87:	e9 f1 f6 ff ff       	jmp    8010557d <alltraps>

80105e8c <vector86>:
.globl vector86
vector86:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $86
80105e8e:	6a 56                	push   $0x56
  jmp alltraps
80105e90:	e9 e8 f6 ff ff       	jmp    8010557d <alltraps>

80105e95 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $87
80105e97:	6a 57                	push   $0x57
  jmp alltraps
80105e99:	e9 df f6 ff ff       	jmp    8010557d <alltraps>

80105e9e <vector88>:
.globl vector88
vector88:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $88
80105ea0:	6a 58                	push   $0x58
  jmp alltraps
80105ea2:	e9 d6 f6 ff ff       	jmp    8010557d <alltraps>

80105ea7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $89
80105ea9:	6a 59                	push   $0x59
  jmp alltraps
80105eab:	e9 cd f6 ff ff       	jmp    8010557d <alltraps>

80105eb0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $90
80105eb2:	6a 5a                	push   $0x5a
  jmp alltraps
80105eb4:	e9 c4 f6 ff ff       	jmp    8010557d <alltraps>

80105eb9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $91
80105ebb:	6a 5b                	push   $0x5b
  jmp alltraps
80105ebd:	e9 bb f6 ff ff       	jmp    8010557d <alltraps>

80105ec2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $92
80105ec4:	6a 5c                	push   $0x5c
  jmp alltraps
80105ec6:	e9 b2 f6 ff ff       	jmp    8010557d <alltraps>

80105ecb <vector93>:
.globl vector93
vector93:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $93
80105ecd:	6a 5d                	push   $0x5d
  jmp alltraps
80105ecf:	e9 a9 f6 ff ff       	jmp    8010557d <alltraps>

80105ed4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $94
80105ed6:	6a 5e                	push   $0x5e
  jmp alltraps
80105ed8:	e9 a0 f6 ff ff       	jmp    8010557d <alltraps>

80105edd <vector95>:
.globl vector95
vector95:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $95
80105edf:	6a 5f                	push   $0x5f
  jmp alltraps
80105ee1:	e9 97 f6 ff ff       	jmp    8010557d <alltraps>

80105ee6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $96
80105ee8:	6a 60                	push   $0x60
  jmp alltraps
80105eea:	e9 8e f6 ff ff       	jmp    8010557d <alltraps>

80105eef <vector97>:
.globl vector97
vector97:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $97
80105ef1:	6a 61                	push   $0x61
  jmp alltraps
80105ef3:	e9 85 f6 ff ff       	jmp    8010557d <alltraps>

80105ef8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $98
80105efa:	6a 62                	push   $0x62
  jmp alltraps
80105efc:	e9 7c f6 ff ff       	jmp    8010557d <alltraps>

80105f01 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $99
80105f03:	6a 63                	push   $0x63
  jmp alltraps
80105f05:	e9 73 f6 ff ff       	jmp    8010557d <alltraps>

80105f0a <vector100>:
.globl vector100
vector100:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $100
80105f0c:	6a 64                	push   $0x64
  jmp alltraps
80105f0e:	e9 6a f6 ff ff       	jmp    8010557d <alltraps>

80105f13 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $101
80105f15:	6a 65                	push   $0x65
  jmp alltraps
80105f17:	e9 61 f6 ff ff       	jmp    8010557d <alltraps>

80105f1c <vector102>:
.globl vector102
vector102:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $102
80105f1e:	6a 66                	push   $0x66
  jmp alltraps
80105f20:	e9 58 f6 ff ff       	jmp    8010557d <alltraps>

80105f25 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $103
80105f27:	6a 67                	push   $0x67
  jmp alltraps
80105f29:	e9 4f f6 ff ff       	jmp    8010557d <alltraps>

80105f2e <vector104>:
.globl vector104
vector104:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $104
80105f30:	6a 68                	push   $0x68
  jmp alltraps
80105f32:	e9 46 f6 ff ff       	jmp    8010557d <alltraps>

80105f37 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $105
80105f39:	6a 69                	push   $0x69
  jmp alltraps
80105f3b:	e9 3d f6 ff ff       	jmp    8010557d <alltraps>

80105f40 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $106
80105f42:	6a 6a                	push   $0x6a
  jmp alltraps
80105f44:	e9 34 f6 ff ff       	jmp    8010557d <alltraps>

80105f49 <vector107>:
.globl vector107
vector107:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $107
80105f4b:	6a 6b                	push   $0x6b
  jmp alltraps
80105f4d:	e9 2b f6 ff ff       	jmp    8010557d <alltraps>

80105f52 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $108
80105f54:	6a 6c                	push   $0x6c
  jmp alltraps
80105f56:	e9 22 f6 ff ff       	jmp    8010557d <alltraps>

80105f5b <vector109>:
.globl vector109
vector109:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $109
80105f5d:	6a 6d                	push   $0x6d
  jmp alltraps
80105f5f:	e9 19 f6 ff ff       	jmp    8010557d <alltraps>

80105f64 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $110
80105f66:	6a 6e                	push   $0x6e
  jmp alltraps
80105f68:	e9 10 f6 ff ff       	jmp    8010557d <alltraps>

80105f6d <vector111>:
.globl vector111
vector111:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $111
80105f6f:	6a 6f                	push   $0x6f
  jmp alltraps
80105f71:	e9 07 f6 ff ff       	jmp    8010557d <alltraps>

80105f76 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $112
80105f78:	6a 70                	push   $0x70
  jmp alltraps
80105f7a:	e9 fe f5 ff ff       	jmp    8010557d <alltraps>

80105f7f <vector113>:
.globl vector113
vector113:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $113
80105f81:	6a 71                	push   $0x71
  jmp alltraps
80105f83:	e9 f5 f5 ff ff       	jmp    8010557d <alltraps>

80105f88 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $114
80105f8a:	6a 72                	push   $0x72
  jmp alltraps
80105f8c:	e9 ec f5 ff ff       	jmp    8010557d <alltraps>

80105f91 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $115
80105f93:	6a 73                	push   $0x73
  jmp alltraps
80105f95:	e9 e3 f5 ff ff       	jmp    8010557d <alltraps>

80105f9a <vector116>:
.globl vector116
vector116:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $116
80105f9c:	6a 74                	push   $0x74
  jmp alltraps
80105f9e:	e9 da f5 ff ff       	jmp    8010557d <alltraps>

80105fa3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $117
80105fa5:	6a 75                	push   $0x75
  jmp alltraps
80105fa7:	e9 d1 f5 ff ff       	jmp    8010557d <alltraps>

80105fac <vector118>:
.globl vector118
vector118:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $118
80105fae:	6a 76                	push   $0x76
  jmp alltraps
80105fb0:	e9 c8 f5 ff ff       	jmp    8010557d <alltraps>

80105fb5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $119
80105fb7:	6a 77                	push   $0x77
  jmp alltraps
80105fb9:	e9 bf f5 ff ff       	jmp    8010557d <alltraps>

80105fbe <vector120>:
.globl vector120
vector120:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $120
80105fc0:	6a 78                	push   $0x78
  jmp alltraps
80105fc2:	e9 b6 f5 ff ff       	jmp    8010557d <alltraps>

80105fc7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $121
80105fc9:	6a 79                	push   $0x79
  jmp alltraps
80105fcb:	e9 ad f5 ff ff       	jmp    8010557d <alltraps>

80105fd0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $122
80105fd2:	6a 7a                	push   $0x7a
  jmp alltraps
80105fd4:	e9 a4 f5 ff ff       	jmp    8010557d <alltraps>

80105fd9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $123
80105fdb:	6a 7b                	push   $0x7b
  jmp alltraps
80105fdd:	e9 9b f5 ff ff       	jmp    8010557d <alltraps>

80105fe2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $124
80105fe4:	6a 7c                	push   $0x7c
  jmp alltraps
80105fe6:	e9 92 f5 ff ff       	jmp    8010557d <alltraps>

80105feb <vector125>:
.globl vector125
vector125:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $125
80105fed:	6a 7d                	push   $0x7d
  jmp alltraps
80105fef:	e9 89 f5 ff ff       	jmp    8010557d <alltraps>

80105ff4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $126
80105ff6:	6a 7e                	push   $0x7e
  jmp alltraps
80105ff8:	e9 80 f5 ff ff       	jmp    8010557d <alltraps>

80105ffd <vector127>:
.globl vector127
vector127:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $127
80105fff:	6a 7f                	push   $0x7f
  jmp alltraps
80106001:	e9 77 f5 ff ff       	jmp    8010557d <alltraps>

80106006 <vector128>:
.globl vector128
vector128:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $128
80106008:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010600d:	e9 6b f5 ff ff       	jmp    8010557d <alltraps>

80106012 <vector129>:
.globl vector129
vector129:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $129
80106014:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106019:	e9 5f f5 ff ff       	jmp    8010557d <alltraps>

8010601e <vector130>:
.globl vector130
vector130:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $130
80106020:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106025:	e9 53 f5 ff ff       	jmp    8010557d <alltraps>

8010602a <vector131>:
.globl vector131
vector131:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $131
8010602c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106031:	e9 47 f5 ff ff       	jmp    8010557d <alltraps>

80106036 <vector132>:
.globl vector132
vector132:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $132
80106038:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010603d:	e9 3b f5 ff ff       	jmp    8010557d <alltraps>

80106042 <vector133>:
.globl vector133
vector133:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $133
80106044:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106049:	e9 2f f5 ff ff       	jmp    8010557d <alltraps>

8010604e <vector134>:
.globl vector134
vector134:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $134
80106050:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106055:	e9 23 f5 ff ff       	jmp    8010557d <alltraps>

8010605a <vector135>:
.globl vector135
vector135:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $135
8010605c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106061:	e9 17 f5 ff ff       	jmp    8010557d <alltraps>

80106066 <vector136>:
.globl vector136
vector136:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $136
80106068:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010606d:	e9 0b f5 ff ff       	jmp    8010557d <alltraps>

80106072 <vector137>:
.globl vector137
vector137:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $137
80106074:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106079:	e9 ff f4 ff ff       	jmp    8010557d <alltraps>

8010607e <vector138>:
.globl vector138
vector138:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $138
80106080:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106085:	e9 f3 f4 ff ff       	jmp    8010557d <alltraps>

8010608a <vector139>:
.globl vector139
vector139:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $139
8010608c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106091:	e9 e7 f4 ff ff       	jmp    8010557d <alltraps>

80106096 <vector140>:
.globl vector140
vector140:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $140
80106098:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010609d:	e9 db f4 ff ff       	jmp    8010557d <alltraps>

801060a2 <vector141>:
.globl vector141
vector141:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $141
801060a4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060a9:	e9 cf f4 ff ff       	jmp    8010557d <alltraps>

801060ae <vector142>:
.globl vector142
vector142:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $142
801060b0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060b5:	e9 c3 f4 ff ff       	jmp    8010557d <alltraps>

801060ba <vector143>:
.globl vector143
vector143:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $143
801060bc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060c1:	e9 b7 f4 ff ff       	jmp    8010557d <alltraps>

801060c6 <vector144>:
.globl vector144
vector144:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $144
801060c8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060cd:	e9 ab f4 ff ff       	jmp    8010557d <alltraps>

801060d2 <vector145>:
.globl vector145
vector145:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $145
801060d4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060d9:	e9 9f f4 ff ff       	jmp    8010557d <alltraps>

801060de <vector146>:
.globl vector146
vector146:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $146
801060e0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060e5:	e9 93 f4 ff ff       	jmp    8010557d <alltraps>

801060ea <vector147>:
.globl vector147
vector147:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $147
801060ec:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060f1:	e9 87 f4 ff ff       	jmp    8010557d <alltraps>

801060f6 <vector148>:
.globl vector148
vector148:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $148
801060f8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060fd:	e9 7b f4 ff ff       	jmp    8010557d <alltraps>

80106102 <vector149>:
.globl vector149
vector149:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $149
80106104:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106109:	e9 6f f4 ff ff       	jmp    8010557d <alltraps>

8010610e <vector150>:
.globl vector150
vector150:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $150
80106110:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106115:	e9 63 f4 ff ff       	jmp    8010557d <alltraps>

8010611a <vector151>:
.globl vector151
vector151:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $151
8010611c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106121:	e9 57 f4 ff ff       	jmp    8010557d <alltraps>

80106126 <vector152>:
.globl vector152
vector152:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $152
80106128:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010612d:	e9 4b f4 ff ff       	jmp    8010557d <alltraps>

80106132 <vector153>:
.globl vector153
vector153:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $153
80106134:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106139:	e9 3f f4 ff ff       	jmp    8010557d <alltraps>

8010613e <vector154>:
.globl vector154
vector154:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $154
80106140:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106145:	e9 33 f4 ff ff       	jmp    8010557d <alltraps>

8010614a <vector155>:
.globl vector155
vector155:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $155
8010614c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106151:	e9 27 f4 ff ff       	jmp    8010557d <alltraps>

80106156 <vector156>:
.globl vector156
vector156:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $156
80106158:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010615d:	e9 1b f4 ff ff       	jmp    8010557d <alltraps>

80106162 <vector157>:
.globl vector157
vector157:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $157
80106164:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106169:	e9 0f f4 ff ff       	jmp    8010557d <alltraps>

8010616e <vector158>:
.globl vector158
vector158:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $158
80106170:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106175:	e9 03 f4 ff ff       	jmp    8010557d <alltraps>

8010617a <vector159>:
.globl vector159
vector159:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $159
8010617c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106181:	e9 f7 f3 ff ff       	jmp    8010557d <alltraps>

80106186 <vector160>:
.globl vector160
vector160:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $160
80106188:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010618d:	e9 eb f3 ff ff       	jmp    8010557d <alltraps>

80106192 <vector161>:
.globl vector161
vector161:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $161
80106194:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106199:	e9 df f3 ff ff       	jmp    8010557d <alltraps>

8010619e <vector162>:
.globl vector162
vector162:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $162
801061a0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061a5:	e9 d3 f3 ff ff       	jmp    8010557d <alltraps>

801061aa <vector163>:
.globl vector163
vector163:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $163
801061ac:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061b1:	e9 c7 f3 ff ff       	jmp    8010557d <alltraps>

801061b6 <vector164>:
.globl vector164
vector164:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $164
801061b8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061bd:	e9 bb f3 ff ff       	jmp    8010557d <alltraps>

801061c2 <vector165>:
.globl vector165
vector165:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $165
801061c4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061c9:	e9 af f3 ff ff       	jmp    8010557d <alltraps>

801061ce <vector166>:
.globl vector166
vector166:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $166
801061d0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061d5:	e9 a3 f3 ff ff       	jmp    8010557d <alltraps>

801061da <vector167>:
.globl vector167
vector167:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $167
801061dc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061e1:	e9 97 f3 ff ff       	jmp    8010557d <alltraps>

801061e6 <vector168>:
.globl vector168
vector168:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $168
801061e8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ed:	e9 8b f3 ff ff       	jmp    8010557d <alltraps>

801061f2 <vector169>:
.globl vector169
vector169:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $169
801061f4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061f9:	e9 7f f3 ff ff       	jmp    8010557d <alltraps>

801061fe <vector170>:
.globl vector170
vector170:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $170
80106200:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106205:	e9 73 f3 ff ff       	jmp    8010557d <alltraps>

8010620a <vector171>:
.globl vector171
vector171:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $171
8010620c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106211:	e9 67 f3 ff ff       	jmp    8010557d <alltraps>

80106216 <vector172>:
.globl vector172
vector172:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $172
80106218:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010621d:	e9 5b f3 ff ff       	jmp    8010557d <alltraps>

80106222 <vector173>:
.globl vector173
vector173:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $173
80106224:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106229:	e9 4f f3 ff ff       	jmp    8010557d <alltraps>

8010622e <vector174>:
.globl vector174
vector174:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $174
80106230:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106235:	e9 43 f3 ff ff       	jmp    8010557d <alltraps>

8010623a <vector175>:
.globl vector175
vector175:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $175
8010623c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106241:	e9 37 f3 ff ff       	jmp    8010557d <alltraps>

80106246 <vector176>:
.globl vector176
vector176:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $176
80106248:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010624d:	e9 2b f3 ff ff       	jmp    8010557d <alltraps>

80106252 <vector177>:
.globl vector177
vector177:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $177
80106254:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106259:	e9 1f f3 ff ff       	jmp    8010557d <alltraps>

8010625e <vector178>:
.globl vector178
vector178:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $178
80106260:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106265:	e9 13 f3 ff ff       	jmp    8010557d <alltraps>

8010626a <vector179>:
.globl vector179
vector179:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $179
8010626c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106271:	e9 07 f3 ff ff       	jmp    8010557d <alltraps>

80106276 <vector180>:
.globl vector180
vector180:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $180
80106278:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010627d:	e9 fb f2 ff ff       	jmp    8010557d <alltraps>

80106282 <vector181>:
.globl vector181
vector181:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $181
80106284:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106289:	e9 ef f2 ff ff       	jmp    8010557d <alltraps>

8010628e <vector182>:
.globl vector182
vector182:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $182
80106290:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106295:	e9 e3 f2 ff ff       	jmp    8010557d <alltraps>

8010629a <vector183>:
.globl vector183
vector183:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $183
8010629c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062a1:	e9 d7 f2 ff ff       	jmp    8010557d <alltraps>

801062a6 <vector184>:
.globl vector184
vector184:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $184
801062a8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062ad:	e9 cb f2 ff ff       	jmp    8010557d <alltraps>

801062b2 <vector185>:
.globl vector185
vector185:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $185
801062b4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062b9:	e9 bf f2 ff ff       	jmp    8010557d <alltraps>

801062be <vector186>:
.globl vector186
vector186:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $186
801062c0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062c5:	e9 b3 f2 ff ff       	jmp    8010557d <alltraps>

801062ca <vector187>:
.globl vector187
vector187:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $187
801062cc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062d1:	e9 a7 f2 ff ff       	jmp    8010557d <alltraps>

801062d6 <vector188>:
.globl vector188
vector188:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $188
801062d8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062dd:	e9 9b f2 ff ff       	jmp    8010557d <alltraps>

801062e2 <vector189>:
.globl vector189
vector189:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $189
801062e4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062e9:	e9 8f f2 ff ff       	jmp    8010557d <alltraps>

801062ee <vector190>:
.globl vector190
vector190:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $190
801062f0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062f5:	e9 83 f2 ff ff       	jmp    8010557d <alltraps>

801062fa <vector191>:
.globl vector191
vector191:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $191
801062fc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106301:	e9 77 f2 ff ff       	jmp    8010557d <alltraps>

80106306 <vector192>:
.globl vector192
vector192:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $192
80106308:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010630d:	e9 6b f2 ff ff       	jmp    8010557d <alltraps>

80106312 <vector193>:
.globl vector193
vector193:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $193
80106314:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106319:	e9 5f f2 ff ff       	jmp    8010557d <alltraps>

8010631e <vector194>:
.globl vector194
vector194:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $194
80106320:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106325:	e9 53 f2 ff ff       	jmp    8010557d <alltraps>

8010632a <vector195>:
.globl vector195
vector195:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $195
8010632c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106331:	e9 47 f2 ff ff       	jmp    8010557d <alltraps>

80106336 <vector196>:
.globl vector196
vector196:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $196
80106338:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010633d:	e9 3b f2 ff ff       	jmp    8010557d <alltraps>

80106342 <vector197>:
.globl vector197
vector197:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $197
80106344:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106349:	e9 2f f2 ff ff       	jmp    8010557d <alltraps>

8010634e <vector198>:
.globl vector198
vector198:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $198
80106350:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106355:	e9 23 f2 ff ff       	jmp    8010557d <alltraps>

8010635a <vector199>:
.globl vector199
vector199:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $199
8010635c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106361:	e9 17 f2 ff ff       	jmp    8010557d <alltraps>

80106366 <vector200>:
.globl vector200
vector200:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $200
80106368:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010636d:	e9 0b f2 ff ff       	jmp    8010557d <alltraps>

80106372 <vector201>:
.globl vector201
vector201:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $201
80106374:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106379:	e9 ff f1 ff ff       	jmp    8010557d <alltraps>

8010637e <vector202>:
.globl vector202
vector202:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $202
80106380:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106385:	e9 f3 f1 ff ff       	jmp    8010557d <alltraps>

8010638a <vector203>:
.globl vector203
vector203:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $203
8010638c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106391:	e9 e7 f1 ff ff       	jmp    8010557d <alltraps>

80106396 <vector204>:
.globl vector204
vector204:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $204
80106398:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010639d:	e9 db f1 ff ff       	jmp    8010557d <alltraps>

801063a2 <vector205>:
.globl vector205
vector205:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $205
801063a4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063a9:	e9 cf f1 ff ff       	jmp    8010557d <alltraps>

801063ae <vector206>:
.globl vector206
vector206:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $206
801063b0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063b5:	e9 c3 f1 ff ff       	jmp    8010557d <alltraps>

801063ba <vector207>:
.globl vector207
vector207:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $207
801063bc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063c1:	e9 b7 f1 ff ff       	jmp    8010557d <alltraps>

801063c6 <vector208>:
.globl vector208
vector208:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $208
801063c8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063cd:	e9 ab f1 ff ff       	jmp    8010557d <alltraps>

801063d2 <vector209>:
.globl vector209
vector209:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $209
801063d4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063d9:	e9 9f f1 ff ff       	jmp    8010557d <alltraps>

801063de <vector210>:
.globl vector210
vector210:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $210
801063e0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063e5:	e9 93 f1 ff ff       	jmp    8010557d <alltraps>

801063ea <vector211>:
.globl vector211
vector211:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $211
801063ec:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063f1:	e9 87 f1 ff ff       	jmp    8010557d <alltraps>

801063f6 <vector212>:
.globl vector212
vector212:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $212
801063f8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063fd:	e9 7b f1 ff ff       	jmp    8010557d <alltraps>

80106402 <vector213>:
.globl vector213
vector213:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $213
80106404:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106409:	e9 6f f1 ff ff       	jmp    8010557d <alltraps>

8010640e <vector214>:
.globl vector214
vector214:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $214
80106410:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106415:	e9 63 f1 ff ff       	jmp    8010557d <alltraps>

8010641a <vector215>:
.globl vector215
vector215:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $215
8010641c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106421:	e9 57 f1 ff ff       	jmp    8010557d <alltraps>

80106426 <vector216>:
.globl vector216
vector216:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $216
80106428:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010642d:	e9 4b f1 ff ff       	jmp    8010557d <alltraps>

80106432 <vector217>:
.globl vector217
vector217:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $217
80106434:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106439:	e9 3f f1 ff ff       	jmp    8010557d <alltraps>

8010643e <vector218>:
.globl vector218
vector218:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $218
80106440:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106445:	e9 33 f1 ff ff       	jmp    8010557d <alltraps>

8010644a <vector219>:
.globl vector219
vector219:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $219
8010644c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106451:	e9 27 f1 ff ff       	jmp    8010557d <alltraps>

80106456 <vector220>:
.globl vector220
vector220:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $220
80106458:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010645d:	e9 1b f1 ff ff       	jmp    8010557d <alltraps>

80106462 <vector221>:
.globl vector221
vector221:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $221
80106464:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106469:	e9 0f f1 ff ff       	jmp    8010557d <alltraps>

8010646e <vector222>:
.globl vector222
vector222:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $222
80106470:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106475:	e9 03 f1 ff ff       	jmp    8010557d <alltraps>

8010647a <vector223>:
.globl vector223
vector223:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $223
8010647c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106481:	e9 f7 f0 ff ff       	jmp    8010557d <alltraps>

80106486 <vector224>:
.globl vector224
vector224:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $224
80106488:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010648d:	e9 eb f0 ff ff       	jmp    8010557d <alltraps>

80106492 <vector225>:
.globl vector225
vector225:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $225
80106494:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106499:	e9 df f0 ff ff       	jmp    8010557d <alltraps>

8010649e <vector226>:
.globl vector226
vector226:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $226
801064a0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064a5:	e9 d3 f0 ff ff       	jmp    8010557d <alltraps>

801064aa <vector227>:
.globl vector227
vector227:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $227
801064ac:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064b1:	e9 c7 f0 ff ff       	jmp    8010557d <alltraps>

801064b6 <vector228>:
.globl vector228
vector228:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $228
801064b8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064bd:	e9 bb f0 ff ff       	jmp    8010557d <alltraps>

801064c2 <vector229>:
.globl vector229
vector229:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $229
801064c4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064c9:	e9 af f0 ff ff       	jmp    8010557d <alltraps>

801064ce <vector230>:
.globl vector230
vector230:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $230
801064d0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064d5:	e9 a3 f0 ff ff       	jmp    8010557d <alltraps>

801064da <vector231>:
.globl vector231
vector231:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $231
801064dc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064e1:	e9 97 f0 ff ff       	jmp    8010557d <alltraps>

801064e6 <vector232>:
.globl vector232
vector232:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $232
801064e8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ed:	e9 8b f0 ff ff       	jmp    8010557d <alltraps>

801064f2 <vector233>:
.globl vector233
vector233:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $233
801064f4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064f9:	e9 7f f0 ff ff       	jmp    8010557d <alltraps>

801064fe <vector234>:
.globl vector234
vector234:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $234
80106500:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106505:	e9 73 f0 ff ff       	jmp    8010557d <alltraps>

8010650a <vector235>:
.globl vector235
vector235:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $235
8010650c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106511:	e9 67 f0 ff ff       	jmp    8010557d <alltraps>

80106516 <vector236>:
.globl vector236
vector236:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $236
80106518:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010651d:	e9 5b f0 ff ff       	jmp    8010557d <alltraps>

80106522 <vector237>:
.globl vector237
vector237:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $237
80106524:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106529:	e9 4f f0 ff ff       	jmp    8010557d <alltraps>

8010652e <vector238>:
.globl vector238
vector238:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $238
80106530:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106535:	e9 43 f0 ff ff       	jmp    8010557d <alltraps>

8010653a <vector239>:
.globl vector239
vector239:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $239
8010653c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106541:	e9 37 f0 ff ff       	jmp    8010557d <alltraps>

80106546 <vector240>:
.globl vector240
vector240:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $240
80106548:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010654d:	e9 2b f0 ff ff       	jmp    8010557d <alltraps>

80106552 <vector241>:
.globl vector241
vector241:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $241
80106554:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106559:	e9 1f f0 ff ff       	jmp    8010557d <alltraps>

8010655e <vector242>:
.globl vector242
vector242:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $242
80106560:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106565:	e9 13 f0 ff ff       	jmp    8010557d <alltraps>

8010656a <vector243>:
.globl vector243
vector243:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $243
8010656c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106571:	e9 07 f0 ff ff       	jmp    8010557d <alltraps>

80106576 <vector244>:
.globl vector244
vector244:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $244
80106578:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010657d:	e9 fb ef ff ff       	jmp    8010557d <alltraps>

80106582 <vector245>:
.globl vector245
vector245:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $245
80106584:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106589:	e9 ef ef ff ff       	jmp    8010557d <alltraps>

8010658e <vector246>:
.globl vector246
vector246:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $246
80106590:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106595:	e9 e3 ef ff ff       	jmp    8010557d <alltraps>

8010659a <vector247>:
.globl vector247
vector247:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $247
8010659c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065a1:	e9 d7 ef ff ff       	jmp    8010557d <alltraps>

801065a6 <vector248>:
.globl vector248
vector248:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $248
801065a8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065ad:	e9 cb ef ff ff       	jmp    8010557d <alltraps>

801065b2 <vector249>:
.globl vector249
vector249:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $249
801065b4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065b9:	e9 bf ef ff ff       	jmp    8010557d <alltraps>

801065be <vector250>:
.globl vector250
vector250:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $250
801065c0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065c5:	e9 b3 ef ff ff       	jmp    8010557d <alltraps>

801065ca <vector251>:
.globl vector251
vector251:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $251
801065cc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065d1:	e9 a7 ef ff ff       	jmp    8010557d <alltraps>

801065d6 <vector252>:
.globl vector252
vector252:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $252
801065d8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065dd:	e9 9b ef ff ff       	jmp    8010557d <alltraps>

801065e2 <vector253>:
.globl vector253
vector253:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $253
801065e4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065e9:	e9 8f ef ff ff       	jmp    8010557d <alltraps>

801065ee <vector254>:
.globl vector254
vector254:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $254
801065f0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065f5:	e9 83 ef ff ff       	jmp    8010557d <alltraps>

801065fa <vector255>:
.globl vector255
vector255:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $255
801065fc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106601:	e9 77 ef ff ff       	jmp    8010557d <alltraps>
80106606:	66 90                	xchg   %ax,%ax
80106608:	66 90                	xchg   %ax,%ax
8010660a:	66 90                	xchg   %ax,%ax
8010660c:	66 90                	xchg   %ax,%ax
8010660e:	66 90                	xchg   %ax,%ax

80106610 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106616:	e8 95 d0 ff ff       	call   801036b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010661b:	31 c9                	xor    %ecx,%ecx
8010661d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106622:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106628:	05 80 37 11 80       	add    $0x80113780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010662d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106631:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106636:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106639:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010663d:	31 c9                	xor    %ecx,%ecx
8010663f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106643:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106648:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010664c:	31 c9                	xor    %ecx,%ecx
8010664e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106652:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106657:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010665b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010665d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106661:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106665:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106669:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010666d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106671:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106675:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106679:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010667d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106681:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106686:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010668a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010668e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106692:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106696:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010669a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010669e:	66 89 48 22          	mov    %cx,0x22(%eax)
801066a2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801066a6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801066aa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801066ae:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801066b2:	c1 e8 10             	shr    $0x10,%eax
801066b5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801066b9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066bc:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801066bf:	c9                   	leave  
801066c0:	c3                   	ret    
801066c1:	eb 0d                	jmp    801066d0 <walkpgdir>
801066c3:	90                   	nop
801066c4:	90                   	nop
801066c5:	90                   	nop
801066c6:	90                   	nop
801066c7:	90                   	nop
801066c8:	90                   	nop
801066c9:	90                   	nop
801066ca:	90                   	nop
801066cb:	90                   	nop
801066cc:	90                   	nop
801066cd:	90                   	nop
801066ce:	90                   	nop
801066cf:	90                   	nop

801066d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 1c             	sub    $0x1c,%esp
801066d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066dc:	8b 55 08             	mov    0x8(%ebp),%edx
801066df:	89 fb                	mov    %edi,%ebx
801066e1:	c1 eb 16             	shr    $0x16,%ebx
801066e4:	8d 1c 9a             	lea    (%edx,%ebx,4),%ebx
  if(*pde & PTE_P){
801066e7:	8b 33                	mov    (%ebx),%esi
801066e9:	f7 c6 01 00 00 00    	test   $0x1,%esi
801066ef:	74 27                	je     80106718 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066f1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801066f7:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066fd:	89 fa                	mov    %edi,%edx
}
801066ff:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106702:	c1 ea 0a             	shr    $0xa,%edx
80106705:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
}
8010670b:	5b                   	pop    %ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010670c:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
8010670f:	5e                   	pop    %esi
80106710:	5f                   	pop    %edi
80106711:	5d                   	pop    %ebp
80106712:	c3                   	ret    
80106713:	90                   	nop
80106714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106718:	8b 45 10             	mov    0x10(%ebp),%eax
8010671b:	85 c0                	test   %eax,%eax
8010671d:	74 31                	je     80106750 <walkpgdir+0x80>
8010671f:	e8 ac bd ff ff       	call   801024d0 <kalloc>
80106724:	85 c0                	test   %eax,%eax
80106726:	89 c6                	mov    %eax,%esi
80106728:	74 26                	je     80106750 <walkpgdir+0x80>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010672a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106731:	00 
80106732:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106739:	00 
8010673a:	89 04 24             	mov    %eax,(%esp)
8010673d:	e8 4e dc ff ff       	call   80104390 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106742:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106748:	83 c8 07             	or     $0x7,%eax
8010674b:	89 03                	mov    %eax,(%ebx)
8010674d:	eb ae                	jmp    801066fd <walkpgdir+0x2d>
8010674f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106750:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106753:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106755:	5b                   	pop    %ebx
80106756:	5e                   	pop    %esi
80106757:	5f                   	pop    %edi
80106758:	5d                   	pop    %ebp
80106759:	c3                   	ret    
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106767:	8d b9 ff 0f 00 00    	lea    0xfff(%ecx),%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010676d:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010676e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106774:	83 ec 2c             	sub    $0x2c,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106777:	39 d7                	cmp    %edx,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106779:	89 d3                	mov    %edx,%ebx
8010677b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010677e:	72 3b                	jb     801067bb <deallocuvm.part.0+0x5b>
80106780:	eb 6e                	jmp    801067f0 <deallocuvm.part.0+0x90>
80106782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106788:	8b 08                	mov    (%eax),%ecx
8010678a:	f6 c1 01             	test   $0x1,%cl
8010678d:	74 22                	je     801067b1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010678f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106795:	74 64                	je     801067fb <deallocuvm.part.0+0x9b>
        panic("kfree");
      char *v = P2V(pa);
80106797:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
      kfree(v);
8010679d:	89 0c 24             	mov    %ecx,(%esp)
801067a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067a3:	e8 78 bb ff ff       	call   80102320 <kfree>
      *pte = 0;
801067a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067b7:	39 df                	cmp    %ebx,%edi
801067b9:	73 35                	jae    801067f0 <deallocuvm.part.0+0x90>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801067c2:	00 
801067c3:	89 7c 24 04          	mov    %edi,0x4(%esp)
801067c7:	89 34 24             	mov    %esi,(%esp)
801067ca:	e8 01 ff ff ff       	call   801066d0 <walkpgdir>
    if(!pte)
801067cf:	85 c0                	test   %eax,%eax
801067d1:	75 b5                	jne    80106788 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067d3:	89 fa                	mov    %edi,%edx
801067d5:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801067db:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067e1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067e7:	39 df                	cmp    %ebx,%edi
801067e9:	72 d0                	jb     801067bb <deallocuvm.part.0+0x5b>
801067eb:	90                   	nop
801067ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067f3:	83 c4 2c             	add    $0x2c,%esp
801067f6:	5b                   	pop    %ebx
801067f7:	5e                   	pop    %esi
801067f8:	5f                   	pop    %edi
801067f9:	5d                   	pop    %ebp
801067fa:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067fb:	c7 04 24 de 79 10 80 	movl   $0x801079de,(%esp)
80106802:	e8 59 9b ff ff       	call   80100360 <panic>
80106807:	89 f6                	mov    %esi,%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
80106816:	83 ec 1c             	sub    $0x1c,%esp
80106819:	8b 45 0c             	mov    0xc(%ebp),%eax
8010681c:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010681f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106822:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106826:	89 c7                	mov    %eax,%edi
80106828:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010682e:	29 fe                	sub    %edi,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106830:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106834:	89 75 14             	mov    %esi,0x14(%ebp)
80106837:	89 fe                	mov    %edi,%esi
80106839:	8b 7d 14             	mov    0x14(%ebp),%edi
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010683c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010683f:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106846:	eb 15                	jmp    8010685d <mappages+0x4d>
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106848:	f6 00 01             	testb  $0x1,(%eax)
8010684b:	75 45                	jne    80106892 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010684d:	0b 5d 18             	or     0x18(%ebp),%ebx
    if(a == last)
80106850:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106853:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106855:	74 31                	je     80106888 <mappages+0x78>
      break;
    a += PGSIZE;
80106857:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010685d:	8b 45 08             	mov    0x8(%ebp),%eax
80106860:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106863:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010686a:	00 
8010686b:	89 74 24 04          	mov    %esi,0x4(%esp)
8010686f:	89 04 24             	mov    %eax,(%esp)
80106872:	e8 59 fe ff ff       	call   801066d0 <walkpgdir>
80106877:	85 c0                	test   %eax,%eax
80106879:	75 cd                	jne    80106848 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010687b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010687e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106883:	5b                   	pop    %ebx
80106884:	5e                   	pop    %esi
80106885:	5f                   	pop    %edi
80106886:	5d                   	pop    %ebp
80106887:	c3                   	ret    
80106888:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010688b:	31 c0                	xor    %eax,%eax
}
8010688d:	5b                   	pop    %ebx
8010688e:	5e                   	pop    %esi
8010688f:	5f                   	pop    %edi
80106890:	5d                   	pop    %ebp
80106891:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106892:	c7 04 24 d0 81 10 80 	movl   $0x801081d0,(%esp)
80106899:	e8 c2 9a ff ff       	call   80100360 <panic>
8010689e:	66 90                	xchg   %ax,%ax

801068a0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068a0:	a1 a4 6d 11 80       	mov    0x80116da4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801068a5:	55                   	push   %ebp
801068a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068ad:	0f 22 d8             	mov    %eax,%cr3
}
801068b0:	5d                   	pop    %ebp
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	83 ec 1c             	sub    $0x1c,%esp
801068c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068cc:	85 f6                	test   %esi,%esi
801068ce:	0f 84 cd 00 00 00    	je     801069a1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068d4:	8b 46 08             	mov    0x8(%esi),%eax
801068d7:	85 c0                	test   %eax,%eax
801068d9:	0f 84 da 00 00 00    	je     801069b9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068df:	8b 7e 04             	mov    0x4(%esi),%edi
801068e2:	85 ff                	test   %edi,%edi
801068e4:	0f 84 c3 00 00 00    	je     801069ad <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801068ea:	e8 21 d9 ff ff       	call   80104210 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068ef:	e8 3c cd ff ff       	call   80103630 <mycpu>
801068f4:	89 c3                	mov    %eax,%ebx
801068f6:	e8 35 cd ff ff       	call   80103630 <mycpu>
801068fb:	89 c7                	mov    %eax,%edi
801068fd:	e8 2e cd ff ff       	call   80103630 <mycpu>
80106902:	83 c7 08             	add    $0x8,%edi
80106905:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106908:	e8 23 cd ff ff       	call   80103630 <mycpu>
8010690d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106910:	ba 67 00 00 00       	mov    $0x67,%edx
80106915:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010691c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106923:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010692a:	83 c1 08             	add    $0x8,%ecx
8010692d:	c1 e9 10             	shr    $0x10,%ecx
80106930:	83 c0 08             	add    $0x8,%eax
80106933:	c1 e8 18             	shr    $0x18,%eax
80106936:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010693c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106943:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106949:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010694e:	e8 dd cc ff ff       	call   80103630 <mycpu>
80106953:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010695a:	e8 d1 cc ff ff       	call   80103630 <mycpu>
8010695f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106964:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106968:	e8 c3 cc ff ff       	call   80103630 <mycpu>
8010696d:	8b 56 08             	mov    0x8(%esi),%edx
80106970:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106976:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106979:	e8 b2 cc ff ff       	call   80103630 <mycpu>
8010697e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106982:	b8 28 00 00 00       	mov    $0x28,%eax
80106987:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010698a:	8b 46 04             	mov    0x4(%esi),%eax
8010698d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106992:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106995:	83 c4 1c             	add    $0x1c,%esp
80106998:	5b                   	pop    %ebx
80106999:	5e                   	pop    %esi
8010699a:	5f                   	pop    %edi
8010699b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010699c:	e9 2f d9 ff ff       	jmp    801042d0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801069a1:	c7 04 24 d6 81 10 80 	movl   $0x801081d6,(%esp)
801069a8:	e8 b3 99 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069ad:	c7 04 24 01 82 10 80 	movl   $0x80108201,(%esp)
801069b4:	e8 a7 99 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069b9:	c7 04 24 ec 81 10 80 	movl   $0x801081ec,(%esp)
801069c0:	e8 9b 99 ff ff       	call   80100360 <panic>
801069c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 2c             	sub    $0x2c,%esp
801069d9:	8b 75 10             	mov    0x10(%ebp),%esi
801069dc:	8b 55 08             	mov    0x8(%ebp),%edx
801069df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069e8:	77 64                	ja     80106a4e <inituvm+0x7e>
801069ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801069ed:	e8 de ba ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
801069f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069f9:	00 
801069fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a01:	00 
80106a02:	89 04 24             	mov    %eax,(%esp)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106a05:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a07:	e8 84 d9 ff ff       	call   80104390 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a15:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106a1c:	00 
80106a1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a21:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a28:	00 
80106a29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a30:	00 
80106a31:	89 14 24             	mov    %edx,(%esp)
80106a34:	e8 d7 fd ff ff       	call   80106810 <mappages>
  memmove(mem, init, sz);
80106a39:	89 75 10             	mov    %esi,0x10(%ebp)
80106a3c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a42:	83 c4 2c             	add    $0x2c,%esp
80106a45:	5b                   	pop    %ebx
80106a46:	5e                   	pop    %esi
80106a47:	5f                   	pop    %edi
80106a48:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a49:	e9 e2 d9 ff ff       	jmp    80104430 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a4e:	c7 04 24 15 82 10 80 	movl   $0x80108215,(%esp)
80106a55:	e8 06 99 ff ff       	call   80100360 <panic>
80106a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a60 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a70:	0f 85 a0 00 00 00    	jne    80106b16 <loaduvm+0xb6>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a76:	8b 75 18             	mov    0x18(%ebp),%esi
80106a79:	31 db                	xor    %ebx,%ebx
80106a7b:	85 f6                	test   %esi,%esi
80106a7d:	75 1a                	jne    80106a99 <loaduvm+0x39>
80106a7f:	eb 7f                	jmp    80106b00 <loaduvm+0xa0>
80106a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a97:	76 67                	jbe    80106b00 <loaduvm+0xa0>
80106a99:	8b 45 0c             	mov    0xc(%ebp),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106aa3:	00 
80106aa4:	01 d8                	add    %ebx,%eax
80106aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106aad:	89 04 24             	mov    %eax,(%esp)
80106ab0:	e8 1b fc ff ff       	call   801066d0 <walkpgdir>
80106ab5:	85 c0                	test   %eax,%eax
80106ab7:	74 51                	je     80106b0a <loaduvm+0xaa>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ab9:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106abb:	bf 00 10 00 00       	mov    $0x1000,%edi
80106ac0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106ac8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106ace:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ad1:	05 00 00 00 80       	add    $0x80000000,%eax
80106ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ada:	8b 45 10             	mov    0x10(%ebp),%eax
80106add:	01 d9                	add    %ebx,%ecx
80106adf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106ae7:	89 04 24             	mov    %eax,(%esp)
80106aea:	e8 a1 ae ff ff       	call   80101990 <readi>
80106aef:	39 f8                	cmp    %edi,%eax
80106af1:	74 95                	je     80106a88 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106af3:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106afb:	5b                   	pop    %ebx
80106afc:	5e                   	pop    %esi
80106afd:	5f                   	pop    %edi
80106afe:	5d                   	pop    %ebp
80106aff:	c3                   	ret    
80106b00:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106b03:	31 c0                	xor    %eax,%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106b0a:	c7 04 24 2f 82 10 80 	movl   $0x8010822f,(%esp)
80106b11:	e8 4a 98 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106b16:	c7 04 24 d0 82 10 80 	movl   $0x801082d0,(%esp)
80106b1d:	e8 3e 98 ff ff       	call   80100360 <panic>
80106b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 2c             	sub    $0x2c,%esp
80106b39:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz > USEREND)
80106b3c:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
80106b42:	0f 87 98 00 00 00    	ja     80106be0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
80106b48:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz > USEREND)
    return 0;
  if(newsz < oldsz)
80106b4e:	0f 82 8e 00 00 00    	jb     80106be2 <allocuvm+0xb2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b54:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b5a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b60:	39 df                	cmp    %ebx,%edi
80106b62:	77 5b                	ja     80106bbf <allocuvm+0x8f>
80106b64:	e9 87 00 00 00       	jmp    80106bf0 <allocuvm+0xc0>
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b77:	00 
80106b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b7f:	00 
80106b80:	89 04 24             	mov    %eax,(%esp)
80106b83:	e8 08 d8 ff ff       	call   80104390 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b88:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b92:	8b 45 08             	mov    0x8(%ebp),%eax
80106b95:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106b9c:	00 
80106b9d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ba4:	00 
80106ba5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106ba9:	89 04 24             	mov    %eax,(%esp)
80106bac:	e8 5f fc ff ff       	call   80106810 <mappages>
80106bb1:	85 c0                	test   %eax,%eax
80106bb3:	78 4b                	js     80106c00 <allocuvm+0xd0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106bb5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbb:	39 df                	cmp    %ebx,%edi
80106bbd:	76 31                	jbe    80106bf0 <allocuvm+0xc0>
    mem = kalloc();
80106bbf:	e8 0c b9 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106bc4:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106bc6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bc8:	75 a6                	jne    80106b70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bca:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
80106bd1:	e8 7a 9a ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bd6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bd9:	77 55                	ja     80106c30 <allocuvm+0x100>
80106bdb:	90                   	nop
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106be0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106be2:	83 c4 2c             	add    $0x2c,%esp
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
80106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bf0:	83 c4 2c             	add    $0x2c,%esp
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80106bf3:	89 f8                	mov    %edi,%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c00:	c7 04 24 65 82 10 80 	movl   $0x80108265,(%esp)
80106c07:	e8 44 9a ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c0c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c0f:	76 0d                	jbe    80106c1e <allocuvm+0xee>
80106c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c14:	89 fa                	mov    %edi,%edx
80106c16:	8b 45 08             	mov    0x8(%ebp),%eax
80106c19:	e8 42 fb ff ff       	call   80106760 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106c1e:	89 34 24             	mov    %esi,(%esp)
80106c21:	e8 fa b6 ff ff       	call   80102320 <kfree>
      return 0;
    }
  }
  return newsz;
}
80106c26:	83 c4 2c             	add    $0x2c,%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106c29:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106c2b:	5b                   	pop    %ebx
80106c2c:	5e                   	pop    %esi
80106c2d:	5f                   	pop    %edi
80106c2e:	5d                   	pop    %ebp
80106c2f:	c3                   	ret    
80106c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c33:	89 fa                	mov    %edi,%edx
80106c35:	8b 45 08             	mov    0x8(%ebp),%eax
80106c38:	e8 23 fb ff ff       	call   80106760 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c3d:	31 c0                	xor    %eax,%eax
80106c3f:	eb a1                	jmp    80106be2 <allocuvm+0xb2>
80106c41:	eb 0d                	jmp    80106c50 <allocshm>
80106c43:	90                   	nop
80106c44:	90                   	nop
80106c45:	90                   	nop
80106c46:	90                   	nop
80106c47:	90                   	nop
80106c48:	90                   	nop
80106c49:	90                   	nop
80106c4a:	90                   	nop
80106c4b:	90                   	nop
80106c4c:	90                   	nop
80106c4d:	90                   	nop
80106c4e:	90                   	nop
80106c4f:	90                   	nop

80106c50 <allocshm>:
  return newsz;
}

int
allocshm(pde_t *pgdir, char *frame)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 2c             	sub    $0x2c,%esp
	struct proc *curproc = myproc();
80106c59:	e8 72 ca ff ff       	call   801036d0 <myproc>
80106c5e:	89 c6                	mov    %eax,%esi
	uint sz = PGROUNDUP(curproc->sz);
80106c60:	8b 00                	mov    (%eax),%eax
80106c62:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106c6e:	8d 8b 00 20 00 00    	lea    0x2000(%ebx),%ecx
80106c74:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106c77:	0f 87 ab 00 00 00    	ja     80106d28 <allocshm+0xd8>
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
80106c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c80:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106c87:	00 
80106c88:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c8c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106c8f:	89 04 24             	mov    %eax,(%esp)
80106c92:	e8 39 fa ff ff       	call   801066d0 <walkpgdir>
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106c97:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c9a:	f6 00 01             	testb  $0x1,(%eax)
80106c9d:	0f 84 92 00 00 00    	je     80106d35 <allocshm+0xe5>
80106ca3:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106ca6:	76 15                	jbe    80106cbd <allocshm+0x6d>
80106ca8:	eb 7e                	jmp    80106d28 <allocshm+0xd8>
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cb0:	81 c3 00 30 00 00    	add    $0x3000,%ebx
80106cb6:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
80106cb9:	72 6d                	jb     80106d28 <allocshm+0xd8>
		sz+=PGSIZE;
80106cbb:	89 fb                	mov    %edi,%ebx
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106cbd:	8b 45 08             	mov    0x8(%ebp),%eax
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
80106cc0:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106cc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ccd:	00 
80106cce:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106cd2:	89 04 24             	mov    %eax,(%esp)
80106cd5:	e8 f6 f9 ff ff       	call   801066d0 <walkpgdir>
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106cda:	f6 00 01             	testb  $0x1,(%eax)
80106cdd:	75 d1                	jne    80106cb0 <allocshm+0x60>
80106cdf:	8d 8b 00 30 00 00    	lea    0x3000(%ebx),%ecx
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106ce5:	39 4e 7c             	cmp    %ecx,0x7c(%esi)
80106ce8:	72 3e                	jb     80106d28 <allocshm+0xd8>
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
80106cea:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ced:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106cf4:	00 
80106cf5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cfc:	00 
80106cfd:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106d01:	05 00 00 00 80       	add    $0x80000000,%eax
80106d06:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0d:	89 04 24             	mov    %eax,(%esp)
80106d10:	e8 fb fa ff ff       	call   80106810 <mappages>
80106d15:	85 c0                	test   %eax,%eax
80106d17:	78 20                	js     80106d39 <allocshm+0xe9>
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106d19:	83 c4 2c             	add    $0x2c,%esp
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
80106d1c:	89 f8                	mov    %edi,%eax
}
80106d1e:	5b                   	pop    %ebx
80106d1f:	5e                   	pop    %esi
80106d20:	5f                   	pop    %edi
80106d21:	5d                   	pop    %ebp
80106d22:	c3                   	ret    
80106d23:	90                   	nop
80106d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106d2d:	83 c4 2c             	add    $0x2c,%esp
80106d30:	5b                   	pop    %ebx
80106d31:	5e                   	pop    %esi
80106d32:	5f                   	pop    %edi
80106d33:	5d                   	pop    %ebp
80106d34:	c3                   	ret    

int
allocshm(pde_t *pgdir, char *frame)
{
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
80106d35:	89 df                	mov    %ebx,%edi
80106d37:	eb ac                	jmp    80106ce5 <allocshm+0x95>
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
80106d39:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
80106d40:	e8 0b 99 ff ff       	call   80100650 <cprintf>
		return -1;
80106d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d4a:	eb e1                	jmp    80106d2d <allocshm+0xdd>
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d50 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d59:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d5c:	39 d1                	cmp    %edx,%ecx
80106d5e:	73 08                	jae    80106d68 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d60:	5d                   	pop    %ebp
80106d61:	e9 fa f9 ff ff       	jmp    80106760 <deallocuvm.part.0>
80106d66:	66 90                	xchg   %ax,%ax
80106d68:	89 d0                	mov    %edx,%eax
80106d6a:	5d                   	pop    %ebp
80106d6b:	c3                   	ret    
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	56                   	push   %esi
80106d74:	53                   	push   %ebx
80106d75:	83 ec 10             	sub    $0x10,%esp
80106d78:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d7b:	85 f6                	test   %esi,%esi
80106d7d:	74 59                	je     80106dd8 <freevm+0x68>
80106d7f:	31 c9                	xor    %ecx,%ecx
80106d81:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d86:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d88:	31 db                	xor    %ebx,%ebx
80106d8a:	e8 d1 f9 ff ff       	call   80106760 <deallocuvm.part.0>
80106d8f:	eb 12                	jmp    80106da3 <freevm+0x33>
80106d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d98:	83 c3 01             	add    $0x1,%ebx
80106d9b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106da1:	74 27                	je     80106dca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106da3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106da6:	f6 c2 01             	test   $0x1,%dl
80106da9:	74 ed                	je     80106d98 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106dab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106db1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106db4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106dba:	89 14 24             	mov    %edx,(%esp)
80106dbd:	e8 5e b5 ff ff       	call   80102320 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106dc2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106dc8:	75 d9                	jne    80106da3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106dca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106dcd:	83 c4 10             	add    $0x10,%esp
80106dd0:	5b                   	pop    %ebx
80106dd1:	5e                   	pop    %esi
80106dd2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106dd3:	e9 48 b5 ff ff       	jmp    80102320 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106dd8:	c7 04 24 81 82 10 80 	movl   $0x80108281,(%esp)
80106ddf:	e8 7c 95 ff ff       	call   80100360 <panic>
80106de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106df0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	56                   	push   %esi
80106df4:	53                   	push   %ebx
80106df5:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106df8:	e8 d3 b6 ff ff       	call   801024d0 <kalloc>
80106dfd:	85 c0                	test   %eax,%eax
80106dff:	89 c6                	mov    %eax,%esi
80106e01:	74 75                	je     80106e78 <setupkvm+0x88>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106e03:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e0a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e0b:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106e10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e17:	00 
80106e18:	89 04 24             	mov    %eax,(%esp)
80106e1b:	e8 70 d5 ff ff       	call   80104390 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e20:	8b 53 0c             	mov    0xc(%ebx),%edx
80106e23:	8b 43 04             	mov    0x4(%ebx),%eax
80106e26:	89 34 24             	mov    %esi,(%esp)
80106e29:	89 54 24 10          	mov    %edx,0x10(%esp)
80106e2d:	8b 53 08             	mov    0x8(%ebx),%edx
80106e30:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106e34:	29 c2                	sub    %eax,%edx
80106e36:	8b 03                	mov    (%ebx),%eax
80106e38:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e40:	e8 cb f9 ff ff       	call   80106810 <mappages>
80106e45:	85 c0                	test   %eax,%eax
80106e47:	78 17                	js     80106e60 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e49:	83 c3 10             	add    $0x10,%ebx
80106e4c:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106e52:	72 cc                	jb     80106e20 <setupkvm+0x30>
80106e54:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106e56:	83 c4 20             	add    $0x20,%esp
80106e59:	5b                   	pop    %ebx
80106e5a:	5e                   	pop    %esi
80106e5b:	5d                   	pop    %ebp
80106e5c:	c3                   	ret    
80106e5d:	8d 76 00             	lea    0x0(%esi),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e60:	89 34 24             	mov    %esi,(%esp)
80106e63:	e8 08 ff ff ff       	call   80106d70 <freevm>
      return 0;
    }
  return pgdir;
}
80106e68:	83 c4 20             	add    $0x20,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e6b:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106e6d:	5b                   	pop    %ebx
80106e6e:	5e                   	pop    %esi
80106e6f:	5d                   	pop    %ebp
80106e70:	c3                   	ret    
80106e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106e78:	31 c0                	xor    %eax,%eax
80106e7a:	eb da                	jmp    80106e56 <setupkvm+0x66>
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e86:	e8 65 ff ff ff       	call   80106df0 <setupkvm>
80106e8b:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e90:	05 00 00 00 80       	add    $0x80000000,%eax
80106e95:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106e98:	c9                   	leave  
80106e99:	c3                   	ret    
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ea0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ea9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106eb0:	00 
80106eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb8:	89 04 24             	mov    %eax,(%esp)
80106ebb:	e8 10 f8 ff ff       	call   801066d0 <walkpgdir>
  if(pte == 0)
80106ec0:	85 c0                	test   %eax,%eax
80106ec2:	74 05                	je     80106ec9 <clearpteu+0x29>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ec4:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ec7:	c9                   	leave  
80106ec8:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106ec9:	c7 04 24 92 82 10 80 	movl   $0x80108292,(%esp)
80106ed0:	e8 8b 94 ff ff       	call   80100360 <panic>
80106ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ee0 <resetpteu>:
  *pte &= ~PTE_U;
}

void
resetpteu(pde_t *pgdir, char *uva)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80106ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ef0:	00 
80106ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef8:	89 04 24             	mov    %eax,(%esp)
80106efb:	e8 d0 f7 ff ff       	call   801066d0 <walkpgdir>
  if(pte == 0)
80106f00:	85 c0                	test   %eax,%eax
80106f02:	74 05                	je     80106f09 <resetpteu+0x29>
    panic("clearpteu");
  *pte &= PTE_U;
80106f04:	83 20 04             	andl   $0x4,(%eax)
}
80106f07:	c9                   	leave  
80106f08:	c3                   	ret    
resetpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f09:	c7 04 24 92 82 10 80 	movl   $0x80108292,(%esp)
80106f10:	e8 4b 94 ff ff       	call   80100360 <panic>
80106f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <copyuvm>:
}
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint tstack)// FOR CS153 lab2 part1
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f29:	e8 c2 fe ff ff       	call   80106df0 <setupkvm>
80106f2e:	85 c0                	test   %eax,%eax
80106f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f33:	0f 84 7a 01 00 00    	je     801070b3 <copyuvm+0x193>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f39:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3c:	85 d2                	test   %edx,%edx
80106f3e:	0f 84 bc 00 00 00    	je     80107000 <copyuvm+0xe0>
80106f44:	31 db                	xor    %ebx,%ebx
80106f46:	eb 51                	jmp    80106f99 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f48:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f4e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f55:	00 
80106f56:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106f5a:	89 04 24             	mov    %eax,(%esp)
80106f5d:	e8 ce d4 ff ff       	call   80104430 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f65:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106f6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106f6f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f76:	00 
80106f77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106f7b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f82:	89 04 24             	mov    %eax,(%esp)
80106f85:	e8 86 f8 ff ff       	call   80106810 <mappages>
80106f8a:	85 c0                	test   %eax,%eax
80106f8c:	78 58                	js     80106fe6 <copyuvm+0xc6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f94:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106f97:	76 67                	jbe    80107000 <copyuvm+0xe0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f99:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106fa3:	00 
80106fa4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106fa8:	89 04 24             	mov    %eax,(%esp)
80106fab:	e8 20 f7 ff ff       	call   801066d0 <walkpgdir>
80106fb0:	85 c0                	test   %eax,%eax
80106fb2:	0f 84 0e 01 00 00    	je     801070c6 <copyuvm+0x1a6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106fb8:	8b 30                	mov    (%eax),%esi
80106fba:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106fc0:	0f 84 f4 00 00 00    	je     801070ba <copyuvm+0x19a>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fc6:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106fc8:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106fce:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fd1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106fd7:	e8 f4 b4 ff ff       	call   801024d0 <kalloc>
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	89 c6                	mov    %eax,%esi
80106fe0:	0f 85 62 ff ff ff    	jne    80106f48 <copyuvm+0x28>
      goto bad;
		}
  return d;

bad:
  freevm(d);
80106fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fe9:	89 04 24             	mov    %eax,(%esp)
80106fec:	e8 7f fd ff ff       	call   80106d70 <freevm>
  return 0;
80106ff1:	31 c0                	xor    %eax,%eax
}
80106ff3:	83 c4 2c             	add    $0x2c,%esp
80106ff6:	5b                   	pop    %ebx
80106ff7:	5e                   	pop    %esi
80106ff8:	5f                   	pop    %edi
80106ff9:	5d                   	pop    %ebp
80106ffa:	c3                   	ret    
80106ffb:	90                   	nop
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (tstack == 0 || tstack >= USEREND) return d; // For CS153 lab2 part1
80107000:	8b 45 10             	mov    0x10(%ebp),%eax
80107003:	8b 5d 10             	mov    0x10(%ebp),%ebx
80107006:	85 c0                	test   %eax,%eax
80107008:	7f 54                	jg     8010705e <copyuvm+0x13e>
8010700a:	e9 99 00 00 00       	jmp    801070a8 <copyuvm+0x188>
8010700f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107010:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107016:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010701d:	00 
8010701e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80107022:	89 04 24             	mov    %eax,(%esp)
80107025:	e8 06 d4 ff ff       	call   80104430 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010702a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010702d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80107033:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107037:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010703e:	00 
8010703f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80107043:	89 44 24 10          	mov    %eax,0x10(%esp)
80107047:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704a:	89 04 24             	mov    %eax,(%esp)
8010704d:	e8 be f7 ff ff       	call   80106810 <mappages>
80107052:	85 c0                	test   %eax,%eax
80107054:	78 90                	js     80106fe6 <copyuvm+0xc6>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (tstack == 0 || tstack >= USEREND) return d; // For CS153 lab2 part1
  for(i = tstack; i < USEREND; i += PGSIZE){
80107056:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010705c:	78 4a                	js     801070a8 <copyuvm+0x188>
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
8010705e:	8b 45 08             	mov    0x8(%ebp),%eax
80107061:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107068:	00 
80107069:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010706d:	89 04 24             	mov    %eax,(%esp)
80107070:	e8 5b f6 ff ff       	call   801066d0 <walkpgdir>
80107075:	85 c0                	test   %eax,%eax
80107077:	74 4d                	je     801070c6 <copyuvm+0x1a6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107079:	8b 30                	mov    (%eax),%esi
8010707b:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107081:	74 37                	je     801070ba <copyuvm+0x19a>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107083:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80107085:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
8010708b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = tstack; i < USEREND; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010708e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80107094:	e8 37 b4 ff ff       	call   801024d0 <kalloc>
80107099:	85 c0                	test   %eax,%eax
8010709b:	89 c6                	mov    %eax,%esi
8010709d:	0f 85 6d ff ff ff    	jne    80107010 <copyuvm+0xf0>
801070a3:	e9 3e ff ff ff       	jmp    80106fe6 <copyuvm+0xc6>
801070a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801070ab:	83 c4 2c             	add    $0x2c,%esp
801070ae:	5b                   	pop    %ebx
801070af:	5e                   	pop    %esi
801070b0:	5f                   	pop    %edi
801070b1:	5d                   	pop    %ebp
801070b2:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801070b3:	31 c0                	xor    %eax,%eax
801070b5:	e9 39 ff ff ff       	jmp    80106ff3 <copyuvm+0xd3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801070ba:	c7 04 24 b6 82 10 80 	movl   $0x801082b6,(%esp)
801070c1:	e8 9a 92 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070c6:	c7 04 24 9c 82 10 80 	movl   $0x8010829c,(%esp)
801070cd:	e8 8e 92 ff ff       	call   80100360 <panic>
801070d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801070e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801070f0:	00 
801070f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801070f5:	8b 45 08             	mov    0x8(%ebp),%eax
801070f8:	89 04 24             	mov    %eax,(%esp)
801070fb:	e8 d0 f5 ff ff       	call   801066d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107100:	8b 00                	mov    (%eax),%eax
80107102:	89 c2                	mov    %eax,%edx
80107104:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80107107:	83 fa 05             	cmp    $0x5,%edx
8010710a:	75 0c                	jne    80107118 <uva2ka+0x38>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010710c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107111:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107116:	c9                   	leave  
80107117:	c3                   	ret    

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107118:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
8010711a:	c9                   	leave  
8010711b:	c3                   	ret    
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107120 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010712c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010712f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107132:	85 db                	test   %ebx,%ebx
80107134:	75 3a                	jne    80107170 <copyout+0x50>
80107136:	eb 68                	jmp    801071a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107138:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010713b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010713d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107141:	29 ca                	sub    %ecx,%edx
80107143:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107149:	39 da                	cmp    %ebx,%edx
8010714b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010714e:	29 f1                	sub    %esi,%ecx
80107150:	01 c8                	add    %ecx,%eax
80107152:	89 54 24 08          	mov    %edx,0x8(%esp)
80107156:	89 04 24             	mov    %eax,(%esp)
80107159:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010715c:	e8 cf d2 ff ff       	call   80104430 <memmove>
    len -= n;
    buf += n;
80107161:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107164:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010716a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010716c:	29 d3                	sub    %edx,%ebx
8010716e:	74 30                	je     801071a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107170:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107173:	89 ce                	mov    %ecx,%esi
80107175:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010717b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010717f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107182:	89 04 24             	mov    %eax,(%esp)
80107185:	e8 56 ff ff ff       	call   801070e0 <uva2ka>
    if(pa0 == 0)
8010718a:	85 c0                	test   %eax,%eax
8010718c:	75 aa                	jne    80107138 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010718e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107196:	5b                   	pop    %ebx
80107197:	5e                   	pop    %esi
80107198:	5f                   	pop    %edi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
8010719b:	90                   	nop
8010719c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071a0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801071a3:	31 c0                	xor    %eax,%eax
}
801071a5:	5b                   	pop    %ebx
801071a6:	5e                   	pop    %esi
801071a7:	5f                   	pop    %edi
801071a8:	5d                   	pop    %ebp
801071a9:	c3                   	ret    
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071b0 <addstackpage>:
int // For CS153 lab2 part1 
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
801071b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
801071bc:	e8 0f c5 ff ff       	call   801036d0 <myproc>
801071c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i=0;i<rep;i++){
801071c4:	8b 45 10             	mov    0x10(%ebp),%eax
801071c7:	85 c0                	test   %eax,%eax
801071c9:	74 56                	je     80107221 <addstackpage+0x71>
801071cb:	31 f6                	xor    %esi,%esi
801071cd:	eb 27                	jmp    801071f6 <addstackpage+0x46>
801071cf:	90                   	nop
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
801071d0:	f6 00 01             	testb  $0x1,(%eax)
801071d3:	75 42                	jne    80107217 <addstackpage+0x67>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
801071d5:	8b 45 08             	mov    0x8(%ebp),%eax
801071d8:	89 7c 24 08          	mov    %edi,0x8(%esp)
801071dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801071e0:	89 04 24             	mov    %eax,(%esp)
801071e3:	e8 48 f9 ff ff       	call   80106b30 <allocuvm>
801071e8:	85 c0                	test   %eax,%eax
801071ea:	74 2b                	je     80107217 <addstackpage+0x67>
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
801071ec:	83 c6 01             	add    $0x1,%esi
801071ef:	3b 75 10             	cmp    0x10(%ebp),%esi
801071f2:	74 34                	je     80107228 <addstackpage+0x78>
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
801071f4:	89 df                	mov    %ebx,%edi
801071f6:	8b 45 08             	mov    0x8(%ebp),%eax
801071f9:	8d 9f 00 f0 ff ff    	lea    -0x1000(%edi),%ebx
801071ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107206:	00 
80107207:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010720b:	89 04 24             	mov    %eax,(%esp)
8010720e:	e8 bd f4 ff ff       	call   801066d0 <walkpgdir>
80107213:	85 c0                	test   %eax,%eax
80107215:	75 b9                	jne    801071d0 <addstackpage+0x20>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
80107217:	83 c4 1c             	add    $0x1c,%esp
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
8010721a:	31 c0                	xor    %eax,%eax
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
8010721c:	5b                   	pop    %ebx
8010721d:	5e                   	pop    %esi
8010721e:	5f                   	pop    %edi
8010721f:	5d                   	pop    %ebp
80107220:	c3                   	ret    
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
80107221:	89 fb                	mov    %edi,%ebx
80107223:	90                   	nop
80107224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
80107228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010722b:	89 58 7c             	mov    %ebx,0x7c(%eax)
  return 1;
}
8010722e:	83 c4 1c             	add    $0x1c,%esp
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
80107231:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107236:	5b                   	pop    %ebx
80107237:	5e                   	pop    %esi
80107238:	5f                   	pop    %edi
80107239:	5d                   	pop    %ebp
8010723a:	c3                   	ret    
8010723b:	66 90                	xchg   %ax,%ax
8010723d:	66 90                	xchg   %ax,%ax
8010723f:	90                   	nop

80107240 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107246:	c7 44 24 04 f3 82 10 	movl   $0x801082f3,0x4(%esp)
8010724d:	80 
8010724e:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107255:	e8 06 cf ff ff       	call   80104160 <initlock>
  acquire(&(shm_table.lock));
8010725a:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107261:	e8 ea cf ff ff       	call   80104250 <acquire>
80107266:	b8 f4 6d 11 80       	mov    $0x80116df4,%eax
8010726b:	90                   	nop
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80107270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107276:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80107279:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80107280:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80107287:	3d f4 70 11 80       	cmp    $0x801170f4,%eax
8010728c:	75 e2                	jne    80107270 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
8010728e:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107295:	e8 a6 d0 ff ff       	call   80104340 <release>
}
8010729a:	c9                   	leave  
8010729b:	c3                   	ret    
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072a0 <shm_create>:

int shm_create(int table_id) {
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 2c             	sub    $0x2c,%esp
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
801072a9:	e8 22 c4 ff ff       	call   801036d0 <myproc>
	if(table_id < 0 || table_id >= 64){
801072ae:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
}

int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
801072b2:	89 c7                	mov    %eax,%edi
	if(table_id < 0 || table_id >= 64){
801072b4:	0f 87 f1 00 00 00    	ja     801073ab <shm_create+0x10b>
801072ba:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
801072bc:	8b b4 df 80 00 00 00 	mov    0x80(%edi,%ebx,8),%esi
801072c3:	83 fe ff             	cmp    $0xffffffff,%esi
801072c6:	74 30                	je     801072f8 <shm_create+0x58>
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
801072c8:	83 c3 01             	add    $0x1,%ebx
801072cb:	83 fb 04             	cmp    $0x4,%ebx
801072ce:	75 ec                	jne    801072bc <shm_create+0x1c>
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
801072d0:	8b 47 10             	mov    0x10(%edi),%eax
		return -1;
801072d3:	be ff ff ff ff       	mov    $0xffffffff,%esi
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
801072d8:	c7 04 24 2e 83 10 80 	movl   $0x8010832e,(%esp)
801072df:	89 44 24 04          	mov    %eax,0x4(%esp)
801072e3:	e8 68 93 ff ff       	call   80100650 <cprintf>
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
801072e8:	83 c4 2c             	add    $0x2c,%esp
801072eb:	89 f0                	mov    %esi,%eax
801072ed:	5b                   	pop    %ebx
801072ee:	5e                   	pop    %esi
801072ef:	5f                   	pop    %edi
801072f0:	5d                   	pop    %ebp
801072f1:	c3                   	ret    
801072f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
801072f8:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801072ff:	e8 4c cf ff ff       	call   80104250 <acquire>
	if(shm_table.shm_pages[table_id].refcnt != 0){
80107304:	8b 45 08             	mov    0x8(%ebp),%eax
80107307:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010730a:	8d 14 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edx
80107311:	8b 42 0c             	mov    0xc(%edx),%eax
80107314:	85 c0                	test   %eax,%eax
80107316:	75 68                	jne    80107380 <shm_create+0xe0>
80107318:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
8010731b:	e8 b0 b1 ff ff       	call   801024d0 <kalloc>
80107320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107323:	85 c0                	test   %eax,%eax
80107325:	89 c1                	mov    %eax,%ecx
80107327:	0f 84 9b 00 00 00    	je     801073c8 <shm_create+0x128>
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
8010732d:	8b 45 08             	mov    0x8(%ebp),%eax
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
80107330:	89 de                	mov    %ebx,%esi
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
	shm_table.shm_pages[table_id].refcnt++;
80107332:	83 42 0c 01          	addl   $0x1,0xc(%edx)
80107336:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
80107339:	89 42 04             	mov    %eax,0x4(%edx)
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
8010733c:	89 0c 24             	mov    %ecx,(%esp)
8010733f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107346:	00 
80107347:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010734e:	00 
8010734f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107352:	e8 39 d0 ff ff       	call   80104390 <memset>
	shm_table.shm_pages[table_id].frame = memory;
80107357:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010735a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010735d:	89 4a 08             	mov    %ecx,0x8(%edx)
	release(&(shm_table.lock));
80107360:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107367:	e8 d4 cf ff ff       	call   80104340 <release>
	curproc->pages[page_id].id = table_id;
8010736c:	8b 45 08             	mov    0x8(%ebp),%eax
8010736f:	89 84 df 80 00 00 00 	mov    %eax,0x80(%edi,%ebx,8)
	return page_id;
}
80107376:	83 c4 2c             	add    $0x2c,%esp
80107379:	89 f0                	mov    %esi,%eax
8010737b:	5b                   	pop    %ebx
8010737c:	5e                   	pop    %esi
8010737d:	5f                   	pop    %edi
8010737e:	5d                   	pop    %ebp
8010737f:	c3                   	ret    
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[table_id].refcnt != 0){
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
80107380:	8b 45 08             	mov    0x8(%ebp),%eax
80107383:	89 44 24 08          	mov    %eax,0x8(%esp)
80107387:	8b 47 10             	mov    0x10(%edi),%eax
8010738a:	c7 04 24 64 83 10 80 	movl   $0x80108364,(%esp)
80107391:	89 44 24 04          	mov    %eax,0x4(%esp)
80107395:	e8 b6 92 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010739a:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801073a1:	e8 9a cf ff ff       	call   80104340 <release>
		return -1;
801073a6:	e9 3d ff ff ff       	jmp    801072e8 <shm_create+0x48>
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
801073ab:	8b 40 10             	mov    0x10(%eax),%eax
		return -1;
801073ae:	be ff ff ff ff       	mov    $0xffffffff,%esi
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
801073b3:	c7 04 24 fc 82 10 80 	movl   $0x801082fc,(%esp)
801073ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801073be:	e8 8d 92 ff ff       	call   80100650 <cprintf>
		return -1;
801073c3:	e9 20 ff ff ff       	jmp    801072e8 <shm_create+0x48>
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
801073c8:	8b 47 10             	mov    0x10(%edi),%eax
801073cb:	c7 04 24 12 83 10 80 	movl   $0x80108312,(%esp)
801073d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801073d6:	e8 75 92 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
801073db:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801073e2:	e8 59 cf ff ff       	call   80104340 <release>
		return -1;
801073e7:	e9 fc fe ff ff       	jmp    801072e8 <shm_create+0x48>
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073f0 <shm_open>:
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
int shm_open(int id, char **pointer) {
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
801073f9:	8b 75 08             	mov    0x8(%ebp),%esi
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
801073fc:	e8 cf c2 ff ff       	call   801036d0 <myproc>
	if(id < 0 || id >= 64){
80107401:	83 fe 3f             	cmp    $0x3f,%esi
	return page_id;
}
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
80107404:	89 c7                	mov    %eax,%edi
	if(id < 0 || id >= 64){
80107406:	0f 87 0c 01 00 00    	ja     80107518 <shm_open+0x128>
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
8010740c:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
	if (shm_table.shm_pages[id].refcnt == 0){
80107413:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
80107415:	e8 36 ce ff ff       	call   80104250 <acquire>
	if (shm_table.shm_pages[id].refcnt == 0){
8010741a:	8d 04 76             	lea    (%esi,%esi,2),%eax
8010741d:	8b 14 85 fc 6d 11 80 	mov    -0x7fee9204(,%eax,4),%edx
80107424:	85 d2                	test   %edx,%edx
80107426:	74 58                	je     80107480 <shm_open+0x90>
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
80107428:	39 b4 df 80 00 00 00 	cmp    %esi,0x80(%edi,%ebx,8)
8010742f:	0f 84 8d 00 00 00    	je     801074c2 <shm_open+0xd2>
			return -1;
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
80107435:	83 c3 01             	add    $0x1,%ebx
80107438:	83 fb 04             	cmp    $0x4,%ebx
8010743b:	75 eb                	jne    80107428 <shm_open+0x38>
8010743d:	30 db                	xor    %bl,%bl
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
				if(curproc->pages[page_id].id == -1) break;
8010743f:	83 bc df 80 00 00 00 	cmpl   $0xffffffff,0x80(%edi,%ebx,8)
80107446:	ff 
80107447:	0f 84 e5 00 00 00    	je     80107532 <shm_open+0x142>
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
8010744d:	83 c3 01             	add    $0x1,%ebx
80107450:	83 fb 04             	cmp    $0x4,%ebx
80107453:	75 ea                	jne    8010743f <shm_open+0x4f>
				if(curproc->pages[page_id].id == -1) break;
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
80107455:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010745c:	e8 df ce ff ff       	call   80104340 <release>
      	cprintf("Proc: %d, process is full\n",curproc->pid);
80107461:	8b 47 10             	mov    0x10(%edi),%eax
80107464:	c7 04 24 2e 83 10 80 	movl   $0x8010832e,(%esp)
8010746b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010746f:	e8 dc 91 ff ff       	call   80100650 <cprintf>
				return -1; 
80107474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107479:	eb 6d                	jmp    801074e8 <shm_open+0xf8>
8010747b:	90                   	nop
8010747c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
80107480:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107487:	e8 b4 ce ff ff       	call   80104340 <release>
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
8010748c:	89 74 24 08          	mov    %esi,0x8(%esp)
80107490:	8b 47 10             	mov    0x10(%edi),%eax
80107493:	c7 04 24 84 83 10 80 	movl   $0x80108384,(%esp)
8010749a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010749e:	e8 ad 91 ff ff       	call   80100650 <cprintf>
		if((page_id = shm_create(id))==-1){
801074a3:	89 34 24             	mov    %esi,(%esp)
801074a6:	e8 f5 fd ff ff       	call   801072a0 <shm_create>
801074ab:	83 f8 ff             	cmp    $0xffffffff,%eax
801074ae:	89 c3                	mov    %eax,%ebx
801074b0:	0f 84 9f 00 00 00    	je     80107555 <shm_open+0x165>
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
			return -1;
		}
		acquire(&(shm_table.lock));
801074b6:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801074bd:	e8 8e cd ff ff       	call   80104250 <acquire>
801074c2:	8d 1c df             	lea    (%edi,%ebx,8),%ebx
			curproc->pages[page_id].id = id;
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
801074c5:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801074cb:	85 c0                	test   %eax,%eax
801074cd:	74 21                	je     801074f0 <shm_open+0x100>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
  }
	release(&(shm_table.lock));
801074cf:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801074d6:	e8 65 ce ff ff       	call   80104340 <release>
	*pointer = curproc->pages[page_id].vaddr;
801074db:	8b 45 0c             	mov    0xc(%ebp),%eax
801074de:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801074e4:	89 10                	mov    %edx,(%eax)
	return 0;
801074e6:	31 c0                	xor    %eax,%eax
}
801074e8:	83 c4 1c             	add    $0x1c,%esp
801074eb:	5b                   	pop    %ebx
801074ec:	5e                   	pop    %esi
801074ed:	5f                   	pop    %edi
801074ee:	5d                   	pop    %ebp
801074ef:	c3                   	ret    
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
801074f0:	8d 04 76             	lea    (%esi,%esi,2),%eax
801074f3:	8b 04 85 f8 6d 11 80 	mov    -0x7fee9208(,%eax,4),%eax
801074fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801074fe:	8b 47 04             	mov    0x4(%edi),%eax
80107501:	89 04 24             	mov    %eax,(%esp)
80107504:	e8 47 f7 ff ff       	call   80106c50 <allocshm>
80107509:	83 f8 ff             	cmp    $0xffffffff,%eax
8010750c:	74 68                	je     80107576 <shm_open+0x186>
			release(&(shm_table.lock));
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
8010750e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80107514:	eb b9                	jmp    801074cf <shm_open+0xdf>
80107516:	66 90                	xchg   %ax,%ax
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
80107518:	8b 40 10             	mov    0x10(%eax),%eax
8010751b:	c7 04 24 fc 82 10 80 	movl   $0x801082fc,(%esp)
80107522:	89 44 24 04          	mov    %eax,0x4(%esp)
80107526:	e8 25 91 ff ff       	call   80100650 <cprintf>
		return -1;
8010752b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107530:	eb b6                	jmp    801074e8 <shm_open+0xf8>
80107532:	8d 04 df             	lea    (%edi,%ebx,8),%eax
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
      	cprintf("Proc: %d, process is full\n",curproc->pid);
				return -1; 
    	}
			curproc->pages[page_id].id = id;
80107535:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
			curproc->pages[page_id].vaddr = 0;
8010753b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80107542:	00 00 00 
			shm_table.shm_pages[id].refcnt++;
80107545:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107548:	83 04 85 fc 6d 11 80 	addl   $0x1,-0x7fee9204(,%eax,4)
8010754f:	01 
80107550:	e9 6d ff ff ff       	jmp    801074c2 <shm_open+0xd2>
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
		if((page_id = shm_create(id))==-1){
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
80107555:	89 74 24 08          	mov    %esi,0x8(%esp)
80107559:	8b 47 10             	mov    0x10(%edi),%eax
8010755c:	c7 04 24 a4 83 10 80 	movl   $0x801083a4,(%esp)
80107563:	89 44 24 04          	mov    %eax,0x4(%esp)
80107567:	e8 e4 90 ff ff       	call   80100650 <cprintf>
			return -1;
8010756c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107571:	e9 72 ff ff ff       	jmp    801074e8 <shm_open+0xf8>
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
			release(&(shm_table.lock));
80107576:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010757d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107580:	e8 bb cd ff ff       	call   80104340 <release>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
80107585:	8b 57 10             	mov    0x10(%edi),%edx
80107588:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
8010758f:	89 54 24 04          	mov    %edx,0x4(%esp)
80107593:	e8 b8 90 ff ff       	call   80100650 <cprintf>
			return -1;
80107598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010759b:	e9 48 ff ff ff       	jmp    801074e8 <shm_open+0xf8>

801075a0 <shm_close>:
	*pointer = curproc->pages[page_id].vaddr;
	return 0;
}


int shm_close(int id) {
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
801075a9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801075ac:	e8 1f c1 ff ff       	call   801036d0 <myproc>
	if(id < 0 || id >= 64){
801075b1:	83 ff 3f             	cmp    $0x3f,%edi


int shm_close(int id) {
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801075b4:	89 c6                	mov    %eax,%esi
	if(id < 0 || id >= 64){
801075b6:	0f 87 72 01 00 00    	ja     8010772e <shm_close+0x18e>
801075bc:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == id) break;
801075be:	39 bc de 80 00 00 00 	cmp    %edi,0x80(%esi,%ebx,8)
801075c5:	74 29                	je     801075f0 <shm_close+0x50>
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
801075c7:	83 c3 01             	add    $0x1,%ebx
801075ca:	83 fb 04             	cmp    $0x4,%ebx
801075cd:	75 ef                	jne    801075be <shm_close+0x1e>
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
801075cf:	8b 46 10             	mov    0x10(%esi),%eax
801075d2:	c7 04 24 28 84 10 80 	movl   $0x80108428,(%esp)
801075d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801075dd:	e8 6e 90 ff ff       	call   80100650 <cprintf>
		return -1;
801075e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
801075e7:	83 c4 1c             	add    $0x1c,%esp
801075ea:	5b                   	pop    %ebx
801075eb:	5e                   	pop    %esi
801075ec:	5f                   	pop    %edi
801075ed:	5d                   	pop    %ebp
801075ee:	c3                   	ret    
801075ef:	90                   	nop
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
801075f0:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801075f7:	e8 54 cc ff ff       	call   80104250 <acquire>
	if(shm_table.shm_pages[id].refcnt <= 0){
801075fc:	8d 04 7f             	lea    (%edi,%edi,2),%eax
801075ff:	8d 3c 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edi
80107606:	8b 47 0c             	mov    0xc(%edi),%eax
80107609:	85 c0                	test   %eax,%eax
8010760b:	0f 8e cb 00 00 00    	jle    801076dc <shm_close+0x13c>
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
80107611:	83 e8 01             	sub    $0x1,%eax
80107614:	89 47 0c             	mov    %eax,0xc(%edi)
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
80107617:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010761e:	00 
8010761f:	8b 47 08             	mov    0x8(%edi),%eax
80107622:	89 44 24 04          	mov    %eax,0x4(%esp)
80107626:	8b 46 04             	mov    0x4(%esi),%eax
80107629:	89 04 24             	mov    %eax,(%esp)
8010762c:	e8 9f f0 ff ff       	call   801066d0 <walkpgdir>
	if(pte == 0){
80107631:	85 c0                	test   %eax,%eax
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
80107633:	89 c2                	mov    %eax,%edx
	if(pte == 0){
80107635:	0f 84 cd 00 00 00    	je     80107708 <shm_close+0x168>
		cprintf("Proc: %d, free memory error 1\n",curproc->pid);
		release(&(shm_table.lock));
		return 0;
	}
	if(shm_table.shm_pages[id].refcnt == 0){
8010763b:	8b 47 0c             	mov    0xc(%edi),%eax
8010763e:	85 c0                	test   %eax,%eax
80107640:	75 2f                	jne    80107671 <shm_close+0xd1>
		shm_table.shm_pages[id].id =0;
80107642:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
		if((*pte & PTE_P) == 0){
80107649:	8b 0a                	mov    (%edx),%ecx
8010764b:	f6 c1 01             	test   $0x1,%cl
8010764e:	74 58                	je     801076a8 <shm_close+0x108>
			cprintf("Proc: %d, free memory error 2\n",curproc->pid);
			shm_table.shm_pages[id].frame =0;
			release(&(shm_table.lock));
			return 0;
		}
		kfree(P2V(PTE_ADDR(*pte)));
80107650:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107656:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
8010765c:	89 0c 24             	mov    %ecx,(%esp)
8010765f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107662:	e8 b9 ac ff ff       	call   80102320 <kfree>
		shm_table.shm_pages[id].frame =0;
80107667:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010766a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
	}
	*pte = 0;
80107671:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	release(&(shm_table.lock));
80107677:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010767e:	e8 bd cc ff ff       	call   80104340 <release>
80107683:	8d 04 de             	lea    (%esi,%ebx,8),%eax
	curproc->pages[page_id].id = -1;
80107686:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
8010768d:	ff ff ff 
	curproc->pages[page_id].vaddr = 0;
80107690:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80107697:	00 00 00 
	return 0;
}
8010769a:	83 c4 1c             	add    $0x1c,%esp
	}
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
8010769d:	31 c0                	xor    %eax,%eax
}
8010769f:	5b                   	pop    %ebx
801076a0:	5e                   	pop    %esi
801076a1:	5f                   	pop    %edi
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
801076a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return 0;
	}
	if(shm_table.shm_pages[id].refcnt == 0){
		shm_table.shm_pages[id].id =0;
		if((*pte & PTE_P) == 0){
			cprintf("Proc: %d, free memory error 2\n",curproc->pid);
801076a8:	8b 56 10             	mov    0x10(%esi),%edx
801076ab:	c7 04 24 08 84 10 80 	movl   $0x80108408,(%esp)
801076b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801076b9:	e8 92 8f ff ff       	call   80100650 <cprintf>
			shm_table.shm_pages[id].frame =0;
801076be:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
			release(&(shm_table.lock));
801076c5:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801076cc:	e8 6f cc ff ff       	call   80104340 <release>
			return 0;
801076d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
801076d4:	83 c4 1c             	add    $0x1c,%esp
801076d7:	5b                   	pop    %ebx
801076d8:	5e                   	pop    %esi
801076d9:	5f                   	pop    %edi
801076da:	5d                   	pop    %ebp
801076db:	c3                   	ret    
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[id].refcnt <= 0){
		release(&(shm_table.lock));
801076dc:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801076e3:	e8 58 cc ff ff       	call   80104340 <release>
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
801076e8:	8b 46 10             	mov    0x10(%esi),%eax
801076eb:	c7 04 24 c8 83 10 80 	movl   $0x801083c8,(%esp)
801076f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801076f6:	e8 55 8f ff ff       	call   80100650 <cprintf>
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
801076fb:	83 c4 1c             	add    $0x1c,%esp
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[id].refcnt <= 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return 0;
801076fe:	31 c0                	xor    %eax,%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
80107700:	5b                   	pop    %ebx
80107701:	5e                   	pop    %esi
80107702:	5f                   	pop    %edi
80107703:	5d                   	pop    %ebp
80107704:	c3                   	ret    
80107705:	8d 76 00             	lea    0x0(%esi),%esi
		return 0;
	}
	shm_table.shm_pages[id].refcnt--;
	pte = walkpgdir(curproc->pgdir, shm_table.shm_pages[id].frame, 0);
	if(pte == 0){
		cprintf("Proc: %d, free memory error 1\n",curproc->pid);
80107708:	8b 46 10             	mov    0x10(%esi),%eax
8010770b:	c7 04 24 e8 83 10 80 	movl   $0x801083e8,(%esp)
80107712:	89 44 24 04          	mov    %eax,0x4(%esp)
80107716:	e8 35 8f ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010771b:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107722:	e8 19 cc ff ff       	call   80104340 <release>
		return 0;
80107727:	31 c0                	xor    %eax,%eax
80107729:	e9 b9 fe ff ff       	jmp    801075e7 <shm_close+0x47>
int shm_close(int id) {
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
8010772e:	8b 40 10             	mov    0x10(%eax),%eax
80107731:	c7 04 24 fc 82 10 80 	movl   $0x801082fc,(%esp)
80107738:	89 44 24 04          	mov    %eax,0x4(%esp)
8010773c:	e8 0f 8f ff ff       	call   80100650 <cprintf>
		return -1;
80107741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107746:	e9 9c fe ff ff       	jmp    801075e7 <shm_close+0x47>
