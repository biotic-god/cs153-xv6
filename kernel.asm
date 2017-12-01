
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
8010002d:	b8 f0 2d 10 80       	mov    $0x80102df0,%eax
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
8010005b:	e8 f0 40 00 00       	call   80104150 <initlock>

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
8010009c:	e8 9f 3f 00 00       	call   80104040 <initsleeplock>
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
801000e6:	e8 55 41 00 00       	call   80104240 <acquire>

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
80100161:	e8 ca 41 00 00       	call   80104330 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 3f 00 00       	call   80104080 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
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
801001b0:	e8 6b 3f 00 00       	call   80104120 <holdingsleep>
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
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
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
801001f1:	e8 2a 3f 00 00       	call   80104120 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 3e 00 00       	call   801040e0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100209:	e8 32 40 00 00       	call   80104240 <acquire>
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
80100250:	e9 db 40 00 00       	jmp    80104330 <release>
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
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 ad 3f 00 00       	call   80104240 <acquire>
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
801002a8:	e8 43 34 00 00       	call   801036f0 <myproc>
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
801002c3:	e8 18 3a 00 00       	call   80103ce0 <sleep>

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
80100311:	e8 1a 40 00 00       	call   80104330 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
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
8010032f:	e8 fc 3f 00 00       	call   80104330 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
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
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
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
801003af:	e8 bc 3d 00 00       	call   80104170 <getcallerpcs>
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
80100409:	e8 72 56 00 00       	call   80105a80 <uartputc>
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
801004b9:	e8 c2 55 00 00       	call   80105a80 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 b6 55 00 00       	call   80105a80 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 aa 55 00 00       	call   80105a80 <uartputc>
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
801004fc:	e8 1f 3f 00 00       	call   80104420 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 62 3e 00 00       	call   80104380 <memset>
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
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 2d 3c 00 00       	call   80104240 <acquire>
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
80100636:	e8 f5 3c 00 00       	call   80104330 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

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
801006f3:	e8 38 3c 00 00       	call   80104330 <release>
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
80100797:	e8 a4 3a 00 00       	call   80104240 <acquire>
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
801007c5:	e8 76 3a 00 00       	call   80104240 <acquire>
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
80100827:	e8 04 3b 00 00       	call   80104330 <release>
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
801008b2:	e8 c9 35 00 00       	call   80103e80 <wakeup>
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
80100927:	e9 44 36 00 00       	jmp    80103f70 <procdump>
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
80100965:	e8 e6 37 00 00       	call   80104150 <initlock>

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
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
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
801009ac:	e8 3f 2d 00 00       	call   801036f0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();
801009b7:	e8 54 21 00 00       	call   80102b10 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 53 02 00 00    	je     80100c24 <exec+0x284>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
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
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
    end_op();
80100a08:	e8 73 21 00 00       	call   80102b80 <end_op>
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
80100a2c:	e8 af 63 00 00       	call   80106de0 <setupkvm>
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
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
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
80100ad2:	e8 49 60 00 00       	call   80106b20 <allocuvm>
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
80100b13:	e8 38 5f 00 00       	call   80106a50 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
	
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 32 62 00 00       	call   80106d60 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 3b 20 00 00       	call   80102b80 <end_op>
  sp = sz;
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 00 00 00 	movl   $0x80000000,0x8(%esp)
80100b52:	80 
80100b53:	c7 44 24 04 00 e0 ff 	movl   $0x7fffe000,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 bd 5f 00 00       	call   80106b20 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	0f 84 c8 01 00 00    	je     80100d33 <exec+0x393>
			panic("stack allocation failed");
			goto bad;
		}
		sp = tstack+PGSIZE;
	  clearpteu(pgdir, (char*)(tstack+PGSIZE));
80100b6b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b71:	c7 44 24 04 00 f0 ff 	movl   $0x7ffff000,0x4(%esp)
80100b78:	7f 
80100b79:	89 04 24             	mov    %eax,(%esp)
80100b7c:	e8 0f 63 00 00       	call   80106e90 <clearpteu>
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b81:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b84:	8b 00                	mov    (%eax),%eax
80100b86:	85 c0                	test   %eax,%eax
80100b88:	0f 84 b1 00 00 00    	je     80100c3f <exec+0x29f>
80100b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
			panic("stack allocation failed");
			goto bad;
		}
		sp = tstack+PGSIZE;
80100b91:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
	  clearpteu(pgdir, (char*)(tstack+PGSIZE));
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b96:	31 f6                	xor    %esi,%esi
80100b98:	8d 51 04             	lea    0x4(%ecx),%edx
80100b9b:	89 cf                	mov    %ecx,%edi
80100b9d:	eb 2b                	jmp    80100bca <exec+0x22a>
80100b9f:	90                   	nop
80100ba0:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100ba6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100bac:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
			goto bad;
		}
		sp = tstack+PGSIZE;
	  clearpteu(pgdir, (char*)(tstack+PGSIZE));
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb3:	83 c6 01             	add    $0x1,%esi
80100bb6:	8b 02                	mov    (%edx),%eax
80100bb8:	89 d7                	mov    %edx,%edi
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	0f 84 8a 00 00 00    	je     80100c4c <exec+0x2ac>
80100bc2:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bc5:	83 fe 20             	cmp    $0x20,%esi
80100bc8:	74 42                	je     80100c0c <exec+0x26c>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bca:	89 04 24             	mov    %eax,(%esp)
80100bcd:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bd3:	e8 c8 39 00 00       	call   801045a0 <strlen>
80100bd8:	f7 d0                	not    %eax
80100bda:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bdc:	8b 07                	mov    (%edi),%eax
	  clearpteu(pgdir, (char*)(tstack+PGSIZE));
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bde:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100be1:	89 04 24             	mov    %eax,(%esp)
80100be4:	e8 b7 39 00 00       	call   801045a0 <strlen>
80100be9:	83 c0 01             	add    $0x1,%eax
80100bec:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bf0:	8b 07                	mov    (%edi),%eax
80100bf2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bfa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c00:	89 04 24             	mov    %eax,(%esp)
80100c03:	e8 08 65 00 00       	call   80107110 <copyout>
80100c08:	85 c0                	test   %eax,%eax
80100c0a:	79 94                	jns    80100ba0 <exec+0x200>
	
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c0c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c12:	89 04 24             	mov    %eax,(%esp)
80100c15:	e8 46 61 00 00       	call   80106d60 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1f:	e9 ee fd ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();
  uint tstack = 0; //top of stack For CS153 lab2 part1
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c24:	e8 57 1f 00 00       	call   80102b80 <end_op>
    cprintf("exec: fail\n");
80100c29:	c7 04 24 e1 77 10 80 	movl   $0x801077e1,(%esp)
80100c30:	e8 1b fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3a:	e9 d3 fd ff ff       	jmp    80100a12 <exec+0x72>
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
			panic("stack allocation failed");
			goto bad;
		}
		sp = tstack+PGSIZE;
80100c3f:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
	  clearpteu(pgdir, (char*)(tstack+PGSIZE));
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c44:	31 f6                	xor    %esi,%esi
80100c46:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx

  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c4c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c53:	89 da                	mov    %ebx,%edx
80100c55:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c57:	83 c0 0c             	add    $0xc,%eax
80100c5a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c60:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c66:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }

  ustack[3+argc] = 0;
80100c6e:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c75:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c79:	89 04 24             	mov    %eax,(%esp)
    ustack[3+argc] = sp;
  }

  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c7c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c83:	ff ff ff 
  ustack[1] = argc;
80100c86:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8c:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c92:	e8 79 64 00 00       	call   80107110 <copyout>
80100c97:	85 c0                	test   %eax,%eax
80100c99:	0f 88 6d ff ff ff    	js     80100c0c <exec+0x26c>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80100ca2:	0f b6 10             	movzbl (%eax),%edx
80100ca5:	84 d2                	test   %dl,%dl
80100ca7:	74 1a                	je     80100cc3 <exec+0x323>
80100ca9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cac:	83 c0 01             	add    $0x1,%eax
80100caf:	90                   	nop
    if(*s == '/')
      last = s+1;
80100cb0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cb6:	0f 44 c8             	cmove  %eax,%ecx
80100cb9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cbc:	84 d2                	test   %dl,%dl
80100cbe:	75 f0                	jne    80100cb0 <exec+0x310>
80100cc0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cc3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80100ccc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cd3:	00 
80100cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd8:	89 f8                	mov    %edi,%eax
80100cda:	83 c0 6c             	add    $0x6c,%eax
80100cdd:	89 04 24             	mov    %eax,(%esp)
80100ce0:	e8 7b 38 00 00       	call   80104560 <safestrcpy>
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100ce5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ceb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
80100cf1:	8b 77 04             	mov    0x4(%edi),%esi
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
80100cf4:	c7 47 7c 00 e0 ff 7f 	movl   $0x7fffe000,0x7c(%edi)
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100cfb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d05:	89 07                	mov    %eax,(%edi)
  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d07:	8b 47 18             	mov    0x18(%edi),%eax
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image. For CS153 lab2 part1
  curproc->tstack = tstack; //stack address
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d0a:	89 57 04             	mov    %edx,0x4(%edi)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 8c 5b 00 00       	call   801068b0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 34 60 00 00       	call   80106d60 <freevm>
	
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
*/

	// Allocate stack page from USERTOP For CS153 lab2 part1
	tstack = USEREND - 2*PGSIZE;
    if((sp = allocuvm(pgdir, tstack, USEREND)) == 0){
			panic("stack allocation failed");
80100d33:	c7 04 24 ed 77 10 80 	movl   $0x801077ed,(%esp)
80100d3a:	e8 21 f6 ff ff       	call   80100360 <panic>
80100d3f:	90                   	nop

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 05 78 10 	movl   $0x80107805,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100d55:	e8 f6 33 00 00       	call   80104150 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100d73:	e8 c8 34 00 00       	call   80104240 <acquire>
80100d78:	eb 11                	jmp    80100d8b <filealloc+0x2b>
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d99:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da0:	e8 8b 35 00 00       	call   80104330 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100da8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100daa:	5b                   	pop    %ebx
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100db7:	e8 74 35 00 00       	call   80104330 <release>
  return 0;
}
80100dbc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dbf:	31 c0                	xor    %eax,%eax
}
80100dc1:	5b                   	pop    %ebx
80100dc2:	5d                   	pop    %ebp
80100dc3:	c3                   	ret    
80100dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100de1:	e8 5a 34 00 00       	call   80104240 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100dfa:	e8 31 35 00 00       	call   80104330 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 0c 78 10 80 	movl   $0x8010780c,(%esp)
80100e0e:	e8 4d f5 ff ff       	call   80100360 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 1c             	sub    $0x1c,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80100e33:	e8 08 34 00 00       	call   80104240 <acquire>
  if(f->ref < 1)
80100e38:	8b 57 04             	mov    0x4(%edi),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	0f 8e 89 00 00 00    	jle    80100ecc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e43:	83 ea 01             	sub    $0x1,%edx
80100e46:	85 d2                	test   %edx,%edx
80100e48:	89 57 04             	mov    %edx,0x4(%edi)
80100e4b:	74 13                	je     80100e60 <fileclose+0x40>
    release(&ftable.lock);
80100e4d:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e54:	83 c4 1c             	add    $0x1c,%esp
80100e57:	5b                   	pop    %ebx
80100e58:	5e                   	pop    %esi
80100e59:	5f                   	pop    %edi
80100e5a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5b:	e9 d0 34 00 00       	jmp    80104330 <release>
    return;
  }
  ff = *f;
80100e60:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e64:	8b 37                	mov    (%edi),%esi
80100e66:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e69:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e75:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7f:	e8 ac 34 00 00       	call   80104330 <release>

  if(ff.type == FD_PIPE)
80100e84:	83 fe 01             	cmp    $0x1,%esi
80100e87:	74 0f                	je     80100e98 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e89:	83 fe 02             	cmp    $0x2,%esi
80100e8c:	74 22                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8e:	83 c4 1c             	add    $0x1c,%esp
80100e91:	5b                   	pop    %ebx
80100e92:	5e                   	pop    %esi
80100e93:	5f                   	pop    %edi
80100e94:	5d                   	pop    %ebp
80100e95:	c3                   	ret    
80100e96:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e9c:	89 1c 24             	mov    %ebx,(%esp)
80100e9f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ea3:	e8 b8 23 00 00       	call   80103260 <pipeclose>
80100ea8:	eb e4                	jmp    80100e8e <fileclose+0x6e>
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 5b 1c 00 00       	call   80102b10 <begin_op>
    iput(ff.ip);
80100eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb8:	89 04 24             	mov    %eax,(%esp)
80100ebb:	e8 10 09 00 00       	call   801017d0 <iput>
    end_op();
  }
}
80100ec0:	83 c4 1c             	add    $0x1c,%esp
80100ec3:	5b                   	pop    %ebx
80100ec4:	5e                   	pop    %esi
80100ec5:	5f                   	pop    %edi
80100ec6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec7:	e9 b4 1c 00 00       	jmp    80102b80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecc:	c7 04 24 14 78 10 80 	movl   $0x80107814,(%esp)
80100ed3:	e8 88 f4 ff ff       	call   80100360 <panic>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 14             	sub    $0x14,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 b6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 24 0a 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f0c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 79 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f17:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f1a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f1c:	5b                   	pop    %ebx
80100f1d:	5d                   	pop    %ebp
80100f1e:	c3                   	ret    
80100f1f:	90                   	nop
80100f20:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	5b                   	pop    %ebx
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 1c             	sub    $0x1c,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 68                	je     80100fb0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 49                	je     80100f98 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 63                	jne    80100fb7 <fileread+0x87>
    ilock(f->ip);
80100f54:	8b 43 10             	mov    0x10(%ebx),%eax
80100f57:	89 04 24             	mov    %eax,(%esp)
80100f5a:	e8 51 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f63:	8b 43 14             	mov    0x14(%ebx),%eax
80100f66:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 e7 09 00 00       	call   80101960 <readi>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	89 c6                	mov    %eax,%esi
80100f7d:	7e 03                	jle    80100f82 <fileread+0x52>
      f->off += r;
80100f7f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f82:	8b 43 10             	mov    0x10(%ebx),%eax
80100f85:	89 04 24             	mov    %eax,(%esp)
80100f88:	e8 03 08 00 00       	call   80101790 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8f:	83 c4 1c             	add    $0x1c,%esp
80100f92:	5b                   	pop    %ebx
80100f93:	5e                   	pop    %esi
80100f94:	5f                   	pop    %edi
80100f95:	5d                   	pop    %ebp
80100f96:	c3                   	ret    
80100f97:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f98:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f9b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9e:	83 c4 1c             	add    $0x1c,%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa5:	e9 36 24 00 00       	jmp    801033e0 <piperead>
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb d8                	jmp    80100f8f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fb7:	c7 04 24 1e 78 10 80 	movl   $0x8010781e,(%esp)
80100fbe:	e8 9d f3 ff ff       	call   80100360 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 2c             	sub    $0x2c,%esp
80100fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fe5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 ae 00 00 00    	je     801010a0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 07                	mov    (%edi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d7 00 00 00    	jne    801010dd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 db                	xor    %ebx,%ebx
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 31                	jg     80101040 <filewrite+0x70>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101018:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010101b:	01 47 14             	add    %eax,0x14(%edi)
8010101e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101021:	89 0c 24             	mov    %ecx,(%esp)
80101024:	e8 67 07 00 00       	call   80101790 <iunlock>
      end_op();
80101029:	e8 52 1b 00 00       	call   80102b80 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101031:	39 f0                	cmp    %esi,%eax
80101033:	0f 85 98 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101039:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010103e:	7e 70                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101040:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101043:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101048:	29 de                	sub    %ebx,%esi
8010104a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101050:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101053:	e8 b8 1a 00 00       	call   80102b10 <begin_op>
      ilock(f->ip);
80101058:	8b 47 10             	mov    0x10(%edi),%eax
8010105b:	89 04 24             	mov    %eax,(%esp)
8010105e:	e8 4d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101063:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101067:	8b 47 14             	mov    0x14(%edi),%eax
8010106a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	01 d8                	add    %ebx,%eax
80101073:	89 44 24 04          	mov    %eax,0x4(%esp)
80101077:	8b 47 10             	mov    0x10(%edi),%eax
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 de 09 00 00       	call   80101a60 <writei>
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 92                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101086:	8b 4f 10             	mov    0x10(%edi),%ecx
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108c:	89 0c 24             	mov    %ecx,(%esp)
8010108f:	e8 fc 06 00 00       	call   80101790 <iunlock>
      end_op();
80101094:	e8 e7 1a 00 00       	call   80102b80 <end_op>

      if(r < 0)
80101099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	74 91                	je     80101031 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
801010ac:	c3                   	ret    
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010b3:	89 d8                	mov    %ebx,%eax
801010b5:	75 e9                	jne    801010a0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010b7:	83 c4 2c             	add    $0x2c,%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 47 0c             	mov    0xc(%edi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	83 c4 2c             	add    $0x2c,%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 1f 22 00 00       	jmp    801032f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	c7 04 24 27 78 10 80 	movl   $0x80107827,(%esp)
801010d8:	e8 83 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010dd:	c7 04 24 2d 78 10 80 	movl   $0x8010782d,(%esp)
801010e4:	e8 77 f2 ff ff       	call   80100360 <panic>
801010e9:	66 90                	xchg   %ax,%ax
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 2c             	sub    $0x2c,%esp
801010f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010fc:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101101:	85 c0                	test   %eax,%eax
80101103:	0f 84 8c 00 00 00    	je     80101195 <balloc+0xa5>
80101109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101110:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101113:	89 f0                	mov    %esi,%eax
80101115:	c1 f8 0c             	sar    $0xc,%eax
80101118:	03 05 d8 19 11 80    	add    0x801119d8,%eax
8010111e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101122:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101125:	89 04 24             	mov    %eax,(%esp)
80101128:	e8 a3 ef ff ff       	call   801000d0 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101138:	31 c0                	xor    %eax,%eax
8010113a:	eb 33                	jmp    8010116f <balloc+0x7f>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101140:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101143:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101145:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	bf 01 00 00 00       	mov    $0x1,%edi
80101152:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101154:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101159:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115b:	0f b6 fb             	movzbl %bl,%edi
8010115e:	85 cf                	test   %ecx,%edi
80101160:	74 46                	je     801011a8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101162:	83 c0 01             	add    $0x1,%eax
80101165:	83 c6 01             	add    $0x1,%esi
80101168:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010116d:	74 05                	je     80101174 <balloc+0x84>
8010116f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101172:	72 cc                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 61 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	3b 05 c0 19 11 80    	cmp    0x801119c0,%eax
8010118f:	0f 82 7b ff ff ff    	jb     80101110 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101195:	c7 04 24 37 78 10 80 	movl   $0x80107837,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	09 d9                	or     %ebx,%ecx
801011aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ad:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011b1:	89 1c 24             	mov    %ebx,(%esp)
801011b4:	e8 f7 1a 00 00       	call   80102cb0 <log_write>
        brelse(bp);
801011b9:	89 1c 24             	mov    %ebx,(%esp)
801011bc:	e8 1f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011c8:	89 04 24             	mov    %eax,(%esp)
801011cb:	e8 00 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011d7:	00 
801011d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011df:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 93 31 00 00       	call   80104380 <memset>
  log_write(bp);
801011ed:	89 1c 24             	mov    %ebx,(%esp)
801011f0:	e8 bb 1a 00 00       	call   80102cb0 <log_write>
  brelse(bp);
801011f5:	89 1c 24             	mov    %ebx,(%esp)
801011f8:	e8 e3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fd:	83 c4 2c             	add    $0x2c,%esp
80101200:	89 f0                	mov    %esi,%eax
80101202:	5b                   	pop    %ebx
80101203:	5e                   	pop    %esi
80101204:	5f                   	pop    %edi
80101205:	5d                   	pop    %ebp
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	89 c7                	mov    %eax,%edi
80101216:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101217:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101222:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010122c:	e8 0f 30 00 00       	call   80104240 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101234:	eb 14                	jmp    8010124a <iget+0x3a>
80101236:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101238:	85 f6                	test   %esi,%esi
8010123a:	74 3c                	je     80101278 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101242:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101248:	74 46                	je     80101290 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010124a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010124d:	85 c9                	test   %ecx,%ecx
8010124f:	7e e7                	jle    80101238 <iget+0x28>
80101251:	39 3b                	cmp    %edi,(%ebx)
80101253:	75 e3                	jne    80101238 <iget+0x28>
80101255:	39 53 04             	cmp    %edx,0x4(%ebx)
80101258:	75 de                	jne    80101238 <iget+0x28>
      ip->ref++;
8010125a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010125d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101266:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101269:	e8 c2 30 00 00       	call   80104330 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010126e:	83 c4 1c             	add    $0x1c,%esp
80101271:	89 f0                	mov    %esi,%eax
80101273:	5b                   	pop    %ebx
80101274:	5e                   	pop    %esi
80101275:	5f                   	pop    %edi
80101276:	5d                   	pop    %ebp
80101277:	c3                   	ret    
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101289:	75 bf                	jne    8010124a <iget+0x3a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 29                	je     801012bd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101294:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101296:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101299:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012a7:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801012ae:	e8 7d 30 00 00       	call   80104330 <release>

  return ip;
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	89 f0                	mov    %esi,%eax
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012bd:	c7 04 24 4d 78 10 80 	movl   $0x8010784d,(%esp)
801012c4:	e8 97 f0 ff ff       	call   80100360 <panic>
801012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c3                	mov    %eax,%ebx
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 66                	je     80101350 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	83 c4 1c             	add    $0x1c,%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012fb:	83 fe 7f             	cmp    $0x7f,%esi
801012fe:	77 77                	ja     80101377 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101300:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 5e                	je     80101368 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130e:	8b 03                	mov    (%ebx),%eax
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 b8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101318:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010131e:	8b 32                	mov    (%edx),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	75 19                	jne    8010133d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101324:	8b 03                	mov    (%ebx),%eax
80101326:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101329:	e8 c2 fd ff ff       	call   801010f0 <balloc>
8010132e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101331:	89 02                	mov    %eax,(%edx)
80101333:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101335:	89 3c 24             	mov    %edi,(%esp)
80101338:	e8 73 19 00 00       	call   80102cb0 <log_write>
    }
    brelse(bp);
8010133d:	89 3c 24             	mov    %edi,(%esp)
80101340:	e8 9b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101345:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101348:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 03                	mov    (%ebx),%eax
80101352:	e8 99 fd ff ff       	call   801010f0 <balloc>
80101357:	89 46 5c             	mov    %eax,0x5c(%esi)
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
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	e8 81 fd ff ff       	call   801010f0 <balloc>
8010136f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101375:	eb 93                	jmp    8010130a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	c7 04 24 5d 78 10 80 	movl   $0x8010785d,(%esp)
8010137e:	e8 dd ef ff ff       	call   80100360 <panic>
80101383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 22 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ae:	89 34 24             	mov    %esi,(%esp)
801013b1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013b8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	e8 59 30 00 00       	call   80104420 <memmove>
  brelse(bp);
801013c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d0:	e9 0b ee ff ff       	jmp    801001e0 <brelse>
801013d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 d7                	mov    %edx,%edi
801013e6:	56                   	push   %esi
801013e7:	53                   	push   %ebx
801013e8:	89 c3                	mov    %eax,%ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ed:	89 04 24             	mov    %eax,(%esp)
801013f0:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
801013f7:	80 
801013f8:	e8 93 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013fd:	89 fa                	mov    %edi,%edx
801013ff:	c1 ea 0c             	shr    $0xc,%edx
80101402:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101408:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101410:	89 54 24 04          	mov    %edx,0x4(%esp)
80101414:	e8 b7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010141b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101421:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101423:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101426:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010142b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010142d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101432:	0f b6 c8             	movzbl %al,%ecx
80101435:	85 d9                	test   %ebx,%ecx
80101437:	74 20                	je     80101459 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101439:	f7 d3                	not    %ebx
8010143b:	21 c3                	and    %eax,%ebx
8010143d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 67 18 00 00       	call   80102cb0 <log_write>
  brelse(bp);
80101449:	89 34 24             	mov    %esi,(%esp)
8010144c:	e8 8f ed ff ff       	call   801001e0 <brelse>
}
80101451:	83 c4 1c             	add    $0x1c,%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101459:	c7 04 24 70 78 10 80 	movl   $0x80107870,(%esp)
80101460:	e8 fb ee ff ff       	call   80100360 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 83 78 10 	movl   $0x80107883,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010148b:	e8 c0 2c 00 00       	call   80104150 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 8a 78 10 	movl   $0x8010788a,0x4(%esp)
801014a0:	80 
801014a1:	e8 9a 2b 00 00       	call   80104040 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 c0 19 11 	movl   $0x801119c0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 cf fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 d8 19 11 80       	mov    0x801119d8,%eax
801014c6:	c7 04 24 f0 78 10 80 	movl   $0x801078f0,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 d4 19 11 80       	mov    0x801119d4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 d0 19 11 80       	mov    0x801119d0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 cc 19 11 80       	mov    0x801119cc,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 c8 19 11 80       	mov    0x801119c8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 c4 19 11 80       	mov    0x801119c4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 d2 2d 00 00       	call   80104380 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 ea 16 00 00       	call   80102cb0 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 2f fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 90 78 10 80 	movl   $0x80107890,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 bb 2d 00 00       	call   80104420 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 43 16 00 00       	call   80102cb0 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101691:	e8 aa 2b 00 00       	call   80104240 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016a1:	e8 8a 2c 00 00       	call   80104330 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 a7 29 00 00       	call   80104080 <acquiresleep>

  if(ip->valid == 0){
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 d0 2c 00 00       	call   80104420 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
      panic("ilock: no type");
8010176a:	c7 04 24 a8 78 10 80 	movl   $0x801078a8,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101776:	c7 04 24 a2 78 10 80 	movl   $0x801078a2,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 76 29 00 00       	call   80104120 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017be:	e9 1d 29 00 00       	jmp    801040e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017c3:	c7 04 24 b7 78 10 80 	movl   $0x801078b7,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 99 28 00 00       	call   80104080 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 e3 28 00 00       	call   801040e0 <releasesleep>

  acquire(&icache.lock);
801017fd:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101804:	e8 37 2a 00 00       	call   80104240 <acquire>
  ip->ref--;
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180d:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010181b:	e9 10 2b 00 00       	jmp    80104330 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101820:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101827:	e8 14 2a 00 00       	call   80104240 <acquire>
    int r = ip->ref;
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010182f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101836:	e8 f5 2a 00 00       	call   80104330 <release>
    if(r == 1){
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
    if(ip->addrs[i]){
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 7b fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
      if(a[j])
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 fd fa ff ff       	call   801013e0 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
    }
    brelse(bp);
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 e0 fa ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 09 f9 ff ff       	call   801012d0 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ee:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 13 2a 00 00       	call   80104420 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 04 f8 ff ff       	call   801012d0 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 17 29 00 00       	call   80104420 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 9f 11 00 00       	call   80102cb0 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
  }
  return n;
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 f0 28 00 00       	call   801044a0 <strncmp>
}
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 72 28 00 00       	call   801044a0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
        *poff = off;
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 c7 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c5b:	31 c0                	xor    %eax,%eax
}
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c62:	c7 04 24 d1 78 10 80 	movl   $0x801078d1,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c6e:	c7 04 24 bf 78 10 80 	movl   $0x801078bf,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 52 1a 00 00       	call   801036f0 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ca1:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ca8:	e8 93 25 00 00       	call   80104240 <acquire>
  ip->ref++;
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb1:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cb8:	e8 73 26 00 00       	call   80104330 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
    path++;
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
    path++;
80101cf2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 00 27 00 00       	call   80104420 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 72 26 00 00       	call   80104420 <memmove>
    name[len] = 0;
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101de3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 17 f4 ff ff       	call   80101210 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e0b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 68 26 00 00       	call   80104510 <strncpy>
  de.inum = inum;
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ecc:	31 c0                	xor    %eax,%eax
}
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
    return -1;
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ee5:	c7 04 24 e0 78 10 80 	movl   $0x801078e0,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ef1:	c7 04 24 e6 7e 10 80 	movl   $0x80107ee6,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fdf:	c7 04 24 4c 79 10 80 	movl   $0x8010794c,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101feb:	c7 04 24 43 79 10 80 	movl   $0x80107943,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102006:	c7 44 24 04 5e 79 10 	movl   $0x8010795e,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102015:	e8 36 21 00 00       	call   80104150 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010201a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
      havedisk1 = 1;
80102062:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102069:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102090:	e8 ab 21 00 00       	call   80104240 <acquire>

  if((b = idequeue) == 0){
80102095:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 bf 1d 00 00       	call   80103e80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020cf:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801020d6:	e8 55 22 00 00       	call   80104330 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 eb 1f 00 00       	call   80104120 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102166:	e8 d5 20 00 00       	call   80104240 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 30 1b 00 00       	call   80103ce0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ba:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021c6:	e9 65 21 00 00       	jmp    80104330 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021db:	c7 04 24 62 79 10 80 	movl   $0x80107962,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 8d 79 10 80 	movl   $0x8010798d,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021f3:	c7 04 24 78 79 10 80 	movl   $0x80107978,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102208:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010220f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
  return ioapic->data;
8010221c:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010222b:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102231:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102241:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102248:	c7 04 24 ac 79 10 80 	movl   $0x801079ac,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010226c:	8b 1d 34 36 11 80    	mov    0x80113634,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102287:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102289:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c1:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ca:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022cc:	8b 15 34 36 11 80    	mov    0x80113634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022da:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb f4 70 11 80    	cmp    $0x801170f4,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 51 20 00 00       	call   80104380 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 78 36 11 80       	mov    0x80113678,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102345:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102358:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102364:	e9 c7 1f 00 00       	jmp    80104330 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102370:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
80102377:	e8 c4 1e 00 00       	call   80104240 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010237e:	c7 04 24 de 79 10 80 	movl   $0x801079de,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
    kfree(p);
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 e4 79 10 	movl   $0x801079e4,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801023fa:	e8 51 1d 00 00       	call   80104150 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102402:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102409:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010248e:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 74 36 11 80       	mov    0x80113674,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801024cd:	e8 5e 1e 00 00       	call   80104330 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801024e7:	e8 54 1d 00 00       	call   80104240 <acquire>
801024ec:	a1 74 36 11 80       	mov    0x80113674,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102511:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102534:	0f b6 81 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102568:	0f b6 91 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%edx
  shift ^= togglecode[data];
8010256f:	0f b6 81 20 7a 10 80 	movzbl -0x7fef85e0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102576:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102578:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 00 7a 10 80 	mov    -0x7fef8600(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102586:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010258c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a8:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
}
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102760:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010276f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102770:	c1 e8 18             	shr    $0x18,%eax
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102778:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102822:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 7c fd ff ff       	call   801025f0 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 63 fd ff ff       	call   801025f0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 2f 1b 00 00       	call   801043d0 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	66 90                	xchg   %ax,%ax
8010295a:	66 90                	xchg   %ax,%ax
8010295c:	66 90                	xchg   %ax,%ax
8010295e:	66 90                	xchg   %ax,%ax

80102960 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102966:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102968:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010296b:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 78                	jle    801029ec <install_trans+0x8c>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102978:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010297d:	01 d8                	add    %ebx,%eax
8010297f:	83 c0 01             	add    $0x1,%eax
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 c4 36 11 80       	mov    0x801136c4,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102995:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010299c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	a1 c4 36 11 80       	mov    0x801136c4,%eax
801029a8:	89 04 24             	mov    %eax,(%esp)
801029ab:	e8 20 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029b7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ba:	8d 47 5c             	lea    0x5c(%edi),%eax
801029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029c4:	89 04 24             	mov    %eax,(%esp)
801029c7:	e8 54 1a 00 00       	call   80104420 <memmove>
    bwrite(dbuf);  // write dst to disk
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 cc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029d4:	89 3c 24             	mov    %edi,(%esp)
801029d7:	e8 04 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 fc d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
801029ea:	7f 8c                	jg     80102978 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029ec:	83 c4 1c             	add    $0x1c,%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a09:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 b1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a1f:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a25:	31 d2                	xor    %edx,%edx
80102a27:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a29:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a2e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a31:	7e 17                	jle    80102a4a <write_head+0x4a>
80102a33:	90                   	nop
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a38:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102a3f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a43:	83 c2 01             	add    $0x1,%edx
80102a46:	39 da                	cmp    %ebx,%edx
80102a48:	75 ee                	jne    80102a38 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a4a:	89 3c 24             	mov    %edi,(%esp)
80102a4d:	e8 4e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a52:	89 3c 24             	mov    %edi,(%esp)
80102a55:	e8 86 d7 ff ff       	call   801001e0 <brelse>
}
80102a5a:	83 c4 1c             	add    $0x1c,%esp
80102a5d:	5b                   	pop    %ebx
80102a5e:	5e                   	pop    %esi
80102a5f:	5f                   	pop    %edi
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 30             	sub    $0x30,%esp
80102a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a7b:	c7 44 24 04 20 7c 10 	movl   $0x80107c20,0x4(%esp)
80102a82:	80 
80102a83:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102a8a:	e8 c1 16 00 00       	call   80104150 <initlock>
  readsb(dev, &sb);
80102a8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	89 1c 24             	mov    %ebx,(%esp)
80102a99:	e8 f2 e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102aa7:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aad:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ab1:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ab7:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abc:	e8 0f d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ac3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102acb:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	7e 17                	jle    80102aea <initlog+0x7a>
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ad8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102adc:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ae3:	83 c2 01             	add    $0x1,%edx
80102ae6:	39 da                	cmp    %ebx,%edx
80102ae8:	75 ee                	jne    80102ad8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102af2:	e8 69 fe ff ff       	call   80102960 <install_trans>
  log.lh.n = 0;
80102af7:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102afe:	00 00 00 
  write_head(); // clear the log
80102b01:	e8 fa fe ff ff       	call   80102a00 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b06:	83 c4 30             	add    $0x30,%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret    
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b16:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b1d:	e8 1e 17 00 00       	call   80104240 <acquire>
80102b22:	eb 18                	jmp    80102b3c <begin_op+0x2c>
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b28:	c7 44 24 04 80 36 11 	movl   $0x80113680,0x4(%esp)
80102b2f:	80 
80102b30:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b37:	e8 a4 11 00 00       	call   80103ce0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b3c:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	75 e3                	jne    80102b28 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b45:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102b4a:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102b50:	83 c0 01             	add    $0x1,%eax
80102b53:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b56:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b59:	83 fa 1e             	cmp    $0x1e,%edx
80102b5c:	7f ca                	jg     80102b28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b5e:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b65:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102b6a:	e8 c1 17 00 00       	call   80104330 <release>
      break;
    }
  }
}
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    
80102b71:	eb 0d                	jmp    80102b80 <end_op>
80102b73:	90                   	nop
80102b74:	90                   	nop
80102b75:	90                   	nop
80102b76:	90                   	nop
80102b77:	90                   	nop
80102b78:	90                   	nop
80102b79:	90                   	nop
80102b7a:	90                   	nop
80102b7b:	90                   	nop
80102b7c:	90                   	nop
80102b7d:	90                   	nop
80102b7e:	90                   	nop
80102b7f:	90                   	nop

80102b80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b89:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102b90:	e8 ab 16 00 00       	call   80104240 <acquire>
  log.outstanding -= 1;
80102b95:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102b9a:	8b 15 c0 36 11 80    	mov    0x801136c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ba3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba5:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102baa:	0f 85 f3 00 00 00    	jne    80102ca3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	0f 85 cb 00 00 00    	jne    80102c83 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bb8:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bbf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bc1:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102bc8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bcb:	e8 60 17 00 00       	call   80104330 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bd0:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	0f 8e 90 00 00 00    	jle    80102c6d <end_op+0xed>
80102bdd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102be0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102be5:	01 d8                	add    %ebx,%eax
80102be7:	83 c0 01             	add    $0x1,%eax
80102bea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bee:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102bf3:	89 04 24             	mov    %eax,(%esp)
80102bf6:	e8 d5 d4 ff ff       	call   801000d0 <bread>
80102bfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bfd:	8b 04 9d cc 36 11 80 	mov    -0x7feec934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c04:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0b:	a1 c4 36 11 80       	mov    0x801136c4,%eax
80102c10:	89 04 24             	mov    %eax,(%esp)
80102c13:	e8 b8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c1f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c20:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2c:	89 04 24             	mov    %eax,(%esp)
80102c2f:	e8 ec 17 00 00       	call   80104420 <memmove>
    bwrite(to);  // write the log
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 64 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c3c:	89 3c 24             	mov    %edi,(%esp)
80102c3f:	e8 9c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 94 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c4c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102c52:	7c 8c                	jl     80102be0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c54:	e8 a7 fd ff ff       	call   80102a00 <write_head>
    install_trans(); // Now install writes to home locations
80102c59:	e8 02 fd ff ff       	call   80102960 <install_trans>
    log.lh.n = 0;
80102c5e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102c65:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c68:	e8 93 fd ff ff       	call   80102a00 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c6d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102c74:	e8 c7 15 00 00       	call   80104240 <acquire>
    log.committing = 0;
80102c79:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102c80:	00 00 00 
    wakeup(&log);
80102c83:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102c8a:	e8 f1 11 00 00       	call   80103e80 <wakeup>
    release(&log.lock);
80102c8f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102c96:	e8 95 16 00 00       	call   80104330 <release>
  }
}
80102c9b:	83 c4 1c             	add    $0x1c,%esp
80102c9e:	5b                   	pop    %ebx
80102c9f:	5e                   	pop    %esi
80102ca0:	5f                   	pop    %edi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102ca3:	c7 04 24 24 7c 10 80 	movl   $0x80107c24,(%esp)
80102caa:	e8 b1 d6 ff ff       	call   80100360 <panic>
80102caf:	90                   	nop

80102cb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cb7:	a1 c8 36 11 80       	mov    0x801136c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cbf:	83 f8 1d             	cmp    $0x1d,%eax
80102cc2:	0f 8f 98 00 00 00    	jg     80102d60 <log_write+0xb0>
80102cc8:	8b 0d b8 36 11 80    	mov    0x801136b8,%ecx
80102cce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cd1:	39 d0                	cmp    %edx,%eax
80102cd3:	0f 8d 87 00 00 00    	jge    80102d60 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cd9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	0f 8e 86 00 00 00    	jle    80102d6c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ce6:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ced:	e8 4e 15 00 00       	call   80104240 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cf2:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102cf8:	83 fa 00             	cmp    $0x0,%edx
80102cfb:	7e 54                	jle    80102d51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d00:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d02:	39 0d cc 36 11 80    	cmp    %ecx,0x801136cc
80102d08:	75 0f                	jne    80102d19 <log_write+0x69>
80102d0a:	eb 3c                	jmp    80102d48 <log_write+0x98>
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d10:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d17:	74 2f                	je     80102d48 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d19:	83 c0 01             	add    $0x1,%eax
80102d1c:	39 d0                	cmp    %edx,%eax
80102d1e:	75 f0                	jne    80102d10 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d20:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d27:	83 c2 01             	add    $0x1,%edx
80102d2a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102d30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d33:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102d3a:	83 c4 14             	add    $0x14,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d3f:	e9 ec 15 00 00       	jmp    80104330 <release>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d48:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102d4f:	eb df                	jmp    80102d30 <log_write+0x80>
80102d51:	8b 43 08             	mov    0x8(%ebx),%eax
80102d54:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102d59:	75 d5                	jne    80102d30 <log_write+0x80>
80102d5b:	eb ca                	jmp    80102d27 <log_write+0x77>
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d60:	c7 04 24 33 7c 10 80 	movl   $0x80107c33,(%esp)
80102d67:	e8 f4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d6c:	c7 04 24 49 7c 10 80 	movl   $0x80107c49,(%esp)
80102d73:	e8 e8 d5 ff ff       	call   80100360 <panic>
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d87:	e8 44 09 00 00       	call   801036d0 <cpuid>
80102d8c:	89 c3                	mov    %eax,%ebx
80102d8e:	e8 3d 09 00 00       	call   801036d0 <cpuid>
80102d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d97:	c7 04 24 64 7c 10 80 	movl   $0x80107c64,(%esp)
80102d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da2:	e8 a9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102da7:	e8 84 28 00 00       	call   80105630 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dac:	e8 9f 08 00 00       	call   80103650 <mycpu>
80102db1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102db3:	b8 01 00 00 00       	mov    $0x1,%eax
80102db8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dbf:	e8 5c 0c 00 00       	call   80103a20 <scheduler>
80102dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dd0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dd6:	e8 b5 3a 00 00       	call   80106890 <switchkvm>
  seginit();
80102ddb:	e8 20 38 00 00       	call   80106600 <seginit>
  lapicinit();
80102de0:	e8 8b f8 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102de5:	e8 96 ff ff ff       	call   80102d80 <mpmain>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102df4:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dfc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102dff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e06:	80 
80102e07:	c7 04 24 f4 70 11 80 	movl   $0x801170f4,(%esp)
80102e0e:	e8 cd f5 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102e13:	e8 58 40 00 00       	call   80106e70 <kvmalloc>
  mpinit();        // detect other processors
80102e18:	e8 73 01 00 00       	call   80102f90 <mpinit>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e20:	e8 4b f8 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102e25:	e8 d6 37 00 00       	call   80106600 <seginit>
  picinit();       // disable pic
80102e2a:	e8 21 03 00 00       	call   80103150 <picinit>
80102e2f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e30:	e8 cb f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102e35:	e8 16 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e3a:	e8 91 2c 00 00       	call   80105ad0 <uartinit>
80102e3f:	90                   	nop
  pinit();         // process table
80102e40:	e8 eb 07 00 00       	call   80103630 <pinit>
  shminit();       // shared memory
80102e45:	e8 e6 43 00 00       	call   80107230 <shminit>
  tvinit();        // trap vectors
80102e4a:	e8 41 27 00 00       	call   80105590 <tvinit>
80102e4f:	90                   	nop
  binit();         // buffer cache
80102e50:	e8 eb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e55:	e8 e6 de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk 
80102e5a:	e8 a1 f1 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e5f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e66:	00 
80102e67:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102e6e:	80 
80102e6f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e76:	e8 a5 15 00 00       	call   80104420 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e7b:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102e82:	00 00 00 
80102e85:	05 80 37 11 80       	add    $0x80113780,%eax
80102e8a:	39 d8                	cmp    %ebx,%eax
80102e8c:	76 65                	jbe    80102ef3 <main+0x103>
80102e8e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e90:	e8 bb 07 00 00       	call   80103650 <mycpu>
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	74 41                	je     80102eda <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e99:	e8 02 f6 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102dd0,0x80006ff8
80102ea5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ea8:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102eaf:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102eb2:	05 00 10 00 00       	add    $0x1000,%eax
80102eb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ebc:	0f b6 03             	movzbl (%ebx),%eax
80102ebf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ec6:	00 
80102ec7:	89 04 24             	mov    %eax,(%esp)
80102eca:	e8 e1 f8 ff ff       	call   801027b0 <lapicstartap>
80102ecf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ed0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 f6                	je     80102ed0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eda:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102ee1:	00 00 00 
80102ee4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eea:	05 80 37 11 80       	add    $0x80113780,%eax
80102eef:	39 c3                	cmp    %eax,%ebx
80102ef1:	72 9d                	jb     80102e90 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ef3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102efa:	8e 
80102efb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f02:	e8 49 f5 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102f07:	e8 14 08 00 00       	call   80103720 <userinit>
  mpmain();        // finish this processor's setup
80102f0c:	e8 6f fe ff ff       	call   80102d80 <mpmain>
80102f11:	66 90                	xchg   %ax,%ax
80102f13:	66 90                	xchg   %ax,%ax
80102f15:	66 90                	xchg   %ax,%ax
80102f17:	66 90                	xchg   %ax,%ax
80102f19:	66 90                	xchg   %ax,%ax
80102f1b:	66 90                	xchg   %ax,%ax
80102f1d:	66 90                	xchg   %ax,%ax
80102f1f:	90                   	nop

80102f20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f24:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f2a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f2b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f2e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f31:	39 de                	cmp    %ebx,%esi
80102f33:	73 3c                	jae    80102f71 <mpsearch1+0x51>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f3f:	00 
80102f40:	c7 44 24 04 78 7c 10 	movl   $0x80107c78,0x4(%esp)
80102f47:	80 
80102f48:	89 34 24             	mov    %esi,(%esp)
80102f4b:	e8 80 14 00 00       	call   801043d0 <memcmp>
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 16                	jne    80102f6a <mpsearch1+0x4a>
80102f54:	31 c9                	xor    %ecx,%ecx
80102f56:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f58:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f5c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f5f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f61:	83 fa 10             	cmp    $0x10,%edx
80102f64:	75 f2                	jne    80102f58 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f66:	84 c9                	test   %cl,%cl
80102f68:	74 10                	je     80102f7a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f6a:	83 c6 10             	add    $0x10,%esi
80102f6d:	39 f3                	cmp    %esi,%ebx
80102f6f:	77 c7                	ja     80102f38 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f71:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f74:	31 c0                	xor    %eax,%eax
}
80102f76:	5b                   	pop    %ebx
80102f77:	5e                   	pop    %esi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	89 f0                	mov    %esi,%eax
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fa0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fa7:	c1 e0 08             	shl    $0x8,%eax
80102faa:	09 d0                	or     %edx,%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	75 1b                	jne    80102fce <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fb3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fc1:	c1 e0 08             	shl    $0x8,%eax
80102fc4:	09 d0                	or     %edx,%eax
80102fc6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fc9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fce:	ba 00 04 00 00       	mov    $0x400,%edx
80102fd3:	e8 48 ff ff ff       	call   80102f20 <mpsearch1>
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	0f 84 22 01 00 00    	je     80103104 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fe2:	8b 77 04             	mov    0x4(%edi),%esi
80102fe5:	85 f6                	test   %esi,%esi
80102fe7:	0f 84 30 01 00 00    	je     8010311d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102ffa:	00 
80102ffb:	c7 44 24 04 7d 7c 10 	movl   $0x80107c7d,0x4(%esp)
80103002:	80 
80103003:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103009:	e8 c2 13 00 00       	call   801043d0 <memcmp>
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 85 07 01 00 00    	jne    8010311d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103016:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010301d:	3c 04                	cmp    $0x4,%al
8010301f:	0f 85 0b 01 00 00    	jne    80103130 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103025:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 21                	je     80103051 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103030:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103032:	31 d2                	xor    %edx,%edx
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103038:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010303f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103040:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103043:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103045:	39 d0                	cmp    %edx,%eax
80103047:	7f ef                	jg     80103038 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103049:	84 c9                	test   %cl,%cl
8010304b:	0f 85 cc 00 00 00    	jne    8010311d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 c1 00 00 00    	je     8010311d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010305c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103062:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103067:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010306c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103073:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103079:	03 55 e4             	add    -0x1c(%ebp),%edx
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 c2                	cmp    %eax,%edx
80103082:	76 1b                	jbe    8010309f <mpinit+0x10f>
80103084:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103087:	80 f9 04             	cmp    $0x4,%cl
8010308a:	77 74                	ja     80103100 <mpinit+0x170>
8010308c:	ff 24 8d bc 7c 10 80 	jmp    *-0x7fef8344(,%ecx,4)
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103098:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309b:	39 c2                	cmp    %eax,%edx
8010309d:	77 e5                	ja     80103084 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010309f:	85 db                	test   %ebx,%ebx
801030a1:	0f 84 93 00 00 00    	je     8010313a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030ab:	74 12                	je     801030bf <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ad:	ba 22 00 00 00       	mov    $0x22,%edx
801030b2:	b8 70 00 00 00       	mov    $0x70,%eax
801030b7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b8:	b2 23                	mov    $0x23,%dl
801030ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030bb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030be:	ee                   	out    %al,(%dx)
  }
}
801030bf:	83 c4 1c             	add    $0x1c,%esp
801030c2:	5b                   	pop    %ebx
801030c3:	5e                   	pop    %esi
801030c4:	5f                   	pop    %edi
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030c8:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
801030ce:	83 fe 07             	cmp    $0x7,%esi
801030d1:	7f 17                	jg     801030ea <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030dd:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e4:	88 8e 80 37 11 80    	mov    %cl,-0x7feec880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030ea:	83 c0 14             	add    $0x14,%eax
      continue;
801030ed:	eb 91                	jmp    80103080 <mpinit+0xf0>
801030ef:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030f4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030f7:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
801030fd:	eb 81                	jmp    80103080 <mpinit+0xf0>
801030ff:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103100:	31 db                	xor    %ebx,%ebx
80103102:	eb 83                	jmp    80103087 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103104:	ba 00 00 01 00       	mov    $0x10000,%edx
80103109:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010310e:	e8 0d fe ff ff       	call   80102f20 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103113:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103115:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103117:	0f 85 c5 fe ff ff    	jne    80102fe2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010311d:	c7 04 24 82 7c 10 80 	movl   $0x80107c82,(%esp)
80103124:	e8 37 d2 ff ff       	call   80100360 <panic>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103130:	3c 01                	cmp    $0x1,%al
80103132:	0f 84 ed fe ff ff    	je     80103025 <mpinit+0x95>
80103138:	eb e3                	jmp    8010311d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010313a:	c7 04 24 9c 7c 10 80 	movl   $0x80107c9c,(%esp)
80103141:	e8 1a d2 ff ff       	call   80100360 <panic>
80103146:	66 90                	xchg   %ax,%ax
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103150:	55                   	push   %ebp
80103151:	ba 21 00 00 00       	mov    $0x21,%edx
80103156:	89 e5                	mov    %esp,%ebp
80103158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315d:	ee                   	out    %al,(%dx)
8010315e:	b2 a1                	mov    $0xa1,%dl
80103160:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
80103163:	66 90                	xchg   %ax,%ax
80103165:	66 90                	xchg   %ax,%ax
80103167:	66 90                	xchg   %ax,%ax
80103169:	66 90                	xchg   %ax,%ax
8010316b:	66 90                	xchg   %ax,%ax
8010316d:	66 90                	xchg   %ax,%ax
8010316f:	90                   	nop

80103170 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
80103179:	8b 75 08             	mov    0x8(%ebp),%esi
8010317c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010317f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103185:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010318b:	e8 d0 db ff ff       	call   80100d60 <filealloc>
80103190:	85 c0                	test   %eax,%eax
80103192:	89 06                	mov    %eax,(%esi)
80103194:	0f 84 a4 00 00 00    	je     8010323e <pipealloc+0xce>
8010319a:	e8 c1 db ff ff       	call   80100d60 <filealloc>
8010319f:	85 c0                	test   %eax,%eax
801031a1:	89 03                	mov    %eax,(%ebx)
801031a3:	0f 84 87 00 00 00    	je     80103230 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031a9:	e8 f2 f2 ff ff       	call   801024a0 <kalloc>
801031ae:	85 c0                	test   %eax,%eax
801031b0:	89 c7                	mov    %eax,%edi
801031b2:	74 7c                	je     80103230 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031bb:	00 00 00 
  p->writeopen = 1;
801031be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031c5:	00 00 00 
  p->nwrite = 0;
801031c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031cf:	00 00 00 
  p->nread = 0;
801031d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031d9:	00 00 00 
  initlock(&p->lock, "pipe");
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	c7 44 24 04 d0 7c 10 	movl   $0x80107cd0,0x4(%esp)
801031e6:	80 
801031e7:	e8 64 0f 00 00       	call   80104150 <initlock>
  (*f0)->type = FD_PIPE;
801031ec:	8b 06                	mov    (%esi),%eax
801031ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031f4:	8b 06                	mov    (%esi),%eax
801031f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031fa:	8b 06                	mov    (%esi),%eax
801031fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103200:	8b 06                	mov    (%esi),%eax
80103202:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103205:	8b 03                	mov    (%ebx),%eax
80103207:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010320d:	8b 03                	mov    (%ebx),%eax
8010320f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103213:	8b 03                	mov    (%ebx),%eax
80103215:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103219:	8b 03                	mov    (%ebx),%eax
  return 0;
8010321b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010321d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103220:	83 c4 1c             	add    $0x1c,%esp
80103223:	89 d8                	mov    %ebx,%eax
80103225:	5b                   	pop    %ebx
80103226:	5e                   	pop    %esi
80103227:	5f                   	pop    %edi
80103228:	5d                   	pop    %ebp
80103229:	c3                   	ret    
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103230:	8b 06                	mov    (%esi),%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	74 08                	je     8010323e <pipealloc+0xce>
    fileclose(*f0);
80103236:	89 04 24             	mov    %eax,(%esp)
80103239:	e8 e2 db ff ff       	call   80100e20 <fileclose>
  if(*f1)
8010323e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103240:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103245:	85 c0                	test   %eax,%eax
80103247:	74 d7                	je     80103220 <pipealloc+0xb0>
    fileclose(*f1);
80103249:	89 04 24             	mov    %eax,(%esp)
8010324c:	e8 cf db ff ff       	call   80100e20 <fileclose>
  return -1;
}
80103251:	83 c4 1c             	add    $0x1c,%esp
80103254:	89 d8                	mov    %ebx,%eax
80103256:	5b                   	pop    %ebx
80103257:	5e                   	pop    %esi
80103258:	5f                   	pop    %edi
80103259:	5d                   	pop    %ebp
8010325a:	c3                   	ret    
8010325b:	90                   	nop
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	56                   	push   %esi
80103264:	53                   	push   %ebx
80103265:	83 ec 10             	sub    $0x10,%esp
80103268:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010326e:	89 1c 24             	mov    %ebx,(%esp)
80103271:	e8 ca 0f 00 00       	call   80104240 <acquire>
  if(writable){
80103276:	85 f6                	test   %esi,%esi
80103278:	74 3e                	je     801032b8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010327a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103280:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103287:	00 00 00 
    wakeup(&p->nread);
8010328a:	89 04 24             	mov    %eax,(%esp)
8010328d:	e8 ee 0b 00 00       	call   80103e80 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103292:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103298:	85 d2                	test   %edx,%edx
8010329a:	75 0a                	jne    801032a6 <pipeclose+0x46>
8010329c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 32                	je     801032d8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032af:	e9 7c 10 00 00       	jmp    80104330 <release>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032c5:	00 00 00 
    wakeup(&p->nwrite);
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 b0 0b 00 00       	call   80103e80 <wakeup>
801032d0:	eb c0                	jmp    80103292 <pipeclose+0x32>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032d8:	89 1c 24             	mov    %ebx,(%esp)
801032db:	e8 50 10 00 00       	call   80104330 <release>
    kfree((char*)p);
801032e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032e9:	e9 02 f0 ff ff       	jmp    801022f0 <kfree>
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	e8 3c 0f 00 00       	call   80104240 <acquire>
  for(i = 0; i < n; i++){
80103304:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103307:	85 c9                	test   %ecx,%ecx
80103309:	0f 8e b2 00 00 00    	jle    801033c1 <pipewrite+0xd1>
8010330f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103312:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103318:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010331e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103327:	03 4d 10             	add    0x10(%ebp),%ecx
8010332a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010332d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103333:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103339:	39 c8                	cmp    %ecx,%eax
8010333b:	74 38                	je     80103375 <pipewrite+0x85>
8010333d:	eb 55                	jmp    80103394 <pipewrite+0xa4>
8010333f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103340:	e8 ab 03 00 00       	call   801036f0 <myproc>
80103345:	8b 40 24             	mov    0x24(%eax),%eax
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 33                	jne    8010337f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010334c:	89 3c 24             	mov    %edi,(%esp)
8010334f:	e8 2c 0b 00 00       	call   80103e80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103354:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103358:	89 34 24             	mov    %esi,(%esp)
8010335b:	e8 80 09 00 00       	call   80103ce0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103360:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103366:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010336c:	05 00 02 00 00       	add    $0x200,%eax
80103371:	39 c2                	cmp    %eax,%edx
80103373:	75 23                	jne    80103398 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103375:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010337b:	85 d2                	test   %edx,%edx
8010337d:	75 c1                	jne    80103340 <pipewrite+0x50>
        release(&p->lock);
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 a9 0f 00 00       	call   80104330 <release>
        return -1;
80103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010338c:	83 c4 1c             	add    $0x1c,%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103394:	89 c2                	mov    %eax,%edx
80103396:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339b:	8d 42 01             	lea    0x1(%edx),%eax
8010339e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ae:	0f b6 09             	movzbl (%ecx),%ecx
801033b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033bb:	0f 85 6c ff ff ff    	jne    8010332d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 b1 0a 00 00       	call   80103e80 <wakeup>
  release(&p->lock);
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 59 0f 00 00       	call   80104330 <release>
  return n;
801033d7:	8b 45 10             	mov    0x10(%ebp),%eax
801033da:	eb b0                	jmp    8010338c <pipewrite+0x9c>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ef:	89 34 24             	mov    %esi,(%esp)
801033f2:	e8 49 0e 00 00       	call   80104240 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103403:	75 5b                	jne    80103460 <piperead+0x80>
80103405:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010340b:	85 db                	test   %ebx,%ebx
8010340d:	74 51                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010340f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103415:	eb 25                	jmp    8010343c <piperead+0x5c>
80103417:	90                   	nop
80103418:	89 74 24 04          	mov    %esi,0x4(%esp)
8010341c:	89 1c 24             	mov    %ebx,(%esp)
8010341f:	e8 bc 08 00 00       	call   80103ce0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103424:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103430:	75 2e                	jne    80103460 <piperead+0x80>
80103432:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103438:	85 d2                	test   %edx,%edx
8010343a:	74 24                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
8010343c:	e8 af 02 00 00       	call   801036f0 <myproc>
80103441:	8b 48 24             	mov    0x24(%eax),%ecx
80103444:	85 c9                	test   %ecx,%ecx
80103446:	74 d0                	je     80103418 <piperead+0x38>
      release(&p->lock);
80103448:	89 34 24             	mov    %esi,(%esp)
8010344b:	e8 e0 0e 00 00       	call   80104330 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103450:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103460:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103463:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103465:	85 d2                	test   %edx,%edx
80103467:	7f 2b                	jg     80103494 <piperead+0xb4>
80103469:	eb 31                	jmp    8010349c <piperead+0xbc>
8010346b:	90                   	nop
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103470:	8d 48 01             	lea    0x1(%eax),%ecx
80103473:	25 ff 01 00 00       	and    $0x1ff,%eax
80103478:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010347e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103483:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103486:	83 c3 01             	add    $0x1,%ebx
80103489:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010348c:	74 0e                	je     8010349c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010348e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103494:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010349a:	75 d4                	jne    80103470 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010349c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034a2:	89 04 24             	mov    %eax,(%esp)
801034a5:	e8 d6 09 00 00       	call   80103e80 <wakeup>
  release(&p->lock);
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 7e 0e 00 00       	call   80104330 <release>
  return i;
}
801034b2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034b5:	89 d8                	mov    %ebx,%eax
}
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;
	int page_id;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034c4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034c9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;
	int page_id;
  acquire(&ptable.lock);
801034cc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801034d3:	e8 68 0d 00 00       	call   80104240 <acquire>
801034d8:	eb 18                	jmp    801034f2 <allocproc+0x32>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801034e6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801034ec:	0f 84 ce 00 00 00    	je     801035c0 <allocproc+0x100>
    if(p->state == UNUSED)
801034f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801034f5:	85 c0                	test   %eax,%eax
801034f7:	75 e7                	jne    801034e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801034fe:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103505:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010350c:	8d 50 01             	lea    0x1(%eax),%edx
8010350f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103515:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103518:	e8 13 0e 00 00       	call   80104330 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010351d:	e8 7e ef ff ff       	call   801024a0 <kalloc>
80103522:	85 c0                	test   %eax,%eax
80103524:	89 43 08             	mov    %eax,0x8(%ebx)
80103527:	0f 84 a7 00 00 00    	je     801035d4 <allocproc+0x114>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010352d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103533:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103538:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010353b:	c7 40 14 85 55 10 80 	movl   $0x80105585,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103542:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103549:	00 
8010354a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103551:	00 
80103552:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103555:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103558:	e8 23 0e 00 00       	call   80104380 <memset>
  p->context->eip = (uint)forkret;
8010355d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103560:	c7 40 10 e0 35 10 80 	movl   $0x801035e0,0x10(%eax)
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
80103567:	89 d8                	mov    %ebx,%eax
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103569:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
80103570:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103573:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010357a:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
8010357d:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
80103584:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103587:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010358e:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
80103591:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
80103598:	ff ff ff 
		p->pages[page_id].vaddr = 0;
8010359b:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801035a2:	00 00 00 
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801035a5:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
801035ac:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801035af:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801035b6:	00 00 00 
	}
  return p;
}
801035b9:	83 c4 14             	add    $0x14,%esp
801035bc:	5b                   	pop    %ebx
801035bd:	5d                   	pop    %ebp
801035be:	c3                   	ret    
801035bf:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801035c0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801035c7:	e8 64 0d 00 00       	call   80104330 <release>
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  return p;
}
801035cc:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801035cf:	31 c0                	xor    %eax,%eax
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  return p;
}
801035d1:	5b                   	pop    %ebx
801035d2:	5d                   	pop    %ebp
801035d3:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801035d4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035db:	eb dc                	jmp    801035b9 <allocproc+0xf9>
801035dd:	8d 76 00             	lea    0x0(%esi),%esi

801035e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035e6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801035ed:	e8 3e 0d 00 00       	call   80104330 <release>

  if (first) {
801035f2:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	75 05                	jne    80103600 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035fb:	c9                   	leave  
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103607:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010360e:	00 00 00 
    iinit(ROOTDEV);
80103611:	e8 5a de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103616:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010361d:	e8 4e f4 ff ff       	call   80102a70 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103622:	c9                   	leave  
80103623:	c3                   	ret    
80103624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010362a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103630 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103636:	c7 44 24 04 d5 7c 10 	movl   $0x80107cd5,0x4(%esp)
8010363d:	80 
8010363e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103645:	e8 06 0b 00 00       	call   80104150 <initlock>
}
8010364a:	c9                   	leave  
8010364b:	c3                   	ret    
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103650 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
80103655:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103658:	9c                   	pushf  
80103659:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010365a:	f6 c4 02             	test   $0x2,%ah
8010365d:	75 57                	jne    801036b6 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010365f:	e8 fc f0 ff ff       	call   80102760 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103664:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
8010366a:	85 f6                	test   %esi,%esi
8010366c:	7e 3c                	jle    801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010366e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103675:	39 c2                	cmp    %eax,%edx
80103677:	74 2d                	je     801036a6 <mycpu+0x56>
80103679:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010367e:	31 d2                	xor    %edx,%edx
80103680:	83 c2 01             	add    $0x1,%edx
80103683:	39 f2                	cmp    %esi,%edx
80103685:	74 23                	je     801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103687:	0f b6 19             	movzbl (%ecx),%ebx
8010368a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103690:	39 c3                	cmp    %eax,%ebx
80103692:	75 ec                	jne    80103680 <mycpu+0x30>
      return &cpus[i];
80103694:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036a0:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
801036a5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036a6:	31 d2                	xor    %edx,%edx
801036a8:	eb ea                	jmp    80103694 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801036aa:	c7 04 24 dc 7c 10 80 	movl   $0x80107cdc,(%esp)
801036b1:	e8 aa cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801036b6:	c7 04 24 b8 7d 10 80 	movl   $0x80107db8,(%esp)
801036bd:	e8 9e cc ff ff       	call   80100360 <panic>
801036c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036d6:	e8 75 ff ff ff       	call   80103650 <mycpu>
}
801036db:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036dc:	2d 80 37 11 80       	sub    $0x80113780,%eax
801036e1:	c1 f8 04             	sar    $0x4,%eax
801036e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ea:	c3                   	ret    
801036eb:	90                   	nop
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036f7:	e8 04 0b 00 00       	call   80104200 <pushcli>
  c = mycpu();
801036fc:	e8 4f ff ff ff       	call   80103650 <mycpu>
  p = c->proc;
80103701:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103707:	e8 b4 0b 00 00       	call   801042c0 <popcli>
  return p;
}
8010370c:	83 c4 04             	add    $0x4,%esp
8010370f:	89 d8                	mov    %ebx,%eax
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    
80103714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010371a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103720 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
	int page_id;
  extern char _binary_initcode_start[], _binary_initcode_size[];
	
  p = allocproc();
80103727:	e8 94 fd ff ff       	call   801034c0 <allocproc>
8010372c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010372e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103733:	e8 a8 36 00 00       	call   80106de0 <setupkvm>
80103738:	85 c0                	test   %eax,%eax
8010373a:	89 43 04             	mov    %eax,0x4(%ebx)
8010373d:	0f 84 2b 01 00 00    	je     8010386e <userinit+0x14e>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103743:	89 04 24             	mov    %eax,(%esp)
80103746:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010374d:	00 
8010374e:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
80103755:	80 
80103756:	e8 65 32 00 00       	call   801069c0 <inituvm>
  p->sz = PGSIZE;
8010375b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->tstack = 0; // For CS153 lab2 part 1
80103761:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103768:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010376f:	00 
80103770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103777:	00 
80103778:	8b 43 18             	mov    0x18(%ebx),%eax
8010377b:	89 04 24             	mov    %eax,(%esp)
8010377e:	e8 fd 0b 00 00       	call   80104380 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103783:	8b 43 18             	mov    0x18(%ebx),%eax
80103786:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010378b:	b9 23 00 00 00       	mov    $0x23,%ecx
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->tstack = 0; // For CS153 lab2 part 1
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103790:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103794:	8b 43 18             	mov    0x18(%ebx),%eax
80103797:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010379b:	8b 43 18             	mov    0x18(%ebx),%eax
8010379e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037a2:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037a6:	8b 43 18             	mov    0x18(%ebx),%eax
801037a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037ad:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037b1:	8b 43 18             	mov    0x18(%ebx),%eax
801037b4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037bb:	8b 43 18             	mov    0x18(%ebx),%eax
801037be:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037c5:	8b 43 18             	mov    0x18(%ebx),%eax
801037c8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
		p->pages[page_id].vaddr = 0;
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037cf:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037d2:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801037d9:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037dc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037e3:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037e6:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
801037ed:	ff ff ff 
		p->pages[page_id].vaddr = 0;
801037f0:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801037f7:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
801037fa:	c7 83 90 00 00 00 ff 	movl   $0xffffffff,0x90(%ebx)
80103801:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103804:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010380b:	00 00 00 
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
	for(page_id = 0; page_id < MAXPPP; page_id++){
		p->pages[page_id].id = -1;
8010380e:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
80103815:	ff ff ff 
		p->pages[page_id].vaddr = 0;
80103818:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010381f:	00 00 00 
	}
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103822:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103829:	00 
8010382a:	c7 44 24 04 05 7d 10 	movl   $0x80107d05,0x4(%esp)
80103831:	80 
80103832:	89 04 24             	mov    %eax,(%esp)
80103835:	e8 26 0d 00 00       	call   80104560 <safestrcpy>
  p->cwd = namei("/");
8010383a:	c7 04 24 0e 7d 10 80 	movl   $0x80107d0e,(%esp)
80103841:	e8 ba e6 ff ff       	call   80101f00 <namei>
80103846:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103849:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103850:	e8 eb 09 00 00       	call   80104240 <acquire>

  p->state = RUNNABLE;
80103855:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010385c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103863:	e8 c8 0a 00 00       	call   80104330 <release>
}
80103868:	83 c4 14             	add    $0x14,%esp
8010386b:	5b                   	pop    %ebx
8010386c:	5d                   	pop    %ebp
8010386d:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
	
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
8010386e:	c7 04 24 ec 7c 10 80 	movl   $0x80107cec,(%esp)
80103875:	e8 e6 ca ff ff       	call   80100360 <panic>
8010387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103880 <growproc>:
// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.

int
growproc(int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	83 ec 10             	sub    $0x10,%esp
80103888:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010388b:	e8 60 fe ff ff       	call   801036f0 <myproc>
80103890:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103892:	8b 00                	mov    (%eax),%eax
  if(curproc->tstack != 0)
80103894:	8b 53 7c             	mov    0x7c(%ebx),%edx
80103897:	85 d2                	test   %edx,%edx
80103899:	74 0d                	je     801038a8 <growproc+0x28>
   {
	  if(sz +n >= curproc->tstack-PGSIZE)
8010389b:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010389e:	81 ea 00 10 00 00    	sub    $0x1000,%edx
801038a4:	39 d1                	cmp    %edx,%ecx
801038a6:	73 60                	jae    80103908 <growproc+0x88>
		  return -1;
   }
//	resetpteu(curproc->pgdir,(char *)sz);
  if(n > 0){
801038a8:	83 fe 00             	cmp    $0x0,%esi
801038ab:	7e 3b                	jle    801038e8 <growproc+0x68>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038ad:	01 c6                	add    %eax,%esi
801038af:	89 74 24 08          	mov    %esi,0x8(%esp)
801038b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b7:	8b 43 04             	mov    0x4(%ebx),%eax
801038ba:	89 04 24             	mov    %eax,(%esp)
801038bd:	e8 5e 32 00 00       	call   80106b20 <allocuvm>
801038c2:	85 c0                	test   %eax,%eax
801038c4:	74 42                	je     80103908 <growproc+0x88>
      return -1;
		if(sz+PGSIZE<=curproc->tstack) return -1;
801038c6:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
801038cc:	3b 53 7c             	cmp    0x7c(%ebx),%edx
801038cf:	76 37                	jbe    80103908 <growproc+0x88>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
//	clearpteu(curproc->pgdir,(char *)sz);
  curproc->sz = sz;
801038d1:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038d3:	89 1c 24             	mov    %ebx,(%esp)
801038d6:	e8 d5 2f 00 00       	call   801068b0 <switchuvm>
  return 0;
801038db:	31 c0                	xor    %eax,%eax
}
801038dd:	83 c4 10             	add    $0x10,%esp
801038e0:	5b                   	pop    %ebx
801038e1:	5e                   	pop    %esi
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
801038e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
//	resetpteu(curproc->pgdir,(char *)sz);
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
		if(sz+PGSIZE<=curproc->tstack) return -1;
  } else if(n < 0){
801038e8:	74 e7                	je     801038d1 <growproc+0x51>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038ea:	01 c6                	add    %eax,%esi
801038ec:	89 74 24 08          	mov    %esi,0x8(%esp)
801038f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801038f4:	8b 43 04             	mov    0x4(%ebx),%eax
801038f7:	89 04 24             	mov    %eax,(%esp)
801038fa:	e8 41 34 00 00       	call   80106d40 <deallocuvm>
801038ff:	85 c0                	test   %eax,%eax
80103901:	75 ce                	jne    801038d1 <growproc+0x51>
80103903:	90                   	nop
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
  sz = curproc->sz;
  if(curproc->tstack != 0)
   {
	  if(sz +n >= curproc->tstack-PGSIZE)
		  return -1;
80103908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010390d:	eb ce                	jmp    801038dd <growproc+0x5d>
8010390f:	90                   	nop

80103910 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103919:	e8 d2 fd ff ff       	call   801036f0 <myproc>
8010391e:	89 c3                	mov    %eax,%ebx
	
  // Allocate process.
  if((np = allocproc()) == 0){
80103920:	e8 9b fb ff ff       	call   801034c0 <allocproc>
80103925:	85 c0                	test   %eax,%eax
80103927:	89 c7                	mov    %eax,%edi
80103929:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010392c:	0f 84 c4 00 00 00    	je     801039f6 <fork+0xe6>
    return -1;
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
80103932:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103935:	89 44 24 08          	mov    %eax,0x8(%esp)
80103939:	8b 03                	mov    (%ebx),%eax
8010393b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010393f:	8b 43 04             	mov    0x4(%ebx),%eax
80103942:	89 04 24             	mov    %eax,(%esp)
80103945:	e8 c6 35 00 00       	call   80106f10 <copyuvm>
8010394a:	85 c0                	test   %eax,%eax
8010394c:	89 47 04             	mov    %eax,0x4(%edi)
8010394f:	0f 84 a8 00 00 00    	je     801039fd <fork+0xed>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
80103955:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103958:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010395b:	89 41 7c             	mov    %eax,0x7c(%ecx)
  np->sz = curproc->sz;
8010395e:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103960:	8b 79 18             	mov    0x18(%ecx),%edi
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
  np->parent = curproc;
80103963:	89 59 14             	mov    %ebx,0x14(%ecx)
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	np->tstack = curproc->tstack;
  np->sz = curproc->sz;
80103966:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103968:	8b 73 18             	mov    0x18(%ebx),%esi
8010396b:	89 c8                	mov    %ecx,%eax
8010396d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103972:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103974:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103976:	8b 40 18             	mov    0x18(%eax),%eax
80103979:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103980:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103984:	85 c0                	test   %eax,%eax
80103986:	74 0f                	je     80103997 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103988:	89 04 24             	mov    %eax,(%esp)
8010398b:	e8 40 d4 ff ff       	call   80100dd0 <filedup>
80103990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103993:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103997:	83 c6 01             	add    $0x1,%esi
8010399a:	83 fe 10             	cmp    $0x10,%esi
8010399d:	75 e1                	jne    80103980 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010399f:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039a2:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039a5:	89 04 24             	mov    %eax,(%esp)
801039a8:	e8 d3 dc ff ff       	call   80101680 <idup>
801039ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039b0:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039b3:	8d 47 6c             	lea    0x6c(%edi),%eax
801039b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801039ba:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039c1:	00 
801039c2:	89 04 24             	mov    %eax,(%esp)
801039c5:	e8 96 0b 00 00       	call   80104560 <safestrcpy>

  pid = np->pid;
801039ca:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039cd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801039d4:	e8 67 08 00 00       	call   80104240 <acquire>

  np->state = RUNNABLE;
801039d9:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039e0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801039e7:	e8 44 09 00 00       	call   80104330 <release>
  return pid;
801039ec:	89 d8                	mov    %ebx,%eax
}
801039ee:	83 c4 1c             	add    $0x1c,%esp
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5f                   	pop    %edi
801039f4:	5d                   	pop    %ebp
801039f5:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();
	
  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039fb:	eb f1                	jmp    801039ee <fork+0xde>
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
    kfree(np->kstack);
801039fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a00:	8b 47 08             	mov    0x8(%edi),%eax
80103a03:	89 04 24             	mov    %eax,(%esp)
80103a06:	e8 e5 e8 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc. Changed the copyuvm for CS 153 lab2 part 1
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->tstack)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a10:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a17:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a1e:	eb ce                	jmp    801039ee <fork+0xde>

80103a20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a29:	e8 22 fc ff ff       	call   80103650 <mycpu>
80103a2e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a30:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a37:	00 00 00 
80103a3a:	8d 78 04             	lea    0x4(%eax),%edi
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a41:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a48:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a4d:	e8 ee 07 00 00       	call   80104240 <acquire>
80103a52:	eb 12                	jmp    80103a66 <scheduler+0x46>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a58:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103a5e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103a64:	74 52                	je     80103ab8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103a66:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a6a:	75 ec                	jne    80103a58 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a6c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a72:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a75:	81 c3 a0 00 00 00    	add    $0xa0,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a7b:	e8 30 2e 00 00       	call   801068b0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a80:	8b 83 7c ff ff ff    	mov    -0x84(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a86:	c7 83 6c ff ff ff 04 	movl   $0x4,-0x94(%ebx)
80103a8d:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103a90:	89 3c 24             	mov    %edi,(%esp)
80103a93:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a97:	e8 1f 0b 00 00       	call   801045bb <swtch>
      switchkvm();
80103a9c:	e8 ef 2d 00 00       	call   80106890 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aa1:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103aa7:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103aae:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab1:	75 b3                	jne    80103a66 <scheduler+0x46>
80103ab3:	90                   	nop
80103ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ab8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103abf:	e8 6c 08 00 00       	call   80104330 <release>

  }
80103ac4:	e9 77 ff ff ff       	jmp    80103a40 <scheduler+0x20>
80103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103ad8:	e8 13 fc ff ff       	call   801036f0 <myproc>

  if(!holding(&ptable.lock))
80103add:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103ae4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103ae6:	e8 e5 06 00 00       	call   801041d0 <holding>
80103aeb:	85 c0                	test   %eax,%eax
80103aed:	74 4f                	je     80103b3e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103aef:	e8 5c fb ff ff       	call   80103650 <mycpu>
80103af4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103afb:	75 65                	jne    80103b62 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103afd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b01:	74 53                	je     80103b56 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b03:	9c                   	pushf  
80103b04:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b05:	f6 c4 02             	test   $0x2,%ah
80103b08:	75 40                	jne    80103b4a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b0a:	e8 41 fb ff ff       	call   80103650 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b0f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b12:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b18:	e8 33 fb ff ff       	call   80103650 <mycpu>
80103b1d:	8b 40 04             	mov    0x4(%eax),%eax
80103b20:	89 1c 24             	mov    %ebx,(%esp)
80103b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b27:	e8 8f 0a 00 00       	call   801045bb <swtch>
  mycpu()->intena = intena;
80103b2c:	e8 1f fb ff ff       	call   80103650 <mycpu>
80103b31:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	5b                   	pop    %ebx
80103b3b:	5e                   	pop    %esi
80103b3c:	5d                   	pop    %ebp
80103b3d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b3e:	c7 04 24 10 7d 10 80 	movl   $0x80107d10,(%esp)
80103b45:	e8 16 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b4a:	c7 04 24 3c 7d 10 80 	movl   $0x80107d3c,(%esp)
80103b51:	e8 0a c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b56:	c7 04 24 2e 7d 10 80 	movl   $0x80107d2e,(%esp)
80103b5d:	e8 fe c7 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b62:	c7 04 24 22 7d 10 80 	movl   $0x80107d22,(%esp)
80103b69:	e8 f2 c7 ff ff       	call   80100360 <panic>
80103b6e:	66 90                	xchg   %ax,%ax

80103b70 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
//	int page_id;
  if(curproc == initproc)
80103b74:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b76:	53                   	push   %ebx
80103b77:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b7a:	e8 71 fb ff ff       	call   801036f0 <myproc>
  struct proc *p;
  int fd;
//	int page_id;
  if(curproc == initproc)
80103b7f:	3b 05 b8 b5 10 80    	cmp    0x8010b5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b85:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;
//	int page_id;
  if(curproc == initproc)
80103b87:	0f 84 fd 00 00 00    	je     80103c8a <exit+0x11a>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 10                	je     80103ba8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b98:	89 04 24             	mov    %eax,(%esp)
80103b9b:	e8 80 d2 ff ff       	call   80100e20 <fileclose>
      curproc->ofile[fd] = 0;
80103ba0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ba7:	00 
//	int page_id;
  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ba8:	83 c6 01             	add    $0x1,%esi
80103bab:	83 fe 10             	cmp    $0x10,%esi
80103bae:	75 e0                	jne    80103b90 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bb0:	e8 5b ef ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103bb5:	8b 43 68             	mov    0x68(%ebx),%eax
80103bb8:	89 04 24             	mov    %eax,(%esp)
80103bbb:	e8 10 dc ff ff       	call   801017d0 <iput>
  end_op();
80103bc0:	e8 bb ef ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103bc5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103bcc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bd3:	e8 68 06 00 00       	call   80104240 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103bd8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bdb:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103be0:	eb 14                	jmp    80103bf6 <exit+0x86>
80103be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103be8:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103bee:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103bf4:	74 20                	je     80103c16 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103bf6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bfa:	75 ec                	jne    80103be8 <exit+0x78>
80103bfc:	3b 42 20             	cmp    0x20(%edx),%eax
80103bff:	75 e7                	jne    80103be8 <exit+0x78>
      p->state = RUNNABLE;
80103c01:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c08:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103c0e:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103c14:	75 e0                	jne    80103bf6 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c16:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103c1b:	b9 54 3d 11 80       	mov    $0x80113d54,%ecx
80103c20:	eb 14                	jmp    80103c36 <exit+0xc6>
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c28:	81 c1 a0 00 00 00    	add    $0xa0,%ecx
80103c2e:	81 f9 54 65 11 80    	cmp    $0x80116554,%ecx
80103c34:	74 3c                	je     80103c72 <exit+0x102>
    if(p->parent == curproc){
80103c36:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c39:	75 ed                	jne    80103c28 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c3b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c3f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c42:	75 e4                	jne    80103c28 <exit+0xb8>
80103c44:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103c49:	eb 13                	jmp    80103c5e <exit+0xee>
80103c4b:	90                   	nop
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c50:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103c56:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103c5c:	74 ca                	je     80103c28 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c5e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c62:	75 ec                	jne    80103c50 <exit+0xe0>
80103c64:	3b 42 20             	cmp    0x20(%edx),%eax
80103c67:	75 e7                	jne    80103c50 <exit+0xe0>
      p->state = RUNNABLE;
80103c69:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c70:	eb de                	jmp    80103c50 <exit+0xe0>
	for(page_id = 0; page_id < MAXPPP; page_id++){
		if(p->pages[page_id].id != -1) shm_close(p->pages[page_id].id);
	}
*/
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c72:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c79:	e8 52 fe ff ff       	call   80103ad0 <sched>
  panic("zombie exit");
80103c7e:	c7 04 24 5d 7d 10 80 	movl   $0x80107d5d,(%esp)
80103c85:	e8 d6 c6 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
//	int page_id;
  if(curproc == initproc)
    panic("init exiting");
80103c8a:	c7 04 24 50 7d 10 80 	movl   $0x80107d50,(%esp)
80103c91:	e8 ca c6 ff ff       	call   80100360 <panic>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ca6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cad:	e8 8e 05 00 00       	call   80104240 <acquire>
  myproc()->state = RUNNABLE;
80103cb2:	e8 39 fa ff ff       	call   801036f0 <myproc>
80103cb7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cbe:	e8 0d fe ff ff       	call   80103ad0 <sched>
  release(&ptable.lock);
80103cc3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cca:	e8 61 06 00 00       	call   80104330 <release>
}
80103ccf:	c9                   	leave  
80103cd0:	c3                   	ret    
80103cd1:	eb 0d                	jmp    80103ce0 <sleep>
80103cd3:	90                   	nop
80103cd4:	90                   	nop
80103cd5:	90                   	nop
80103cd6:	90                   	nop
80103cd7:	90                   	nop
80103cd8:	90                   	nop
80103cd9:	90                   	nop
80103cda:	90                   	nop
80103cdb:	90                   	nop
80103cdc:	90                   	nop
80103cdd:	90                   	nop
80103cde:	90                   	nop
80103cdf:	90                   	nop

80103ce0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
80103ce9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103cef:	e8 fc f9 ff ff       	call   801036f0 <myproc>
  
  if(p == 0)
80103cf4:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103cf6:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103cf8:	0f 84 7c 00 00 00    	je     80103d7a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103cfe:	85 f6                	test   %esi,%esi
80103d00:	74 6c                	je     80103d6e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d02:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103d08:	74 46                	je     80103d50 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d0a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d11:	e8 2a 05 00 00       	call   80104240 <acquire>
    release(lk);
80103d16:	89 34 24             	mov    %esi,(%esp)
80103d19:	e8 12 06 00 00       	call   80104330 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d1e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d21:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d28:	e8 a3 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103d2d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d34:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d3b:	e8 f0 05 00 00       	call   80104330 <release>
    acquire(lk);
80103d40:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103d43:	83 c4 1c             	add    $0x1c,%esp
80103d46:	5b                   	pop    %ebx
80103d47:	5e                   	pop    %esi
80103d48:	5f                   	pop    %edi
80103d49:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d4a:	e9 f1 04 00 00       	jmp    80104240 <acquire>
80103d4f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d50:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d53:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d5a:	e8 71 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103d5f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d66:	83 c4 1c             	add    $0x1c,%esp
80103d69:	5b                   	pop    %ebx
80103d6a:	5e                   	pop    %esi
80103d6b:	5f                   	pop    %edi
80103d6c:	5d                   	pop    %ebp
80103d6d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d6e:	c7 04 24 6f 7d 10 80 	movl   $0x80107d6f,(%esp)
80103d75:	e8 e6 c5 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d7a:	c7 04 24 69 7d 10 80 	movl   $0x80107d69,(%esp)
80103d81:	e8 da c5 ff ff       	call   80100360 <panic>
80103d86:	8d 76 00             	lea    0x0(%esi),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
80103d95:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d98:	e8 53 f9 ff ff       	call   801036f0 <myproc>
  
  acquire(&ptable.lock);
80103d9d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103da4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103da6:	e8 95 04 00 00       	call   80104240 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dab:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dad:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103db2:	eb 12                	jmp    80103dc6 <wait+0x36>
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103dbe:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103dc4:	74 22                	je     80103de8 <wait+0x58>
      if(p->parent != curproc)
80103dc6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103dc9:	75 ed                	jne    80103db8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103dcb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dcf:	74 34                	je     80103e05 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ddc:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103de2:	75 e2                	jne    80103dc6 <wait+0x36>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103de8:	85 c0                	test   %eax,%eax
80103dea:	74 6e                	je     80103e5a <wait+0xca>
80103dec:	8b 46 24             	mov    0x24(%esi),%eax
80103def:	85 c0                	test   %eax,%eax
80103df1:	75 67                	jne    80103e5a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103df3:	c7 44 24 04 20 3d 11 	movl   $0x80113d20,0x4(%esp)
80103dfa:	80 
80103dfb:	89 34 24             	mov    %esi,(%esp)
80103dfe:	e8 dd fe ff ff       	call   80103ce0 <sleep>
  }
80103e03:	eb a6                	jmp    80103dab <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e05:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e08:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e0b:	89 04 24             	mov    %eax,(%esp)
80103e0e:	e8 dd e4 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e13:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e16:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e1d:	89 04 24             	mov    %eax,(%esp)
80103e20:	e8 3b 2f 00 00       	call   80106d60 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103e25:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e2c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e33:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e3a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e3e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e45:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e4c:	e8 df 04 00 00       	call   80104330 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e51:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e54:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e56:	5b                   	pop    %ebx
80103e57:	5e                   	pop    %esi
80103e58:	5d                   	pop    %ebp
80103e59:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e5a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e61:	e8 ca 04 00 00       	call   80104330 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e66:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e6e:	5b                   	pop    %ebx
80103e6f:	5e                   	pop    %esi
80103e70:	5d                   	pop    %ebp
80103e71:	c3                   	ret    
80103e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	53                   	push   %ebx
80103e84:	83 ec 14             	sub    $0x14,%esp
80103e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e8a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e91:	e8 aa 03 00 00       	call   80104240 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e96:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e9b:	eb 0f                	jmp    80103eac <wakeup+0x2c>
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
80103ea0:	05 a0 00 00 00       	add    $0xa0,%eax
80103ea5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103eaa:	74 24                	je     80103ed0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103eac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eb0:	75 ee                	jne    80103ea0 <wakeup+0x20>
80103eb2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103eb5:	75 e9                	jne    80103ea0 <wakeup+0x20>
      p->state = RUNNABLE;
80103eb7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebe:	05 a0 00 00 00       	add    $0xa0,%eax
80103ec3:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103ec8:	75 e2                	jne    80103eac <wakeup+0x2c>
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ed0:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103ed7:	83 c4 14             	add    $0x14,%esp
80103eda:	5b                   	pop    %ebx
80103edb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103edc:	e9 4f 04 00 00       	jmp    80104330 <release>
80103ee1:	eb 0d                	jmp    80103ef0 <kill>
80103ee3:	90                   	nop
80103ee4:	90                   	nop
80103ee5:	90                   	nop
80103ee6:	90                   	nop
80103ee7:	90                   	nop
80103ee8:	90                   	nop
80103ee9:	90                   	nop
80103eea:	90                   	nop
80103eeb:	90                   	nop
80103eec:	90                   	nop
80103eed:	90                   	nop
80103eee:	90                   	nop
80103eef:	90                   	nop

80103ef0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 14             	sub    $0x14,%esp
80103ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103efa:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f01:	e8 3a 03 00 00       	call   80104240 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f0b:	eb 0f                	jmp    80103f1c <kill+0x2c>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
80103f10:	05 a0 00 00 00       	add    $0xa0,%eax
80103f15:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103f1a:	74 3c                	je     80103f58 <kill+0x68>
    if(p->pid == pid){
80103f1c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f1f:	75 ef                	jne    80103f10 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f21:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f25:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f2c:	74 1a                	je     80103f48 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f2e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f35:	e8 f6 03 00 00       	call   80104330 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f3a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f3d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f3f:	5b                   	pop    %ebx
80103f40:	5d                   	pop    %ebp
80103f41:	c3                   	ret    
80103f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f48:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f4f:	eb dd                	jmp    80103f2e <kill+0x3e>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f58:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f5f:	e8 cc 03 00 00       	call   80104330 <release>
  return -1;
}
80103f64:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f6c:	5b                   	pop    %ebx
80103f6d:	5d                   	pop    %ebp
80103f6e:	c3                   	ret    
80103f6f:	90                   	nop

80103f70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80103f7b:	83 ec 4c             	sub    $0x4c,%esp
80103f7e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f81:	eb 23                	jmp    80103fa6 <procdump+0x36>
80103f83:	90                   	nop
80103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f88:	c7 04 24 7f 82 10 80 	movl   $0x8010827f,(%esp)
80103f8f:	e8 bc c6 ff ff       	call   80100650 <cprintf>
80103f94:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9a:	81 fb c0 65 11 80    	cmp    $0x801165c0,%ebx
80103fa0:	0f 84 8a 00 00 00    	je     80104030 <procdump+0xc0>
    if(p->state == UNUSED)
80103fa6:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fa9:	85 c0                	test   %eax,%eax
80103fab:	74 e7                	je     80103f94 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fad:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fb0:	ba 80 7d 10 80       	mov    $0x80107d80,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fb5:	77 11                	ja     80103fc8 <procdump+0x58>
80103fb7:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fbe:	b8 80 7d 10 80       	mov    $0x80107d80,%eax
80103fc3:	85 d2                	test   %edx,%edx
80103fc5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fc8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fcf:	89 54 24 08          	mov    %edx,0x8(%esp)
80103fd3:	c7 04 24 84 7d 10 80 	movl   $0x80107d84,(%esp)
80103fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fde:	e8 6d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fe3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fe7:	75 9f                	jne    80103f88 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fe9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ff0:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ff3:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ff6:	8b 40 0c             	mov    0xc(%eax),%eax
80103ff9:	83 c0 08             	add    $0x8,%eax
80103ffc:	89 04 24             	mov    %eax,(%esp)
80103fff:	e8 6c 01 00 00       	call   80104170 <getcallerpcs>
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104008:	8b 17                	mov    (%edi),%edx
8010400a:	85 d2                	test   %edx,%edx
8010400c:	0f 84 76 ff ff ff    	je     80103f88 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104012:	89 54 24 04          	mov    %edx,0x4(%esp)
80104016:	83 c7 04             	add    $0x4,%edi
80104019:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
80104020:	e8 2b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104025:	39 f7                	cmp    %esi,%edi
80104027:	75 df                	jne    80104008 <procdump+0x98>
80104029:	e9 5a ff ff ff       	jmp    80103f88 <procdump+0x18>
8010402e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104030:	83 c4 4c             	add    $0x4c,%esp
80104033:	5b                   	pop    %ebx
80104034:	5e                   	pop    %esi
80104035:	5f                   	pop    %edi
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
80104038:	66 90                	xchg   %ax,%ax
8010403a:	66 90                	xchg   %ax,%ax
8010403c:	66 90                	xchg   %ax,%ax
8010403e:	66 90                	xchg   %ax,%ax

80104040 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 14             	sub    $0x14,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010404a:	c7 44 24 04 f8 7d 10 	movl   $0x80107df8,0x4(%esp)
80104051:	80 
80104052:	8d 43 04             	lea    0x4(%ebx),%eax
80104055:	89 04 24             	mov    %eax,(%esp)
80104058:	e8 f3 00 00 00       	call   80104150 <initlock>
  lk->name = name;
8010405d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104060:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104066:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010406d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104070:	83 c4 14             	add    $0x14,%esp
80104073:	5b                   	pop    %ebx
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret    
80104076:	8d 76 00             	lea    0x0(%esi),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
80104085:	83 ec 10             	sub    $0x10,%esp
80104088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010408b:	8d 73 04             	lea    0x4(%ebx),%esi
8010408e:	89 34 24             	mov    %esi,(%esp)
80104091:	e8 aa 01 00 00       	call   80104240 <acquire>
  while (lk->locked) {
80104096:	8b 13                	mov    (%ebx),%edx
80104098:	85 d2                	test   %edx,%edx
8010409a:	74 16                	je     801040b2 <acquiresleep+0x32>
8010409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040a0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040a4:	89 1c 24             	mov    %ebx,(%esp)
801040a7:	e8 34 fc ff ff       	call   80103ce0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040ac:	8b 03                	mov    (%ebx),%eax
801040ae:	85 c0                	test   %eax,%eax
801040b0:	75 ee                	jne    801040a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040b2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040b8:	e8 33 f6 ff ff       	call   801036f0 <myproc>
801040bd:	8b 40 10             	mov    0x10(%eax),%eax
801040c0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040c3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	5b                   	pop    %ebx
801040ca:	5e                   	pop    %esi
801040cb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040cc:	e9 5f 02 00 00       	jmp    80104330 <release>
801040d1:	eb 0d                	jmp    801040e0 <releasesleep>
801040d3:	90                   	nop
801040d4:	90                   	nop
801040d5:	90                   	nop
801040d6:	90                   	nop
801040d7:	90                   	nop
801040d8:	90                   	nop
801040d9:	90                   	nop
801040da:	90                   	nop
801040db:	90                   	nop
801040dc:	90                   	nop
801040dd:	90                   	nop
801040de:	90                   	nop
801040df:	90                   	nop

801040e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
801040e5:	83 ec 10             	sub    $0x10,%esp
801040e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040eb:	8d 73 04             	lea    0x4(%ebx),%esi
801040ee:	89 34 24             	mov    %esi,(%esp)
801040f1:	e8 4a 01 00 00       	call   80104240 <acquire>
  lk->locked = 0;
801040f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040fc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104103:	89 1c 24             	mov    %ebx,(%esp)
80104106:	e8 75 fd ff ff       	call   80103e80 <wakeup>
  release(&lk->lk);
8010410b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010410e:	83 c4 10             	add    $0x10,%esp
80104111:	5b                   	pop    %ebx
80104112:	5e                   	pop    %esi
80104113:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104114:	e9 17 02 00 00       	jmp    80104330 <release>
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
80104125:	83 ec 10             	sub    $0x10,%esp
80104128:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010412b:	8d 73 04             	lea    0x4(%ebx),%esi
8010412e:	89 34 24             	mov    %esi,(%esp)
80104131:	e8 0a 01 00 00       	call   80104240 <acquire>
  r = lk->locked;
80104136:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104138:	89 34 24             	mov    %esi,(%esp)
8010413b:	e8 f0 01 00 00       	call   80104330 <release>
  return r;
}
80104140:	83 c4 10             	add    $0x10,%esp
80104143:	89 d8                	mov    %ebx,%eax
80104145:	5b                   	pop    %ebx
80104146:	5e                   	pop    %esi
80104147:	5d                   	pop    %ebp
80104148:	c3                   	ret    
80104149:	66 90                	xchg   %ax,%ax
8010414b:	66 90                	xchg   %ax,%ax
8010414d:	66 90                	xchg   %ax,%ax
8010414f:	90                   	nop

80104150 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104156:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010415f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104162:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104169:	5d                   	pop    %ebp
8010416a:	c3                   	ret    
8010416b:	90                   	nop
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104179:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010417a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010417d:	31 c0                	xor    %eax,%eax
8010417f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104180:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104186:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010418c:	77 1a                	ja     801041a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010418e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104191:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104194:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104197:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104199:	83 f8 0a             	cmp    $0xa,%eax
8010419c:	75 e2                	jne    80104180 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010419e:	5b                   	pop    %ebx
8010419f:	5d                   	pop    %ebp
801041a0:	c3                   	ret    
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041af:	83 c0 01             	add    $0x1,%eax
801041b2:	83 f8 0a             	cmp    $0xa,%eax
801041b5:	74 e7                	je     8010419e <getcallerpcs+0x2e>
    pcs[i] = 0;
801041b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041be:	83 c0 01             	add    $0x1,%eax
801041c1:	83 f8 0a             	cmp    $0xa,%eax
801041c4:	75 e2                	jne    801041a8 <getcallerpcs+0x38>
801041c6:	eb d6                	jmp    8010419e <getcallerpcs+0x2e>
801041c8:	90                   	nop
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041d0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801041d1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041d3:	89 e5                	mov    %esp,%ebp
801041d5:	53                   	push   %ebx
801041d6:	83 ec 04             	sub    $0x4,%esp
801041d9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801041dc:	8b 0a                	mov    (%edx),%ecx
801041de:	85 c9                	test   %ecx,%ecx
801041e0:	74 10                	je     801041f2 <holding+0x22>
801041e2:	8b 5a 08             	mov    0x8(%edx),%ebx
801041e5:	e8 66 f4 ff ff       	call   80103650 <mycpu>
801041ea:	39 c3                	cmp    %eax,%ebx
801041ec:	0f 94 c0             	sete   %al
801041ef:	0f b6 c0             	movzbl %al,%eax
}
801041f2:	83 c4 04             	add    $0x4,%esp
801041f5:	5b                   	pop    %ebx
801041f6:	5d                   	pop    %ebp
801041f7:	c3                   	ret    
801041f8:	90                   	nop
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104200 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 04             	sub    $0x4,%esp
80104207:	9c                   	pushf  
80104208:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104209:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010420a:	e8 41 f4 ff ff       	call   80103650 <mycpu>
8010420f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	75 11                	jne    8010422a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104219:	e8 32 f4 ff ff       	call   80103650 <mycpu>
8010421e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104224:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010422a:	e8 21 f4 ff ff       	call   80103650 <mycpu>
8010422f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104236:	83 c4 04             	add    $0x4,%esp
80104239:	5b                   	pop    %ebx
8010423a:	5d                   	pop    %ebp
8010423b:	c3                   	ret    
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104240 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104247:	e8 b4 ff ff ff       	call   80104200 <pushcli>
  if(holding(lk))
8010424c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010424f:	8b 02                	mov    (%edx),%eax
80104251:	85 c0                	test   %eax,%eax
80104253:	75 43                	jne    80104298 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104255:	b9 01 00 00 00       	mov    $0x1,%ecx
8010425a:	eb 07                	jmp    80104263 <acquire+0x23>
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104260:	8b 55 08             	mov    0x8(%ebp),%edx
80104263:	89 c8                	mov    %ecx,%eax
80104265:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104268:	85 c0                	test   %eax,%eax
8010426a:	75 f4                	jne    80104260 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010426c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104271:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104274:	e8 d7 f3 ff ff       	call   80103650 <mycpu>
80104279:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010427c:	8b 45 08             	mov    0x8(%ebp),%eax
8010427f:	83 c0 0c             	add    $0xc,%eax
80104282:	89 44 24 04          	mov    %eax,0x4(%esp)
80104286:	8d 45 08             	lea    0x8(%ebp),%eax
80104289:	89 04 24             	mov    %eax,(%esp)
8010428c:	e8 df fe ff ff       	call   80104170 <getcallerpcs>
}
80104291:	83 c4 14             	add    $0x14,%esp
80104294:	5b                   	pop    %ebx
80104295:	5d                   	pop    %ebp
80104296:	c3                   	ret    
80104297:	90                   	nop

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104298:	8b 5a 08             	mov    0x8(%edx),%ebx
8010429b:	e8 b0 f3 ff ff       	call   80103650 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042a0:	39 c3                	cmp    %eax,%ebx
801042a2:	74 05                	je     801042a9 <acquire+0x69>
801042a4:	8b 55 08             	mov    0x8(%ebp),%edx
801042a7:	eb ac                	jmp    80104255 <acquire+0x15>
    panic("acquire");
801042a9:	c7 04 24 03 7e 10 80 	movl   $0x80107e03,(%esp)
801042b0:	e8 ab c0 ff ff       	call   80100360 <panic>
801042b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042c6:	9c                   	pushf  
801042c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042c8:	f6 c4 02             	test   $0x2,%ah
801042cb:	75 49                	jne    80104316 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042cd:	e8 7e f3 ff ff       	call   80103650 <mycpu>
801042d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042db:	85 d2                	test   %edx,%edx
801042dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801042e3:	78 25                	js     8010430a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042e5:	e8 66 f3 ff ff       	call   80103650 <mycpu>
801042ea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801042f0:	85 d2                	test   %edx,%edx
801042f2:	74 04                	je     801042f8 <popcli+0x38>
    sti();
}
801042f4:	c9                   	leave  
801042f5:	c3                   	ret    
801042f6:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042f8:	e8 53 f3 ff ff       	call   80103650 <mycpu>
801042fd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104303:	85 c0                	test   %eax,%eax
80104305:	74 ed                	je     801042f4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104307:	fb                   	sti    
    sti();
}
80104308:	c9                   	leave  
80104309:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010430a:	c7 04 24 22 7e 10 80 	movl   $0x80107e22,(%esp)
80104311:	e8 4a c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104316:	c7 04 24 0b 7e 10 80 	movl   $0x80107e0b,(%esp)
8010431d:	e8 3e c0 ff ff       	call   80100360 <panic>
80104322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	83 ec 10             	sub    $0x10,%esp
80104338:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010433b:	8b 03                	mov    (%ebx),%eax
8010433d:	85 c0                	test   %eax,%eax
8010433f:	75 0f                	jne    80104350 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104341:	c7 04 24 29 7e 10 80 	movl   $0x80107e29,(%esp)
80104348:	e8 13 c0 ff ff       	call   80100360 <panic>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104350:	8b 73 08             	mov    0x8(%ebx),%esi
80104353:	e8 f8 f2 ff ff       	call   80103650 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104358:	39 c6                	cmp    %eax,%esi
8010435a:	75 e5                	jne    80104341 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010435c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104363:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010436a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010436f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104375:	83 c4 10             	add    $0x10,%esp
80104378:	5b                   	pop    %ebx
80104379:	5e                   	pop    %esi
8010437a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010437b:	e9 40 ff ff ff       	jmp    801042c0 <popcli>

80104380 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	8b 55 08             	mov    0x8(%ebp),%edx
80104386:	57                   	push   %edi
80104387:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010438a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010438b:	f6 c2 03             	test   $0x3,%dl
8010438e:	75 05                	jne    80104395 <memset+0x15>
80104390:	f6 c1 03             	test   $0x3,%cl
80104393:	74 13                	je     801043a8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104395:	89 d7                	mov    %edx,%edi
80104397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010439a:	fc                   	cld    
8010439b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010439d:	5b                   	pop    %ebx
8010439e:	89 d0                	mov    %edx,%eax
801043a0:	5f                   	pop    %edi
801043a1:	5d                   	pop    %ebp
801043a2:	c3                   	ret    
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043ac:	c1 e9 02             	shr    $0x2,%ecx
801043af:	89 f8                	mov    %edi,%eax
801043b1:	89 fb                	mov    %edi,%ebx
801043b3:	c1 e0 18             	shl    $0x18,%eax
801043b6:	c1 e3 10             	shl    $0x10,%ebx
801043b9:	09 d8                	or     %ebx,%eax
801043bb:	09 f8                	or     %edi,%eax
801043bd:	c1 e7 08             	shl    $0x8,%edi
801043c0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043c2:	89 d7                	mov    %edx,%edi
801043c4:	fc                   	cld    
801043c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801043c7:	5b                   	pop    %ebx
801043c8:	89 d0                	mov    %edx,%eax
801043ca:	5f                   	pop    %edi
801043cb:	5d                   	pop    %ebp
801043cc:	c3                   	ret    
801043cd:	8d 76 00             	lea    0x0(%esi),%esi

801043d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 45 10             	mov    0x10(%ebp),%eax
801043d6:	57                   	push   %edi
801043d7:	56                   	push   %esi
801043d8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043db:	53                   	push   %ebx
801043dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043df:	85 c0                	test   %eax,%eax
801043e1:	8d 78 ff             	lea    -0x1(%eax),%edi
801043e4:	74 26                	je     8010440c <memcmp+0x3c>
    if(*s1 != *s2)
801043e6:	0f b6 03             	movzbl (%ebx),%eax
801043e9:	31 d2                	xor    %edx,%edx
801043eb:	0f b6 0e             	movzbl (%esi),%ecx
801043ee:	38 c8                	cmp    %cl,%al
801043f0:	74 16                	je     80104408 <memcmp+0x38>
801043f2:	eb 24                	jmp    80104418 <memcmp+0x48>
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801043fd:	83 c2 01             	add    $0x1,%edx
80104400:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104404:	38 c8                	cmp    %cl,%al
80104406:	75 10                	jne    80104418 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104408:	39 fa                	cmp    %edi,%edx
8010440a:	75 ec                	jne    801043f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010440c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010440d:	31 c0                	xor    %eax,%eax
}
8010440f:	5e                   	pop    %esi
80104410:	5f                   	pop    %edi
80104411:	5d                   	pop    %ebp
80104412:	c3                   	ret    
80104413:	90                   	nop
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104418:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104419:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010441b:	5e                   	pop    %esi
8010441c:	5f                   	pop    %edi
8010441d:	5d                   	pop    %ebp
8010441e:	c3                   	ret    
8010441f:	90                   	nop

80104420 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
80104427:	56                   	push   %esi
80104428:	8b 75 0c             	mov    0xc(%ebp),%esi
8010442b:	53                   	push   %ebx
8010442c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010442f:	39 c6                	cmp    %eax,%esi
80104431:	73 35                	jae    80104468 <memmove+0x48>
80104433:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104436:	39 c8                	cmp    %ecx,%eax
80104438:	73 2e                	jae    80104468 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010443a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010443c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010443f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104442:	74 1b                	je     8010445f <memmove+0x3f>
80104444:	f7 db                	neg    %ebx
80104446:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104449:	01 fb                	add    %edi,%ebx
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104450:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104454:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104457:	83 ea 01             	sub    $0x1,%edx
8010445a:	83 fa ff             	cmp    $0xffffffff,%edx
8010445d:	75 f1                	jne    80104450 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010445f:	5b                   	pop    %ebx
80104460:	5e                   	pop    %esi
80104461:	5f                   	pop    %edi
80104462:	5d                   	pop    %ebp
80104463:	c3                   	ret    
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104468:	31 d2                	xor    %edx,%edx
8010446a:	85 db                	test   %ebx,%ebx
8010446c:	74 f1                	je     8010445f <memmove+0x3f>
8010446e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104470:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104474:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104477:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010447a:	39 da                	cmp    %ebx,%edx
8010447c:	75 f2                	jne    80104470 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010447e:	5b                   	pop    %ebx
8010447f:	5e                   	pop    %esi
80104480:	5f                   	pop    %edi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret    
80104483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104493:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104494:	e9 87 ff ff ff       	jmp    80104420 <memmove>
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	8b 75 10             	mov    0x10(%ebp),%esi
801044a7:	53                   	push   %ebx
801044a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044ae:	85 f6                	test   %esi,%esi
801044b0:	74 30                	je     801044e2 <strncmp+0x42>
801044b2:	0f b6 01             	movzbl (%ecx),%eax
801044b5:	84 c0                	test   %al,%al
801044b7:	74 2f                	je     801044e8 <strncmp+0x48>
801044b9:	0f b6 13             	movzbl (%ebx),%edx
801044bc:	38 d0                	cmp    %dl,%al
801044be:	75 46                	jne    80104506 <strncmp+0x66>
801044c0:	8d 51 01             	lea    0x1(%ecx),%edx
801044c3:	01 ce                	add    %ecx,%esi
801044c5:	eb 14                	jmp    801044db <strncmp+0x3b>
801044c7:	90                   	nop
801044c8:	0f b6 02             	movzbl (%edx),%eax
801044cb:	84 c0                	test   %al,%al
801044cd:	74 31                	je     80104500 <strncmp+0x60>
801044cf:	0f b6 19             	movzbl (%ecx),%ebx
801044d2:	83 c2 01             	add    $0x1,%edx
801044d5:	38 d8                	cmp    %bl,%al
801044d7:	75 17                	jne    801044f0 <strncmp+0x50>
    n--, p++, q++;
801044d9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044db:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044dd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044e0:	75 e6                	jne    801044c8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044e2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801044e3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801044e5:	5e                   	pop    %esi
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
801044e8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044eb:	31 c0                	xor    %eax,%eax
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044f0:	0f b6 d3             	movzbl %bl,%edx
801044f3:	29 d0                	sub    %edx,%eax
}
801044f5:	5b                   	pop    %ebx
801044f6:	5e                   	pop    %esi
801044f7:	5d                   	pop    %ebp
801044f8:	c3                   	ret    
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104500:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104504:	eb ea                	jmp    801044f0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104506:	89 d3                	mov    %edx,%ebx
80104508:	eb e6                	jmp    801044f0 <strncmp+0x50>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
80104516:	56                   	push   %esi
80104517:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010451a:	53                   	push   %ebx
8010451b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010451e:	89 c2                	mov    %eax,%edx
80104520:	eb 19                	jmp    8010453b <strncpy+0x2b>
80104522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104528:	83 c3 01             	add    $0x1,%ebx
8010452b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010452f:	83 c2 01             	add    $0x1,%edx
80104532:	84 c9                	test   %cl,%cl
80104534:	88 4a ff             	mov    %cl,-0x1(%edx)
80104537:	74 09                	je     80104542 <strncpy+0x32>
80104539:	89 f1                	mov    %esi,%ecx
8010453b:	85 c9                	test   %ecx,%ecx
8010453d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104540:	7f e6                	jg     80104528 <strncpy+0x18>
    ;
  while(n-- > 0)
80104542:	31 c9                	xor    %ecx,%ecx
80104544:	85 f6                	test   %esi,%esi
80104546:	7e 0f                	jle    80104557 <strncpy+0x47>
    *s++ = 0;
80104548:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010454c:	89 f3                	mov    %esi,%ebx
8010454e:	83 c1 01             	add    $0x1,%ecx
80104551:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104553:	85 db                	test   %ebx,%ebx
80104555:	7f f1                	jg     80104548 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104557:	5b                   	pop    %ebx
80104558:	5e                   	pop    %esi
80104559:	5d                   	pop    %ebp
8010455a:	c3                   	ret    
8010455b:	90                   	nop
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104566:	56                   	push   %esi
80104567:	8b 45 08             	mov    0x8(%ebp),%eax
8010456a:	53                   	push   %ebx
8010456b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010456e:	85 c9                	test   %ecx,%ecx
80104570:	7e 26                	jle    80104598 <safestrcpy+0x38>
80104572:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104576:	89 c1                	mov    %eax,%ecx
80104578:	eb 17                	jmp    80104591 <safestrcpy+0x31>
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104580:	83 c2 01             	add    $0x1,%edx
80104583:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104587:	83 c1 01             	add    $0x1,%ecx
8010458a:	84 db                	test   %bl,%bl
8010458c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010458f:	74 04                	je     80104595 <safestrcpy+0x35>
80104591:	39 f2                	cmp    %esi,%edx
80104593:	75 eb                	jne    80104580 <safestrcpy+0x20>
    ;
  *s = 0;
80104595:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104598:	5b                   	pop    %ebx
80104599:	5e                   	pop    %esi
8010459a:	5d                   	pop    %ebp
8010459b:	c3                   	ret    
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <strlen>:

int
strlen(const char *s)
{
801045a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045a1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045a3:	89 e5                	mov    %esp,%ebp
801045a5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045a8:	80 3a 00             	cmpb   $0x0,(%edx)
801045ab:	74 0c                	je     801045b9 <strlen+0x19>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
801045b0:	83 c0 01             	add    $0x1,%eax
801045b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045b7:	75 f7                	jne    801045b0 <strlen+0x10>
    ;
  return n;
}
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    

801045bb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045c3:	55                   	push   %ebp
  pushl %ebx
801045c4:	53                   	push   %ebx
  pushl %esi
801045c5:	56                   	push   %esi
  pushl %edi
801045c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045c9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045cb:	5f                   	pop    %edi
  popl %esi
801045cc:	5e                   	pop    %esi
  popl %ebx
801045cd:	5b                   	pop    %ebx
  popl %ebp
801045ce:	5d                   	pop    %ebp
  ret
801045cf:	c3                   	ret    

801045d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
801045da:	e8 11 f1 ff ff       	call   801036f0 <myproc>
 	if(addr >= curproc->tstack && addr+4 <= USEREND){ // FOR CS153 lab2 part1
801045df:	39 58 7c             	cmp    %ebx,0x7c(%eax)
801045e2:	77 1c                	ja     80104600 <fetchint+0x30>
801045e4:	8d 53 04             	lea    0x4(%ebx),%edx
801045e7:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
801045ed:	77 11                	ja     80104600 <fetchint+0x30>
		goto exe;
	}
 	else if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
	exe:
  *ip = *(int*)(addr);
801045ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801045f2:	8b 13                	mov    (%ebx),%edx
801045f4:	89 10                	mov    %edx,(%eax)
  return 0;
801045f6:	31 c0                	xor    %eax,%eax
}
801045f8:	83 c4 04             	add    $0x4,%esp
801045fb:	5b                   	pop    %ebx
801045fc:	5d                   	pop    %ebp
801045fd:	c3                   	ret    
801045fe:	66 90                	xchg   %ax,%ax
{
	struct proc *curproc = myproc();
 	if(addr >= curproc->tstack && addr+4 <= USEREND){ // FOR CS153 lab2 part1
		goto exe;
	}
 	else if(addr >= curproc->sz || addr+4 > curproc->sz)
80104600:	8b 00                	mov    (%eax),%eax
80104602:	39 c3                	cmp    %eax,%ebx
80104604:	73 07                	jae    8010460d <fetchint+0x3d>
80104606:	8d 53 04             	lea    0x4(%ebx),%edx
80104609:	39 d0                	cmp    %edx,%eax
8010460b:	73 e2                	jae    801045ef <fetchint+0x1f>
    return -1;
8010460d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104612:	eb e4                	jmp    801045f8 <fetchint+0x28>
80104614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010461a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104620 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010462a:	e8 c1 f0 ff ff       	call   801036f0 <myproc>
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
8010462f:	39 58 7c             	cmp    %ebx,0x7c(%eax)
80104632:	77 44                	ja     80104678 <fetchstr+0x58>
80104634:	8d 53 04             	lea    0x4(%ebx),%edx
80104637:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
8010463d:	77 39                	ja     80104678 <fetchstr+0x58>
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
8010463f:	8b 55 0c             	mov    0xc(%ebp),%edx
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
80104642:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
80104648:	89 d8                	mov    %ebx,%eax
8010464a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
8010464c:	77 1e                	ja     8010466c <fetchstr+0x4c>
    if(*s == 0)
8010464e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104651:	75 0f                	jne    80104662 <fetchstr+0x42>
80104653:	eb 2b                	jmp    80104680 <fetchstr+0x60>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
80104658:	80 38 00             	cmpb   $0x0,(%eax)
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	74 1e                	je     80104680 <fetchstr+0x60>
  if(addr >= curproc->sz)
    return -1;
	exe:
  *pp = (char*)addr;
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
80104662:	83 c0 01             	add    $0x1,%eax
80104665:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010466a:	75 ec                	jne    80104658 <fetchstr+0x38>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010466c:	83 c4 04             	add    $0x4,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
    return -1;
8010466f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104674:	5b                   	pop    %ebx
80104675:	5d                   	pop    %ebp
80104676:	c3                   	ret    
80104677:	90                   	nop
{
  char *s, *ep;
  struct proc *curproc = myproc();
  if(addr >= curproc->tstack && addr+4 <= USEREND) // For CS153 lab2 part1
  	 goto exe;
  if(addr >= curproc->sz)
80104678:	3b 18                	cmp    (%eax),%ebx
8010467a:	72 c3                	jb     8010463f <fetchstr+0x1f>
8010467c:	eb ee                	jmp    8010466c <fetchstr+0x4c>
8010467e:	66 90                	xchg   %ax,%ax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104680:	83 c4 04             	add    $0x4,%esp
	exe:
  *pp = (char*)addr;
  ep = (char*)USEREND;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104683:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104685:	5b                   	pop    %ebx
80104686:	5d                   	pop    %ebp
80104687:	c3                   	ret    
80104688:	90                   	nop
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	8b 75 0c             	mov    0xc(%ebp),%esi
80104697:	53                   	push   %ebx
80104698:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010469b:	e8 50 f0 ff ff       	call   801036f0 <myproc>
801046a0:	89 75 0c             	mov    %esi,0xc(%ebp)
801046a3:	8b 40 18             	mov    0x18(%eax),%eax
801046a6:	8b 40 44             	mov    0x44(%eax),%eax
801046a9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046ad:	89 45 08             	mov    %eax,0x8(%ebp)
}
801046b0:	5b                   	pop    %ebx
801046b1:	5e                   	pop    %esi
801046b2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046b3:	e9 18 ff ff ff       	jmp    801045d0 <fetchint>
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	83 ec 20             	sub    $0x20,%esp
801046c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801046cb:	e8 20 f0 ff ff       	call   801036f0 <myproc>
  if(size < 0 || argint(n, &i) < 0)
801046d0:	85 db                	test   %ebx,%ebx
801046d2:	78 4c                	js     80104720 <argptr+0x60>
801046d4:	89 c6                	mov    %eax,%esi
801046d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046dd:	8b 45 08             	mov    0x8(%ebp),%eax
801046e0:	89 04 24             	mov    %eax,(%esp)
801046e3:	e8 a8 ff ff ff       	call   80104690 <argint>
801046e8:	85 c0                	test   %eax,%eax
801046ea:	78 34                	js     80104720 <argptr+0x60>
    return -1;
 	if(i >= curproc->tstack && i+size <= USEREND) // FOR CS153 lab2 part1 
801046ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ef:	3b 56 7c             	cmp    0x7c(%esi),%edx
801046f2:	73 1c                	jae    80104710 <argptr+0x50>
    	 goto exe;
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046f4:	8b 06                	mov    (%esi),%eax
801046f6:	39 c2                	cmp    %eax,%edx
801046f8:	73 26                	jae    80104720 <argptr+0x60>
801046fa:	01 d3                	add    %edx,%ebx
801046fc:	39 d8                	cmp    %ebx,%eax
801046fe:	72 20                	jb     80104720 <argptr+0x60>
    return -1;
	exe:
  *pp = (char*)i;
80104700:	8b 45 0c             	mov    0xc(%ebp),%eax
80104703:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104705:	83 c4 20             	add    $0x20,%esp
    	 goto exe;
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
80104708:	31 c0                	xor    %eax,%eax
}
8010470a:	5b                   	pop    %ebx
8010470b:	5e                   	pop    %esi
8010470c:	5d                   	pop    %ebp
8010470d:	c3                   	ret    
8010470e:	66 90                	xchg   %ax,%ax
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
 	if(i >= curproc->tstack && i+size <= USEREND) // FOR CS153 lab2 part1 
80104710:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80104713:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80104718:	76 e6                	jbe    80104700 <argptr+0x40>
8010471a:	eb d8                	jmp    801046f4 <argptr+0x34>
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
}
80104720:	83 c4 20             	add    $0x20,%esp
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
  if(size < 0 || argint(n, &i) < 0)
    return -1;
80104723:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
	exe:
  *pp = (char*)i;
  return 0;
}
80104728:	5b                   	pop    %ebx
80104729:	5e                   	pop    %esi
8010472a:	5d                   	pop    %ebp
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104736:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104739:	89 44 24 04          	mov    %eax,0x4(%esp)
8010473d:	8b 45 08             	mov    0x8(%ebp),%eax
80104740:	89 04 24             	mov    %eax,(%esp)
80104743:	e8 48 ff ff ff       	call   80104690 <argint>
80104748:	85 c0                	test   %eax,%eax
8010474a:	78 14                	js     80104760 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010474c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010474f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104756:	89 04 24             	mov    %eax,(%esp)
80104759:	e8 c2 fe ff ff       	call   80104620 <fetchstr>
}
8010475e:	c9                   	leave  
8010475f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104765:	c9                   	leave  
80104766:	c3                   	ret    
80104767:	89 f6                	mov    %esi,%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104778:	e8 73 ef ff ff       	call   801036f0 <myproc>

  num = curproc->tf->eax;
8010477d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104780:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104782:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104785:	8d 50 ff             	lea    -0x1(%eax),%edx
80104788:	83 fa 16             	cmp    $0x16,%edx
8010478b:	77 1b                	ja     801047a8 <syscall+0x38>
8010478d:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
80104794:	85 d2                	test   %edx,%edx
80104796:	74 10                	je     801047a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104798:	ff d2                	call   *%edx
8010479a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010479d:	83 c4 10             	add    $0x10,%esp
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5d                   	pop    %ebp
801047a3:	c3                   	ret    
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801047ac:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047af:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047b3:	8b 43 10             	mov    0x10(%ebx),%eax
801047b6:	c7 04 24 31 7e 10 80 	movl   $0x80107e31,(%esp)
801047bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c1:	e8 8a be ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047c6:	8b 43 18             	mov    0x18(%ebx),%eax
801047c9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047d0:	83 c4 10             	add    $0x10,%esp
801047d3:	5b                   	pop    %ebx
801047d4:	5e                   	pop    %esi
801047d5:	5d                   	pop    %ebp
801047d6:	c3                   	ret    
801047d7:	66 90                	xchg   %ax,%ax
801047d9:	66 90                	xchg   %ax,%ax
801047db:	66 90                	xchg   %ax,%ax
801047dd:	66 90                	xchg   %ax,%ax
801047df:	90                   	nop

801047e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	89 c3                	mov    %eax,%ebx
801047e6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801047e9:	e8 02 ef ff ff       	call   801036f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801047ee:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801047f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801047f4:	85 c9                	test   %ecx,%ecx
801047f6:	74 18                	je     80104810 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801047f8:	83 c2 01             	add    $0x1,%edx
801047fb:	83 fa 10             	cmp    $0x10,%edx
801047fe:	75 f0                	jne    801047f0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104800:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104808:	5b                   	pop    %ebx
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	90                   	nop
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104810:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104814:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104817:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104819:	5b                   	pop    %ebx
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 4c             	sub    $0x4c,%esp
80104829:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010482c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010482f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104832:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104836:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104839:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010483c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010483f:	e8 dc d6 ff ff       	call   80101f20 <nameiparent>
80104844:	85 c0                	test   %eax,%eax
80104846:	89 c7                	mov    %eax,%edi
80104848:	0f 84 da 00 00 00    	je     80104928 <create+0x108>
    return 0;
  ilock(dp);
8010484e:	89 04 24             	mov    %eax,(%esp)
80104851:	e8 5a ce ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104856:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104859:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104861:	89 3c 24             	mov    %edi,(%esp)
80104864:	e8 57 d3 ff ff       	call   80101bc0 <dirlookup>
80104869:	85 c0                	test   %eax,%eax
8010486b:	89 c6                	mov    %eax,%esi
8010486d:	74 41                	je     801048b0 <create+0x90>
    iunlockput(dp);
8010486f:	89 3c 24             	mov    %edi,(%esp)
80104872:	e8 99 d0 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104877:	89 34 24             	mov    %esi,(%esp)
8010487a:	e8 31 ce ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010487f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104884:	75 12                	jne    80104898 <create+0x78>
80104886:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010488b:	89 f0                	mov    %esi,%eax
8010488d:	75 09                	jne    80104898 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010488f:	83 c4 4c             	add    $0x4c,%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5f                   	pop    %edi
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    
80104897:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104898:	89 34 24             	mov    %esi,(%esp)
8010489b:	e8 70 d0 ff ff       	call   80101910 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048a0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048a3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048a5:	5b                   	pop    %ebx
801048a6:	5e                   	pop    %esi
801048a7:	5f                   	pop    %edi
801048a8:	5d                   	pop    %ebp
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b8:	8b 07                	mov    (%edi),%eax
801048ba:	89 04 24             	mov    %eax,(%esp)
801048bd:	e8 5e cc ff ff       	call   80101520 <ialloc>
801048c2:	85 c0                	test   %eax,%eax
801048c4:	89 c6                	mov    %eax,%esi
801048c6:	0f 84 bf 00 00 00    	je     8010498b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801048cc:	89 04 24             	mov    %eax,(%esp)
801048cf:	e8 dc cd ff ff       	call   801016b0 <ilock>
  ip->major = major;
801048d4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801048d8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048dc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048e0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048e4:	b8 01 00 00 00       	mov    $0x1,%eax
801048e9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048ed:	89 34 24             	mov    %esi,(%esp)
801048f0:	e8 fb cc ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048f5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801048fa:	74 34                	je     80104930 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048fc:	8b 46 04             	mov    0x4(%esi),%eax
801048ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104903:	89 3c 24             	mov    %edi,(%esp)
80104906:	89 44 24 08          	mov    %eax,0x8(%esp)
8010490a:	e8 11 d5 ff ff       	call   80101e20 <dirlink>
8010490f:	85 c0                	test   %eax,%eax
80104911:	78 6c                	js     8010497f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104913:	89 3c 24             	mov    %edi,(%esp)
80104916:	e8 f5 cf ff ff       	call   80101910 <iunlockput>

  return ip;
}
8010491b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010491e:	89 f0                	mov    %esi,%eax
}
80104920:	5b                   	pop    %ebx
80104921:	5e                   	pop    %esi
80104922:	5f                   	pop    %edi
80104923:	5d                   	pop    %ebp
80104924:	c3                   	ret    
80104925:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104928:	31 c0                	xor    %eax,%eax
8010492a:	e9 60 ff ff ff       	jmp    8010488f <create+0x6f>
8010492f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104930:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104935:	89 3c 24             	mov    %edi,(%esp)
80104938:	e8 b3 cc ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010493d:	8b 46 04             	mov    0x4(%esi),%eax
80104940:	c7 44 24 04 dc 7e 10 	movl   $0x80107edc,0x4(%esp)
80104947:	80 
80104948:	89 34 24             	mov    %esi,(%esp)
8010494b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010494f:	e8 cc d4 ff ff       	call   80101e20 <dirlink>
80104954:	85 c0                	test   %eax,%eax
80104956:	78 1b                	js     80104973 <create+0x153>
80104958:	8b 47 04             	mov    0x4(%edi),%eax
8010495b:	c7 44 24 04 db 7e 10 	movl   $0x80107edb,0x4(%esp)
80104962:	80 
80104963:	89 34 24             	mov    %esi,(%esp)
80104966:	89 44 24 08          	mov    %eax,0x8(%esp)
8010496a:	e8 b1 d4 ff ff       	call   80101e20 <dirlink>
8010496f:	85 c0                	test   %eax,%eax
80104971:	79 89                	jns    801048fc <create+0xdc>
      panic("create dots");
80104973:	c7 04 24 cf 7e 10 80 	movl   $0x80107ecf,(%esp)
8010497a:	e8 e1 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010497f:	c7 04 24 de 7e 10 80 	movl   $0x80107ede,(%esp)
80104986:	e8 d5 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010498b:	c7 04 24 c0 7e 10 80 	movl   $0x80107ec0,(%esp)
80104992:	e8 c9 b9 ff ff       	call   80100360 <panic>
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	89 c6                	mov    %eax,%esi
801049a6:	53                   	push   %ebx
801049a7:	89 d3                	mov    %edx,%ebx
801049a9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049af:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ba:	e8 d1 fc ff ff       	call   80104690 <argint>
801049bf:	85 c0                	test   %eax,%eax
801049c1:	78 2d                	js     801049f0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049c3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049c7:	77 27                	ja     801049f0 <argfd.constprop.0+0x50>
801049c9:	e8 22 ed ff ff       	call   801036f0 <myproc>
801049ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049d1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049d5:	85 c0                	test   %eax,%eax
801049d7:	74 17                	je     801049f0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801049d9:	85 f6                	test   %esi,%esi
801049db:	74 02                	je     801049df <argfd.constprop.0+0x3f>
    *pfd = fd;
801049dd:	89 16                	mov    %edx,(%esi)
  if(pf)
801049df:	85 db                	test   %ebx,%ebx
801049e1:	74 1d                	je     80104a00 <argfd.constprop.0+0x60>
    *pf = f;
801049e3:	89 03                	mov    %eax,(%ebx)
  return 0;
801049e5:	31 c0                	xor    %eax,%eax
}
801049e7:	83 c4 20             	add    $0x20,%esp
801049ea:	5b                   	pop    %ebx
801049eb:	5e                   	pop    %esi
801049ec:	5d                   	pop    %ebp
801049ed:	c3                   	ret    
801049ee:	66 90                	xchg   %ax,%ax
801049f0:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801049f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801049f8:	5b                   	pop    %ebx
801049f9:	5e                   	pop    %esi
801049fa:	5d                   	pop    %ebp
801049fb:	c3                   	ret    
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a00:	31 c0                	xor    %eax,%eax
80104a02:	eb e3                	jmp    801049e7 <argfd.constprop.0+0x47>
80104a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a10 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a10:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a11:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	53                   	push   %ebx
80104a16:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a19:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a1c:	e8 7f ff ff ff       	call   801049a0 <argfd.constprop.0>
80104a21:	85 c0                	test   %eax,%eax
80104a23:	78 23                	js     80104a48 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a28:	e8 b3 fd ff ff       	call   801047e0 <fdalloc>
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	89 c3                	mov    %eax,%ebx
80104a31:	78 15                	js     80104a48 <sys_dup+0x38>
    return -1;
  filedup(f);
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	89 04 24             	mov    %eax,(%esp)
80104a39:	e8 92 c3 ff ff       	call   80100dd0 <filedup>
  return fd;
80104a3e:	89 d8                	mov    %ebx,%eax
}
80104a40:	83 c4 24             	add    $0x24,%esp
80104a43:	5b                   	pop    %ebx
80104a44:	5d                   	pop    %ebp
80104a45:	c3                   	ret    
80104a46:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4d:	eb f1                	jmp    80104a40 <sys_dup+0x30>
80104a4f:	90                   	nop

80104a50 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104a50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a5b:	e8 40 ff ff ff       	call   801049a0 <argfd.constprop.0>
80104a60:	85 c0                	test   %eax,%eax
80104a62:	78 54                	js     80104ab8 <sys_read+0x68>
80104a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a6b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a72:	e8 19 fc ff ff       	call   80104690 <argint>
80104a77:	85 c0                	test   %eax,%eax
80104a79:	78 3d                	js     80104ab8 <sys_read+0x68>
80104a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a85:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a90:	e8 2b fc ff ff       	call   801046c0 <argptr>
80104a95:	85 c0                	test   %eax,%eax
80104a97:	78 1f                	js     80104ab8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aaa:	89 04 24             	mov    %eax,(%esp)
80104aad:	e8 7e c4 ff ff       	call   80100f30 <fileread>
}
80104ab2:	c9                   	leave  
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104abd:	c9                   	leave  
80104abe:	c3                   	ret    
80104abf:	90                   	nop

80104ac0 <sys_write>:

int
sys_write(void)
{
80104ac0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104acb:	e8 d0 fe ff ff       	call   801049a0 <argfd.constprop.0>
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	78 54                	js     80104b28 <sys_write+0x68>
80104ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104adb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ae2:	e8 a9 fb ff ff       	call   80104690 <argint>
80104ae7:	85 c0                	test   %eax,%eax
80104ae9:	78 3d                	js     80104b28 <sys_write+0x68>
80104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b00:	e8 bb fb ff ff       	call   801046c0 <argptr>
80104b05:	85 c0                	test   %eax,%eax
80104b07:	78 1f                	js     80104b28 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b1a:	89 04 24             	mov    %eax,(%esp)
80104b1d:	e8 ae c4 ff ff       	call   80100fd0 <filewrite>
}
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    
80104b2f:	90                   	nop

80104b30 <sys_close>:

int
sys_close(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b3c:	e8 5f fe ff ff       	call   801049a0 <argfd.constprop.0>
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 23                	js     80104b68 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104b45:	e8 a6 eb ff ff       	call   801036f0 <myproc>
80104b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b4d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b54:	00 
  fileclose(f);
80104b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b58:	89 04 24             	mov    %eax,(%esp)
80104b5b:	e8 c0 c2 ff ff       	call   80100e20 <fileclose>
  return 0;
80104b60:	31 c0                	xor    %eax,%eax
}
80104b62:	c9                   	leave  
80104b63:	c3                   	ret    
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b6d:	c9                   	leave  
80104b6e:	c3                   	ret    
80104b6f:	90                   	nop

80104b70 <sys_fstat>:

int
sys_fstat(void)
{
80104b70:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b71:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b7b:	e8 20 fe ff ff       	call   801049a0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 34                	js     80104bb8 <sys_fstat+0x48>
80104b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b87:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b8e:	00 
80104b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b9a:	e8 21 fb ff ff       	call   801046c0 <argptr>
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	78 15                	js     80104bb8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bad:	89 04 24             	mov    %eax,(%esp)
80104bb0:	e8 2b c3 ff ff       	call   80100ee0 <filestat>
}
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bbd:	c9                   	leave  
80104bbe:	c3                   	ret    
80104bbf:	90                   	nop

80104bc0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
80104bc6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bc9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bd7:	e8 54 fb ff ff       	call   80104730 <argstr>
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	0f 88 e6 00 00 00    	js     80104cca <sys_link+0x10a>
80104be4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104be7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104beb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bf2:	e8 39 fb ff ff       	call   80104730 <argstr>
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	0f 88 cb 00 00 00    	js     80104cca <sys_link+0x10a>
    return -1;

  begin_op();
80104bff:	e8 0c df ff ff       	call   80102b10 <begin_op>
  if((ip = namei(old)) == 0){
80104c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c07:	89 04 24             	mov    %eax,(%esp)
80104c0a:	e8 f1 d2 ff ff       	call   80101f00 <namei>
80104c0f:	85 c0                	test   %eax,%eax
80104c11:	89 c3                	mov    %eax,%ebx
80104c13:	0f 84 ac 00 00 00    	je     80104cc5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c19:	89 04 24             	mov    %eax,(%esp)
80104c1c:	e8 8f ca ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104c21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c26:	0f 84 91 00 00 00    	je     80104cbd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c31:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c34:	89 1c 24             	mov    %ebx,(%esp)
80104c37:	e8 b4 c9 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104c3c:	89 1c 24             	mov    %ebx,(%esp)
80104c3f:	e8 4c cb ff ff       	call   80101790 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c44:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c47:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c4b:	89 04 24             	mov    %eax,(%esp)
80104c4e:	e8 cd d2 ff ff       	call   80101f20 <nameiparent>
80104c53:	85 c0                	test   %eax,%eax
80104c55:	89 c6                	mov    %eax,%esi
80104c57:	74 4f                	je     80104ca8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c59:	89 04 24             	mov    %eax,(%esp)
80104c5c:	e8 4f ca ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c61:	8b 03                	mov    (%ebx),%eax
80104c63:	39 06                	cmp    %eax,(%esi)
80104c65:	75 39                	jne    80104ca0 <sys_link+0xe0>
80104c67:	8b 43 04             	mov    0x4(%ebx),%eax
80104c6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c6e:	89 34 24             	mov    %esi,(%esp)
80104c71:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c75:	e8 a6 d1 ff ff       	call   80101e20 <dirlink>
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	78 22                	js     80104ca0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c7e:	89 34 24             	mov    %esi,(%esp)
80104c81:	e8 8a cc ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104c86:	89 1c 24             	mov    %ebx,(%esp)
80104c89:	e8 42 cb ff ff       	call   801017d0 <iput>

  end_op();
80104c8e:	e8 ed de ff ff       	call   80102b80 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c93:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104c96:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c98:	5b                   	pop    %ebx
80104c99:	5e                   	pop    %esi
80104c9a:	5f                   	pop    %edi
80104c9b:	5d                   	pop    %ebp
80104c9c:	c3                   	ret    
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104ca0:	89 34 24             	mov    %esi,(%esp)
80104ca3:	e8 68 cc ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104ca8:	89 1c 24             	mov    %ebx,(%esp)
80104cab:	e8 00 ca ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104cb0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cb5:	89 1c 24             	mov    %ebx,(%esp)
80104cb8:	e8 33 c9 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104cbd:	89 1c 24             	mov    %ebx,(%esp)
80104cc0:	e8 4b cc ff ff       	call   80101910 <iunlockput>
  end_op();
80104cc5:	e8 b6 de ff ff       	call   80102b80 <end_op>
  return -1;
}
80104cca:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ccd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd2:	5b                   	pop    %ebx
80104cd3:	5e                   	pop    %esi
80104cd4:	5f                   	pop    %edi
80104cd5:	5d                   	pop    %ebp
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104ce9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cf7:	e8 34 fa ff ff       	call   80104730 <argstr>
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	0f 88 76 01 00 00    	js     80104e7a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d04:	e8 07 de ff ff       	call   80102b10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d09:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d0c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d13:	89 04 24             	mov    %eax,(%esp)
80104d16:	e8 05 d2 ff ff       	call   80101f20 <nameiparent>
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d20:	0f 84 4f 01 00 00    	je     80104e75 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d26:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d29:	89 34 24             	mov    %esi,(%esp)
80104d2c:	e8 7f c9 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d31:	c7 44 24 04 dc 7e 10 	movl   $0x80107edc,0x4(%esp)
80104d38:	80 
80104d39:	89 1c 24             	mov    %ebx,(%esp)
80104d3c:	e8 4f ce ff ff       	call   80101b90 <namecmp>
80104d41:	85 c0                	test   %eax,%eax
80104d43:	0f 84 21 01 00 00    	je     80104e6a <sys_unlink+0x18a>
80104d49:	c7 44 24 04 db 7e 10 	movl   $0x80107edb,0x4(%esp)
80104d50:	80 
80104d51:	89 1c 24             	mov    %ebx,(%esp)
80104d54:	e8 37 ce ff ff       	call   80101b90 <namecmp>
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	0f 84 09 01 00 00    	je     80104e6a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d61:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d68:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d6c:	89 34 24             	mov    %esi,(%esp)
80104d6f:	e8 4c ce ff ff       	call   80101bc0 <dirlookup>
80104d74:	85 c0                	test   %eax,%eax
80104d76:	89 c3                	mov    %eax,%ebx
80104d78:	0f 84 ec 00 00 00    	je     80104e6a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d7e:	89 04 24             	mov    %eax,(%esp)
80104d81:	e8 2a c9 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80104d86:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d8b:	0f 8e 24 01 00 00    	jle    80104eb5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d96:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d99:	74 7d                	je     80104e18 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104d9b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104da2:	00 
80104da3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104daa:	00 
80104dab:	89 34 24             	mov    %esi,(%esp)
80104dae:	e8 cd f5 ff ff       	call   80104380 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104db3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104db6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dbd:	00 
80104dbe:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dc2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dc6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dc9:	89 04 24             	mov    %eax,(%esp)
80104dcc:	e8 8f cc ff ff       	call   80101a60 <writei>
80104dd1:	83 f8 10             	cmp    $0x10,%eax
80104dd4:	0f 85 cf 00 00 00    	jne    80104ea9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104dda:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ddf:	0f 84 a3 00 00 00    	je     80104e88 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104de5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104de8:	89 04 24             	mov    %eax,(%esp)
80104deb:	e8 20 cb ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80104df0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104df5:	89 1c 24             	mov    %ebx,(%esp)
80104df8:	e8 f3 c7 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104dfd:	89 1c 24             	mov    %ebx,(%esp)
80104e00:	e8 0b cb ff ff       	call   80101910 <iunlockput>

  end_op();
80104e05:	e8 76 dd ff ff       	call   80102b80 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e0a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e0d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5f                   	pop    %edi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e18:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e1c:	0f 86 79 ff ff ff    	jbe    80104d9b <sys_unlink+0xbb>
80104e22:	bf 20 00 00 00       	mov    $0x20,%edi
80104e27:	eb 15                	jmp    80104e3e <sys_unlink+0x15e>
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e30:	8d 57 10             	lea    0x10(%edi),%edx
80104e33:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e36:	0f 83 5f ff ff ff    	jae    80104d9b <sys_unlink+0xbb>
80104e3c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e3e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e45:	00 
80104e46:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e4a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e4e:	89 1c 24             	mov    %ebx,(%esp)
80104e51:	e8 0a cb ff ff       	call   80101960 <readi>
80104e56:	83 f8 10             	cmp    $0x10,%eax
80104e59:	75 42                	jne    80104e9d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e5b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e60:	74 ce                	je     80104e30 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e62:	89 1c 24             	mov    %ebx,(%esp)
80104e65:	e8 a6 ca ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e6d:	89 04 24             	mov    %eax,(%esp)
80104e70:	e8 9b ca ff ff       	call   80101910 <iunlockput>
  end_op();
80104e75:	e8 06 dd ff ff       	call   80102b80 <end_op>
  return -1;
}
80104e7a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e82:	5b                   	pop    %ebx
80104e83:	5e                   	pop    %esi
80104e84:	5f                   	pop    %edi
80104e85:	5d                   	pop    %ebp
80104e86:	c3                   	ret    
80104e87:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104e88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e8b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e90:	89 04 24             	mov    %eax,(%esp)
80104e93:	e8 58 c7 ff ff       	call   801015f0 <iupdate>
80104e98:	e9 48 ff ff ff       	jmp    80104de5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104e9d:	c7 04 24 00 7f 10 80 	movl   $0x80107f00,(%esp)
80104ea4:	e8 b7 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ea9:	c7 04 24 12 7f 10 80 	movl   $0x80107f12,(%esp)
80104eb0:	e8 ab b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104eb5:	c7 04 24 ee 7e 10 80 	movl   $0x80107eee,(%esp)
80104ebc:	e8 9f b4 ff ff       	call   80100360 <panic>
80104ec1:	eb 0d                	jmp    80104ed0 <sys_open>
80104ec3:	90                   	nop
80104ec4:	90                   	nop
80104ec5:	90                   	nop
80104ec6:	90                   	nop
80104ec7:	90                   	nop
80104ec8:	90                   	nop
80104ec9:	90                   	nop
80104eca:	90                   	nop
80104ecb:	90                   	nop
80104ecc:	90                   	nop
80104ecd:	90                   	nop
80104ece:	90                   	nop
80104ecf:	90                   	nop

80104ed0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
80104ed6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ed9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ee7:	e8 44 f8 ff ff       	call   80104730 <argstr>
80104eec:	85 c0                	test   %eax,%eax
80104eee:	0f 88 d1 00 00 00    	js     80104fc5 <sys_open+0xf5>
80104ef4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104efb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f02:	e8 89 f7 ff ff       	call   80104690 <argint>
80104f07:	85 c0                	test   %eax,%eax
80104f09:	0f 88 b6 00 00 00    	js     80104fc5 <sys_open+0xf5>
    return -1;

  begin_op();
80104f0f:	e8 fc db ff ff       	call   80102b10 <begin_op>

  if(omode & O_CREATE){
80104f14:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f18:	0f 85 82 00 00 00    	jne    80104fa0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f21:	89 04 24             	mov    %eax,(%esp)
80104f24:	e8 d7 cf ff ff       	call   80101f00 <namei>
80104f29:	85 c0                	test   %eax,%eax
80104f2b:	89 c6                	mov    %eax,%esi
80104f2d:	0f 84 8d 00 00 00    	je     80104fc0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f33:	89 04 24             	mov    %eax,(%esp)
80104f36:	e8 75 c7 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f40:	0f 84 92 00 00 00    	je     80104fd8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f46:	e8 15 be ff ff       	call   80100d60 <filealloc>
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	89 c3                	mov    %eax,%ebx
80104f4f:	0f 84 93 00 00 00    	je     80104fe8 <sys_open+0x118>
80104f55:	e8 86 f8 ff ff       	call   801047e0 <fdalloc>
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	89 c7                	mov    %eax,%edi
80104f5e:	0f 88 94 00 00 00    	js     80104ff8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f64:	89 34 24             	mov    %esi,(%esp)
80104f67:	e8 24 c8 ff ff       	call   80101790 <iunlock>
  end_op();
80104f6c:	e8 0f dc ff ff       	call   80102b80 <end_op>

  f->type = FD_INODE;
80104f71:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104f7a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f7d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104f84:	89 c2                	mov    %eax,%edx
80104f86:	83 e2 01             	and    $0x1,%edx
80104f89:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f8c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f8e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104f91:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f93:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104f97:	83 c4 2c             	add    $0x2c,%esp
80104f9a:	5b                   	pop    %ebx
80104f9b:	5e                   	pop    %esi
80104f9c:	5f                   	pop    %edi
80104f9d:	5d                   	pop    %ebp
80104f9e:	c3                   	ret    
80104f9f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fa3:	31 c9                	xor    %ecx,%ecx
80104fa5:	ba 02 00 00 00       	mov    $0x2,%edx
80104faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fb1:	e8 6a f8 ff ff       	call   80104820 <create>
    if(ip == 0){
80104fb6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fb8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104fba:	75 8a                	jne    80104f46 <sys_open+0x76>
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104fc0:	e8 bb db ff ff       	call   80102b80 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fc5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret    
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	0f 84 63 ff ff ff    	je     80104f46 <sys_open+0x76>
80104fe3:	90                   	nop
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80104fe8:	89 34 24             	mov    %esi,(%esp)
80104feb:	e8 20 c9 ff ff       	call   80101910 <iunlockput>
80104ff0:	eb ce                	jmp    80104fc0 <sys_open+0xf0>
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104ff8:	89 1c 24             	mov    %ebx,(%esp)
80104ffb:	e8 20 be ff ff       	call   80100e20 <fileclose>
80105000:	eb e6                	jmp    80104fe8 <sys_open+0x118>
80105002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105016:	e8 f5 da ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010501b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105029:	e8 02 f7 ff ff       	call   80104730 <argstr>
8010502e:	85 c0                	test   %eax,%eax
80105030:	78 2e                	js     80105060 <sys_mkdir+0x50>
80105032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105035:	31 c9                	xor    %ecx,%ecx
80105037:	ba 01 00 00 00       	mov    $0x1,%edx
8010503c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105043:	e8 d8 f7 ff ff       	call   80104820 <create>
80105048:	85 c0                	test   %eax,%eax
8010504a:	74 14                	je     80105060 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010504c:	89 04 24             	mov    %eax,(%esp)
8010504f:	e8 bc c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105054:	e8 27 db ff ff       	call   80102b80 <end_op>
  return 0;
80105059:	31 c0                	xor    %eax,%eax
}
8010505b:	c9                   	leave  
8010505c:	c3                   	ret    
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105060:	e8 1b db ff ff       	call   80102b80 <end_op>
    return -1;
80105065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_mknod>:

int
sys_mknod(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105076:	e8 95 da ff ff       	call   80102b10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010507b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010507e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105089:	e8 a2 f6 ff ff       	call   80104730 <argstr>
8010508e:	85 c0                	test   %eax,%eax
80105090:	78 5e                	js     801050f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105092:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105095:	89 44 24 04          	mov    %eax,0x4(%esp)
80105099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050a0:	e8 eb f5 ff ff       	call   80104690 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050a5:	85 c0                	test   %eax,%eax
801050a7:	78 47                	js     801050f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050b7:	e8 d4 f5 ff ff       	call   80104690 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050bc:	85 c0                	test   %eax,%eax
801050be:	78 30                	js     801050f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050c0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050c4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050c9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050cd:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050d3:	e8 48 f7 ff ff       	call   80104820 <create>
801050d8:	85 c0                	test   %eax,%eax
801050da:	74 14                	je     801050f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050dc:	89 04 24             	mov    %eax,(%esp)
801050df:	e8 2c c8 ff ff       	call   80101910 <iunlockput>
  end_op();
801050e4:	e8 97 da ff ff       	call   80102b80 <end_op>
  return 0;
801050e9:	31 c0                	xor    %eax,%eax
}
801050eb:	c9                   	leave  
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801050f0:	e8 8b da ff ff       	call   80102b80 <end_op>
    return -1;
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050fa:	c9                   	leave  
801050fb:	c3                   	ret    
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <sys_chdir>:

int
sys_chdir(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
80105105:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105108:	e8 e3 e5 ff ff       	call   801036f0 <myproc>
8010510d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010510f:	e8 fc d9 ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105114:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105117:	89 44 24 04          	mov    %eax,0x4(%esp)
8010511b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105122:	e8 09 f6 ff ff       	call   80104730 <argstr>
80105127:	85 c0                	test   %eax,%eax
80105129:	78 4a                	js     80105175 <sys_chdir+0x75>
8010512b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010512e:	89 04 24             	mov    %eax,(%esp)
80105131:	e8 ca cd ff ff       	call   80101f00 <namei>
80105136:	85 c0                	test   %eax,%eax
80105138:	89 c3                	mov    %eax,%ebx
8010513a:	74 39                	je     80105175 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010513c:	89 04 24             	mov    %eax,(%esp)
8010513f:	e8 6c c5 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105144:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105149:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010514c:	75 22                	jne    80105170 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010514e:	e8 3d c6 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105153:	8b 46 68             	mov    0x68(%esi),%eax
80105156:	89 04 24             	mov    %eax,(%esp)
80105159:	e8 72 c6 ff ff       	call   801017d0 <iput>
  end_op();
8010515e:	e8 1d da ff ff       	call   80102b80 <end_op>
  curproc->cwd = ip;
  return 0;
80105163:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105165:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105168:	83 c4 20             	add    $0x20,%esp
8010516b:	5b                   	pop    %ebx
8010516c:	5e                   	pop    %esi
8010516d:	5d                   	pop    %ebp
8010516e:	c3                   	ret    
8010516f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105170:	e8 9b c7 ff ff       	call   80101910 <iunlockput>
    end_op();
80105175:	e8 06 da ff ff       	call   80102b80 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010517a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010517d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105182:	5b                   	pop    %ebx
80105183:	5e                   	pop    %esi
80105184:	5d                   	pop    %ebp
80105185:	c3                   	ret    
80105186:	8d 76 00             	lea    0x0(%esi),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <sys_exec>:

int
sys_exec(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010519c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051ad:	e8 7e f5 ff ff       	call   80104730 <argstr>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 88 84 00 00 00    	js     8010523e <sys_exec+0xae>
801051ba:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051cb:	e8 c0 f4 ff ff       	call   80104690 <argint>
801051d0:	85 c0                	test   %eax,%eax
801051d2:	78 6a                	js     8010523e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051da:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051dc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051e3:	00 
801051e4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051f1:	00 
801051f2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801051f8:	89 04 24             	mov    %eax,(%esp)
801051fb:	e8 80 f1 ff ff       	call   80104380 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105200:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105206:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010520a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010520d:	89 04 24             	mov    %eax,(%esp)
80105210:	e8 bb f3 ff ff       	call   801045d0 <fetchint>
80105215:	85 c0                	test   %eax,%eax
80105217:	78 25                	js     8010523e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105219:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010521f:	85 c0                	test   %eax,%eax
80105221:	74 2d                	je     80105250 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105223:	89 74 24 04          	mov    %esi,0x4(%esp)
80105227:	89 04 24             	mov    %eax,(%esp)
8010522a:	e8 f1 f3 ff ff       	call   80104620 <fetchstr>
8010522f:	85 c0                	test   %eax,%eax
80105231:	78 0b                	js     8010523e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105233:	83 c3 01             	add    $0x1,%ebx
80105236:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105239:	83 fb 20             	cmp    $0x20,%ebx
8010523c:	75 c2                	jne    80105200 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010523e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5f                   	pop    %edi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
8010524e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105250:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105256:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105260:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105267:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010526b:	89 04 24             	mov    %eax,(%esp)
8010526e:	e8 2d b7 ff ff       	call   801009a0 <exec>
}
80105273:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax

80105280 <sys_pipe>:

int
sys_pipe(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	53                   	push   %ebx
80105284:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105287:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010528a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105291:	00 
80105292:	89 44 24 04          	mov    %eax,0x4(%esp)
80105296:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010529d:	e8 1e f4 ff ff       	call   801046c0 <argptr>
801052a2:	85 c0                	test   %eax,%eax
801052a4:	78 6d                	js     80105313 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 b8 de ff ff       	call   80103170 <pipealloc>
801052b8:	85 c0                	test   %eax,%eax
801052ba:	78 57                	js     80105313 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052bf:	e8 1c f5 ff ff       	call   801047e0 <fdalloc>
801052c4:	85 c0                	test   %eax,%eax
801052c6:	89 c3                	mov    %eax,%ebx
801052c8:	78 33                	js     801052fd <sys_pipe+0x7d>
801052ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052cd:	e8 0e f5 ff ff       	call   801047e0 <fdalloc>
801052d2:	85 c0                	test   %eax,%eax
801052d4:	78 1a                	js     801052f0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052d9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801052db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052de:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801052e1:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801052e4:	31 c0                	xor    %eax,%eax
}
801052e6:	5b                   	pop    %ebx
801052e7:	5d                   	pop    %ebp
801052e8:	c3                   	ret    
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801052f0:	e8 fb e3 ff ff       	call   801036f0 <myproc>
801052f5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801052fc:	00 
    fileclose(rf);
801052fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105300:	89 04 24             	mov    %eax,(%esp)
80105303:	e8 18 bb ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
80105308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530b:	89 04 24             	mov    %eax,(%esp)
8010530e:	e8 0d bb ff ff       	call   80100e20 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105313:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010531b:	5b                   	pop    %ebx
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax

80105320 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105326:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105329:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105334:	e8 57 f3 ff ff       	call   80104690 <argint>
80105339:	85 c0                	test   %eax,%eax
8010533b:	78 33                	js     80105370 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010533d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105340:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105347:	00 
80105348:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105353:	e8 68 f3 ff ff       	call   801046c0 <argptr>
80105358:	85 c0                	test   %eax,%eax
8010535a:	78 14                	js     80105370 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010535c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105366:	89 04 24             	mov    %eax,(%esp)
80105369:	e8 72 20 00 00       	call   801073e0 <shm_open>
}
8010536e:	c9                   	leave  
8010536f:	c3                   	ret    
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
80105375:	c9                   	leave  
80105376:	c3                   	ret    
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_shm_close>:

int sys_shm_close(void) {
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105386:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010538d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105394:	e8 f7 f2 ff ff       	call   80104690 <argint>
80105399:	85 c0                	test   %eax,%eax
8010539b:	78 13                	js     801053b0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010539d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a0:	89 04 24             	mov    %eax,(%esp)
801053a3:	e8 e8 21 00 00       	call   80107590 <shm_close>
}
801053a8:	c9                   	leave  
801053a9:	c3                   	ret    
801053aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_fork>:

int
sys_fork(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801053c3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
801053c4:	e9 47 e5 ff ff       	jmp    80103910 <fork>
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_exit>:
}

int
sys_exit(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053d6:	e8 95 e7 ff ff       	call   80103b70 <exit>
  return 0;  // not reached
}
801053db:	31 c0                	xor    %eax,%eax
801053dd:	c9                   	leave  
801053de:	c3                   	ret    
801053df:	90                   	nop

801053e0 <sys_wait>:

int
sys_wait(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801053e3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801053e4:	e9 a7 e9 ff ff       	jmp    80103d90 <wait>
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_kill>:
}

int
sys_kill(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105404:	e8 87 f2 ff ff       	call   80104690 <argint>
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 13                	js     80105420 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010540d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105410:	89 04 24             	mov    %eax,(%esp)
80105413:	e8 d8 ea ff ff       	call   80103ef0 <kill>
}
80105418:	c9                   	leave  
80105419:	c3                   	ret    
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105425:	c9                   	leave  
80105426:	c3                   	ret    
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_getpid>:

int
sys_getpid(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105436:	e8 b5 e2 ff ff       	call   801036f0 <myproc>
8010543b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010543e:	c9                   	leave  
8010543f:	c3                   	ret    

80105440 <sys_sbrk>:

int
sys_sbrk(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105447:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010544e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105455:	e8 36 f2 ff ff       	call   80104690 <argint>
8010545a:	85 c0                	test   %eax,%eax
8010545c:	78 22                	js     80105480 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010545e:	e8 8d e2 ff ff       	call   801036f0 <myproc>
  if(growproc(n) < 0)
80105463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105466:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105468:	89 14 24             	mov    %edx,(%esp)
8010546b:	e8 10 e4 ff ff       	call   80103880 <growproc>
80105470:	85 c0                	test   %eax,%eax
80105472:	78 0c                	js     80105480 <sys_sbrk+0x40>
    return -1;
  return addr;
80105474:	89 d8                	mov    %ebx,%eax
}
80105476:	83 c4 24             	add    $0x24,%esp
80105479:	5b                   	pop    %ebx
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ef                	jmp    80105476 <sys_sbrk+0x36>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a5:	e8 e6 f1 ff ff       	call   80104690 <argint>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 7e                	js     8010552c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801054ae:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801054b5:	e8 86 ed ff ff       	call   80104240 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801054bd:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while(ticks - ticks0 < n){
801054c3:	85 d2                	test   %edx,%edx
801054c5:	75 29                	jne    801054f0 <sys_sleep+0x60>
801054c7:	eb 4f                	jmp    80105518 <sys_sleep+0x88>
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054d0:	c7 44 24 04 60 65 11 	movl   $0x80116560,0x4(%esp)
801054d7:	80 
801054d8:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
801054df:	e8 fc e7 ff ff       	call   80103ce0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054e4:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
801054e9:	29 d8                	sub    %ebx,%eax
801054eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054ee:	73 28                	jae    80105518 <sys_sleep+0x88>
    if(myproc()->killed){
801054f0:	e8 fb e1 ff ff       	call   801036f0 <myproc>
801054f5:	8b 40 24             	mov    0x24(%eax),%eax
801054f8:	85 c0                	test   %eax,%eax
801054fa:	74 d4                	je     801054d0 <sys_sleep+0x40>
      release(&tickslock);
801054fc:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105503:	e8 28 ee ff ff       	call   80104330 <release>
      return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010550d:	83 c4 24             	add    $0x24,%esp
80105510:	5b                   	pop    %ebx
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105518:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010551f:	e8 0c ee ff ff       	call   80104330 <release>
  return 0;
}
80105524:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105527:	31 c0                	xor    %eax,%eax
}
80105529:	5b                   	pop    %ebx
8010552a:	5d                   	pop    %ebp
8010552b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010552c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105531:	eb da                	jmp    8010550d <sys_sleep+0x7d>
80105533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
80105544:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105547:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010554e:	e8 ed ec ff ff       	call   80104240 <acquire>
  xticks = ticks;
80105553:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
80105559:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105560:	e8 cb ed ff ff       	call   80104330 <release>
  return xticks;
}
80105565:	83 c4 14             	add    $0x14,%esp
80105568:	89 d8                	mov    %ebx,%eax
8010556a:	5b                   	pop    %ebx
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    

8010556d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010556d:	1e                   	push   %ds
  pushl %es
8010556e:	06                   	push   %es
  pushl %fs
8010556f:	0f a0                	push   %fs
  pushl %gs
80105571:	0f a8                	push   %gs
  pushal
80105573:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105574:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105578:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010557a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010557c:	54                   	push   %esp
  call trap
8010557d:	e8 de 00 00 00       	call   80105660 <trap>
  addl $4, %esp
80105582:	83 c4 04             	add    $0x4,%esp

80105585 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105585:	61                   	popa   
  popl %gs
80105586:	0f a9                	pop    %gs
  popl %fs
80105588:	0f a1                	pop    %fs
  popl %es
8010558a:	07                   	pop    %es
  popl %ds
8010558b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010558c:	83 c4 08             	add    $0x8,%esp
  iret
8010558f:	cf                   	iret   

80105590 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105590:	31 c0                	xor    %eax,%eax
80105592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105598:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010559f:	b9 08 00 00 00       	mov    $0x8,%ecx
801055a4:	66 89 0c c5 a2 65 11 	mov    %cx,-0x7fee9a5e(,%eax,8)
801055ab:	80 
801055ac:	c6 04 c5 a4 65 11 80 	movb   $0x0,-0x7fee9a5c(,%eax,8)
801055b3:	00 
801055b4:	c6 04 c5 a5 65 11 80 	movb   $0x8e,-0x7fee9a5b(,%eax,8)
801055bb:	8e 
801055bc:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
801055c3:	80 
801055c4:	c1 ea 10             	shr    $0x10,%edx
801055c7:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
801055ce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055cf:	83 c0 01             	add    $0x1,%eax
801055d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801055d7:	75 bf                	jne    80105598 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055d9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055da:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055df:	89 e5                	mov    %esp,%ebp
801055e1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055e4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801055e9:	c7 44 24 04 21 7f 10 	movl   $0x80107f21,0x4(%esp)
801055f0:	80 
801055f1:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055f8:	66 89 15 a2 67 11 80 	mov    %dx,0x801167a2
801055ff:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
80105605:	c1 e8 10             	shr    $0x10,%eax
80105608:	c6 05 a4 67 11 80 00 	movb   $0x0,0x801167a4
8010560f:	c6 05 a5 67 11 80 ef 	movb   $0xef,0x801167a5
80105616:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6

  initlock(&tickslock, "time");
8010561c:	e8 2f eb ff ff       	call   80104150 <initlock>
}
80105621:	c9                   	leave  
80105622:	c3                   	ret    
80105623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <idtinit>:



void
idtinit(void)
{
80105630:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105631:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105636:	89 e5                	mov    %esp,%ebp
80105638:	83 ec 10             	sub    $0x10,%esp
8010563b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010563f:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
80105644:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105648:	c1 e8 10             	shr    $0x10,%eax
8010564b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010564f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105652:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	56                   	push   %esi
80105665:	53                   	push   %ebx
80105666:	83 ec 4c             	sub    $0x4c,%esp
80105669:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
8010566c:	e8 7f e0 ff ff       	call   801036f0 <myproc>
80105671:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
80105673:	8b 43 30             	mov    0x30(%ebx),%eax
80105676:	83 f8 40             	cmp    $0x40,%eax
80105679:	0f 84 09 02 00 00    	je     80105888 <trap+0x228>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010567f:	83 e8 0e             	sub    $0xe,%eax
80105682:	83 f8 31             	cmp    $0x31,%eax
80105685:	77 09                	ja     80105690 <trap+0x30>
80105687:	ff 24 85 00 81 10 80 	jmp    *-0x7fef7f00(,%eax,4)
8010568e:	66 90                	xchg   %ax,%ax
			break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105690:	e8 5b e0 ff ff       	call   801036f0 <myproc>
80105695:	85 c0                	test   %eax,%eax
80105697:	0f 84 7c 03 00 00    	je     80105a19 <trap+0x3b9>
8010569d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056a1:	0f 84 72 03 00 00    	je     80105a19 <trap+0x3b9>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801056a7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056aa:	8b 53 38             	mov    0x38(%ebx),%edx
801056ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801056b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801056b3:	e8 18 e0 ff ff       	call   801036d0 <cpuid>
801056b8:	8b 73 30             	mov    0x30(%ebx),%esi
801056bb:	89 c7                	mov    %eax,%edi
801056bd:	8b 43 34             	mov    0x34(%ebx),%eax
801056c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056c3:	e8 28 e0 ff ff       	call   801036f0 <myproc>
801056c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801056cb:	e8 20 e0 ff ff       	call   801036f0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056d0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801056d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056d7:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056da:	8b 55 dc             	mov    -0x24(%ebp),%edx
801056dd:	89 7c 24 14          	mov    %edi,0x14(%esp)
801056e1:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801056e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056e8:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056eb:	89 54 24 18          	mov    %edx,0x18(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801056ef:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056f3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801056f7:	8b 40 10             	mov    0x10(%eax),%eax
801056fa:	c7 04 24 bc 80 10 80 	movl   $0x801080bc,(%esp)
80105701:	89 44 24 04          	mov    %eax,0x4(%esp)
80105705:	e8 46 af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010570a:	e8 e1 df ff ff       	call   801036f0 <myproc>
8010570f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105716:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105718:	e8 d3 df ff ff       	call   801036f0 <myproc>
8010571d:	85 c0                	test   %eax,%eax
8010571f:	74 0c                	je     8010572d <trap+0xcd>
80105721:	e8 ca df ff ff       	call   801036f0 <myproc>
80105726:	8b 50 24             	mov    0x24(%eax),%edx
80105729:	85 d2                	test   %edx,%edx
8010572b:	75 4b                	jne    80105778 <trap+0x118>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010572d:	e8 be df ff ff       	call   801036f0 <myproc>
80105732:	85 c0                	test   %eax,%eax
80105734:	74 0c                	je     80105742 <trap+0xe2>
80105736:	e8 b5 df ff ff       	call   801036f0 <myproc>
8010573b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010573f:	90                   	nop
80105740:	74 4e                	je     80105790 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105742:	e8 a9 df ff ff       	call   801036f0 <myproc>
80105747:	85 c0                	test   %eax,%eax
80105749:	74 22                	je     8010576d <trap+0x10d>
8010574b:	90                   	nop
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105750:	e8 9b df ff ff       	call   801036f0 <myproc>
80105755:	8b 40 24             	mov    0x24(%eax),%eax
80105758:	85 c0                	test   %eax,%eax
8010575a:	74 11                	je     8010576d <trap+0x10d>
8010575c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105760:	83 e0 03             	and    $0x3,%eax
80105763:	66 83 f8 03          	cmp    $0x3,%ax
80105767:	0f 84 4c 01 00 00    	je     801058b9 <trap+0x259>
    exit();
}
8010576d:	83 c4 4c             	add    $0x4c,%esp
80105770:	5b                   	pop    %ebx
80105771:	5e                   	pop    %esi
80105772:	5f                   	pop    %edi
80105773:	5d                   	pop    %ebp
80105774:	c3                   	ret    
80105775:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105778:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010577c:	83 e0 03             	and    $0x3,%eax
8010577f:	66 83 f8 03          	cmp    $0x3,%ax
80105783:	75 a8                	jne    8010572d <trap+0xcd>
    exit();
80105785:	e8 e6 e3 ff ff       	call   80103b70 <exit>
8010578a:	eb a1                	jmp    8010572d <trap+0xcd>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105790:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105794:	75 ac                	jne    80105742 <trap+0xe2>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105796:	e8 05 e5 ff ff       	call   80103ca0 <yield>
8010579b:	eb a5                	jmp    80105742 <trap+0xe2>
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
801057a0:	85 f6                	test   %esi,%esi
801057a2:	0f 84 e8 fe ff ff    	je     80105690 <trap+0x30>
801057a8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057ac:	83 e0 03             	and    $0x3,%eax
801057af:	66 83 f8 03          	cmp    $0x3,%ax
801057b3:	0f 84 47 01 00 00    	je     80105900 <trap+0x2a0>
801057b9:	0f 20 d2             	mov    %cr2,%edx
801057bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
			break;
		}else if (curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
801057bf:	8b 7b 38             	mov    0x38(%ebx),%edi
801057c2:	e8 09 df ff ff       	call   801036d0 <cpuid>
801057c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801057ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
801057ce:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801057d2:	89 44 24 14          	mov    %eax,0x14(%esp)
801057d6:	8b 43 34             	mov    0x34(%ebx),%eax
801057d9:	89 44 24 10          	mov    %eax,0x10(%esp)
801057dd:	8b 43 30             	mov    0x30(%ebx),%eax
801057e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
801057e4:	8d 46 6c             	lea    0x6c(%esi),%eax
801057e7:	89 44 24 08          	mov    %eax,0x8(%esp)
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
			break;
		}else if (curproc){ // kernel mode
			cprintf("Stack Owerflow in proccess pid %d %s: trap %d err %d on cpu %d "
801057eb:	8b 46 10             	mov    0x10(%esi),%eax
801057ee:	c7 04 24 28 80 10 80 	movl   $0x80108028,(%esp)
801057f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801057f9:	e8 52 ae ff ff       	call   80100650 <cprintf>
						 "eip 0x%x addr 0x%x--kill proc\n",
						  curproc->pid, curproc->name, tf->trapno, tf->err, cpuid(), tf->eip, 
						  rcr2());                                          
			curproc->killed = 1;
801057fe:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105805:	e9 0e ff ff ff       	jmp    80105718 <trap+0xb8>
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105810:	e8 bb de ff ff       	call   801036d0 <cpuid>
80105815:	85 c0                	test   %eax,%eax
80105817:	0f 84 b3 00 00 00    	je     801058d0 <trap+0x270>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105820:	e8 5b cf ff ff       	call   80102780 <lapiceoi>
    break;
80105825:	e9 ee fe ff ff       	jmp    80105718 <trap+0xb8>
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105830:	e8 9b cd ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105835:	e8 46 cf ff ff       	call   80102780 <lapiceoi>
    break;
8010583a:	e9 d9 fe ff ff       	jmp    80105718 <trap+0xb8>
8010583f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105840:	e8 2b 03 00 00       	call   80105b70 <uartintr>
    lapiceoi();
80105845:	e8 36 cf ff ff       	call   80102780 <lapiceoi>
    break;
8010584a:	e9 c9 fe ff ff       	jmp    80105718 <trap+0xb8>
8010584f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105850:	8b 7b 38             	mov    0x38(%ebx),%edi
80105853:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105857:	e8 74 de ff ff       	call   801036d0 <cpuid>
8010585c:	c7 04 24 2c 7f 10 80 	movl   $0x80107f2c,(%esp)
80105863:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105867:	89 74 24 08          	mov    %esi,0x8(%esp)
8010586b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586f:	e8 dc ad ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105874:	e8 07 cf ff ff       	call   80102780 <lapiceoi>
    break;
80105879:	e9 9a fe ff ff       	jmp    80105718 <trap+0xb8>
8010587e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105880:	e8 fb c7 ff ff       	call   80102080 <ideintr>
80105885:	eb 96                	jmp    8010581d <trap+0x1bd>
80105887:	90                   	nop
80105888:	90                   	nop
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105890:	e8 5b de ff ff       	call   801036f0 <myproc>
80105895:	8b 70 24             	mov    0x24(%eax),%esi
80105898:	85 f6                	test   %esi,%esi
8010589a:	75 2c                	jne    801058c8 <trap+0x268>
      exit();
    myproc()->tf = tf;
8010589c:	e8 4f de ff ff       	call   801036f0 <myproc>
801058a1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801058a4:	e8 c7 ee ff ff       	call   80104770 <syscall>
    if(myproc()->killed)
801058a9:	e8 42 de ff ff       	call   801036f0 <myproc>
801058ae:	8b 48 24             	mov    0x24(%eax),%ecx
801058b1:	85 c9                	test   %ecx,%ecx
801058b3:	0f 84 b4 fe ff ff    	je     8010576d <trap+0x10d>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801058b9:	83 c4 4c             	add    $0x4c,%esp
801058bc:	5b                   	pop    %ebx
801058bd:	5e                   	pop    %esi
801058be:	5f                   	pop    %edi
801058bf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801058c0:	e9 ab e2 ff ff       	jmp    80103b70 <exit>
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
trap(struct trapframe *tf)
{
	struct proc *curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801058c8:	e8 a3 e2 ff ff       	call   80103b70 <exit>
801058cd:	eb cd                	jmp    8010589c <trap+0x23c>
801058cf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801058d0:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801058d7:	e8 64 e9 ff ff       	call   80104240 <acquire>
      ticks++;
      wakeup(&ticks);
801058dc:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801058e3:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
801058ea:	e8 91 e5 ff ff       	call   80103e80 <wakeup>
      release(&tickslock);
801058ef:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801058f6:	e8 35 ea ff ff       	call   80104330 <release>
801058fb:	e9 1d ff ff ff       	jmp    8010581d <trap+0x1bd>
    lapiceoi();
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
			if(curproc->tf->esp < curproc->tstack){ // Check to see if stack size matches esp and if it doesn't it makes it the same
80105900:	8b 46 18             	mov    0x18(%esi),%eax
80105903:	8b 56 7c             	mov    0x7c(%esi),%edx
80105906:	8b 40 44             	mov    0x44(%eax),%eax
80105909:	39 d0                	cmp    %edx,%eax
8010590b:	0f 83 95 00 00 00    	jae    801059a6 <trap+0x346>
				uint rep = ((curproc->tstack - curproc->tf->esp)/PGSIZE)+1;
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
80105911:	8b 0e                	mov    (%esi),%ecx
80105913:	8d b9 00 20 00 00    	lea    0x2000(%ecx),%edi
80105919:	39 f8                	cmp    %edi,%eax
8010591b:	73 2b                	jae    80105948 <trap+0x2e8>
8010591d:	0f 20 d7             	mov    %cr2,%edi
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105920:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105924:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105928:	89 54 24 08          	mov    %edx,0x8(%esp)
8010592c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105930:	c7 04 24 50 7f 10 80 	movl   $0x80107f50,(%esp)
80105937:	e8 14 ad ff ff       	call   80100650 <cprintf>
					curproc->killed = 1;
8010593c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
					break;
80105943:	e9 d0 fd ff ff       	jmp    80105718 <trap+0xb8>
    break;

  case T_PGFLT: // For CS153 lab2 part1
		if( curproc && (tf->cs&3) == DPL_USER){ // user mode
			if(curproc->tf->esp < curproc->tstack){ // Check to see if stack size matches esp and if it doesn't it makes it the same
				uint rep = ((curproc->tstack - curproc->tf->esp)/PGSIZE)+1;
80105948:	89 d7                	mov    %edx,%edi
8010594a:	29 c7                	sub    %eax,%edi
8010594c:	89 f8                	mov    %edi,%eax
8010594e:	c1 e8 0c             	shr    $0xc,%eax
80105951:	83 c0 01             	add    $0x1,%eax
				if(curproc->sz+2*PGSIZE > curproc->tf->esp){ // Checks for the garbage so that if the esp reaches we delete until it is no longer there.
					cprintf("guard page error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
					curproc->killed = 1;
					break;
				}
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
80105954:	89 44 24 08          	mov    %eax,0x8(%esp)
80105958:	89 54 24 04          	mov    %edx,0x4(%esp)
8010595c:	8b 46 04             	mov    0x4(%esi),%eax
8010595f:	89 04 24             	mov    %eax,(%esp)
80105962:	e8 39 18 00 00       	call   801071a0 <addstackpage>
80105967:	83 f8 01             	cmp    $0x1,%eax
8010596a:	0f 84 a8 fd ff ff    	je     80105718 <trap+0xb8>
80105970:	0f 20 d0             	mov    %cr2,%eax
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
80105973:	89 44 24 10          	mov    %eax,0x10(%esp)
80105977:	8b 06                	mov    (%esi),%eax
80105979:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010597d:	8b 46 7c             	mov    0x7c(%esi),%eax
80105980:	89 44 24 08          	mov    %eax,0x8(%esp)
80105984:	8b 46 18             	mov    0x18(%esi),%eax
80105987:	8b 40 44             	mov    0x44(%eax),%eax
8010598a:	c7 04 24 8c 7f 10 80 	movl   $0x80107f8c,(%esp)
80105991:	89 44 24 04          	mov    %eax,0x4(%esp)
80105995:	e8 b6 ac ff ff       	call   80100650 <cprintf>
				curproc->killed = 1;
8010599a:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
				break;
801059a1:	e9 72 fd ff ff       	jmp    80105718 <trap+0xb8>
801059a6:	0f 20 d1             	mov    %cr2,%ecx
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059a9:	8b 53 38             	mov    0x38(%ebx),%edx
801059ac:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
801059af:	89 55 d8             	mov    %edx,-0x28(%ebp)
801059b2:	e8 19 dd ff ff       	call   801036d0 <cpuid>
801059b7:	8b 7b 34             	mov    0x34(%ebx),%edi
801059ba:	89 7d e0             	mov    %edi,-0x20(%ebp)
801059bd:	8b 7b 30             	mov    0x30(%ebx),%edi
801059c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059c3:	e8 28 dd ff ff       	call   801036f0 <myproc>
801059c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059cb:	e8 20 dd ff ff       	call   801036f0 <myproc>
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
801059d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
801059d6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059da:	8b 7d dc             	mov    -0x24(%ebp),%edi
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059dd:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801059e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059e4:	89 54 24 18          	mov    %edx,0x18(%esp)
801059e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
801059eb:	83 c7 6c             	add    $0x6c,%edi
801059ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
				if(addstackpage(curproc->pgdir, curproc->tstack, rep) == 1) break; // Checks if fails to allocate for the stack
		    cprintf("allocation error! esp 0x%x stack 0x%x sz 0x%x addr 0x%x\n", curproc->tf->esp, curproc->tstack, curproc->sz, rcr2());
				curproc->killed = 1;
				break;
			}
		  cprintf("Access forbidden in proccess pid %d %s: trap %d err %d on cpu %d "
801059f2:	89 4c 24 14          	mov    %ecx,0x14(%esp)
801059f6:	89 54 24 10          	mov    %edx,0x10(%esp)
801059fa:	8b 40 10             	mov    0x10(%eax),%eax
801059fd:	c7 04 24 c8 7f 10 80 	movl   $0x80107fc8,(%esp)
80105a04:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a08:	e8 43 ac ff ff       	call   80100650 <cprintf>
		          "eip 0x%x addr 0x%x--kill proc\n",
		          myproc()->pid, myproc()->name, tf->trapno,
		          tf->err, cpuid(), tf->eip, rcr2());
			curproc->killed = 1;
80105a0d:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
			break;
80105a14:	e9 ff fc ff ff       	jmp    80105718 <trap+0xb8>
80105a19:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a1c:	8b 73 38             	mov    0x38(%ebx),%esi
80105a1f:	e8 ac dc ff ff       	call   801036d0 <cpuid>
80105a24:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105a28:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a30:	8b 43 30             	mov    0x30(%ebx),%eax
80105a33:	c7 04 24 88 80 10 80 	movl   $0x80108088,(%esp)
80105a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a3e:	e8 0d ac ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105a43:	c7 04 24 26 7f 10 80 	movl   $0x80107f26,(%esp)
80105a4a:	e8 11 a9 ff ff       	call   80100360 <panic>
80105a4f:	90                   	nop

80105a50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a50:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a55:	55                   	push   %ebp
80105a56:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a58:	85 c0                	test   %eax,%eax
80105a5a:	74 14                	je     80105a70 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a5c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a61:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a62:	a8 01                	test   $0x1,%al
80105a64:	74 0a                	je     80105a70 <uartgetc+0x20>
80105a66:	b2 f8                	mov    $0xf8,%dl
80105a68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a69:	0f b6 c0             	movzbl %al,%eax
}
80105a6c:	5d                   	pop    %ebp
80105a6d:	c3                   	ret    
80105a6e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a75:	5d                   	pop    %ebp
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a80 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105a80:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105a85:	85 c0                	test   %eax,%eax
80105a87:	74 3f                	je     80105ac8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105a89:	55                   	push   %ebp
80105a8a:	89 e5                	mov    %esp,%ebp
80105a8c:	56                   	push   %esi
80105a8d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a92:	53                   	push   %ebx
  int i;

  if(!uart)
80105a93:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105a98:	83 ec 10             	sub    $0x10,%esp
80105a9b:	eb 14                	jmp    80105ab1 <uartputc+0x31>
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105aa0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105aa7:	e8 f4 cc ff ff       	call   801027a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aac:	83 eb 01             	sub    $0x1,%ebx
80105aaf:	74 07                	je     80105ab8 <uartputc+0x38>
80105ab1:	89 f2                	mov    %esi,%edx
80105ab3:	ec                   	in     (%dx),%al
80105ab4:	a8 20                	test   $0x20,%al
80105ab6:	74 e8                	je     80105aa0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105ab8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105abc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ac1:	ee                   	out    %al,(%dx)
}
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	5b                   	pop    %ebx
80105ac6:	5e                   	pop    %esi
80105ac7:	5d                   	pop    %ebp
80105ac8:	f3 c3                	repz ret 
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ad0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	31 c9                	xor    %ecx,%ecx
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	89 c8                	mov    %ecx,%eax
80105ad7:	57                   	push   %edi
80105ad8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105add:	56                   	push   %esi
80105ade:	89 fa                	mov    %edi,%edx
80105ae0:	53                   	push   %ebx
80105ae1:	83 ec 1c             	sub    $0x1c,%esp
80105ae4:	ee                   	out    %al,(%dx)
80105ae5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105aea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105aef:	89 f2                	mov    %esi,%edx
80105af1:	ee                   	out    %al,(%dx)
80105af2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105af7:	b2 f8                	mov    $0xf8,%dl
80105af9:	ee                   	out    %al,(%dx)
80105afa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105aff:	89 c8                	mov    %ecx,%eax
80105b01:	89 da                	mov    %ebx,%edx
80105b03:	ee                   	out    %al,(%dx)
80105b04:	b8 03 00 00 00       	mov    $0x3,%eax
80105b09:	89 f2                	mov    %esi,%edx
80105b0b:	ee                   	out    %al,(%dx)
80105b0c:	b2 fc                	mov    $0xfc,%dl
80105b0e:	89 c8                	mov    %ecx,%eax
80105b10:	ee                   	out    %al,(%dx)
80105b11:	b8 01 00 00 00       	mov    $0x1,%eax
80105b16:	89 da                	mov    %ebx,%edx
80105b18:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b19:	b2 fd                	mov    $0xfd,%dl
80105b1b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b1c:	3c ff                	cmp    $0xff,%al
80105b1e:	74 42                	je     80105b62 <uartinit+0x92>
    return;
  uart = 1;
80105b20:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105b27:	00 00 00 
80105b2a:	89 fa                	mov    %edi,%edx
80105b2c:	ec                   	in     (%dx),%al
80105b2d:	b2 f8                	mov    $0xf8,%dl
80105b2f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b37:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b38:	bb c8 81 10 80       	mov    $0x801081c8,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105b44:	e8 67 c7 ff ff       	call   801022b0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b49:	b8 78 00 00 00       	mov    $0x78,%eax
80105b4e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105b50:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b53:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105b56:	e8 25 ff ff ff       	call   80105a80 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b5b:	0f be 03             	movsbl (%ebx),%eax
80105b5e:	84 c0                	test   %al,%al
80105b60:	75 ee                	jne    80105b50 <uartinit+0x80>
    uartputc(*p);
}
80105b62:	83 c4 1c             	add    $0x1c,%esp
80105b65:	5b                   	pop    %ebx
80105b66:	5e                   	pop    %esi
80105b67:	5f                   	pop    %edi
80105b68:	5d                   	pop    %ebp
80105b69:	c3                   	ret    
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b70 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105b76:	c7 04 24 50 5a 10 80 	movl   $0x80105a50,(%esp)
80105b7d:	e8 2e ac ff ff       	call   801007b0 <consoleintr>
}
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    

80105b84 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b84:	6a 00                	push   $0x0
  pushl $0
80105b86:	6a 00                	push   $0x0
  jmp alltraps
80105b88:	e9 e0 f9 ff ff       	jmp    8010556d <alltraps>

80105b8d <vector1>:
.globl vector1
vector1:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $1
80105b8f:	6a 01                	push   $0x1
  jmp alltraps
80105b91:	e9 d7 f9 ff ff       	jmp    8010556d <alltraps>

80105b96 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b96:	6a 00                	push   $0x0
  pushl $2
80105b98:	6a 02                	push   $0x2
  jmp alltraps
80105b9a:	e9 ce f9 ff ff       	jmp    8010556d <alltraps>

80105b9f <vector3>:
.globl vector3
vector3:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $3
80105ba1:	6a 03                	push   $0x3
  jmp alltraps
80105ba3:	e9 c5 f9 ff ff       	jmp    8010556d <alltraps>

80105ba8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ba8:	6a 00                	push   $0x0
  pushl $4
80105baa:	6a 04                	push   $0x4
  jmp alltraps
80105bac:	e9 bc f9 ff ff       	jmp    8010556d <alltraps>

80105bb1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105bb1:	6a 00                	push   $0x0
  pushl $5
80105bb3:	6a 05                	push   $0x5
  jmp alltraps
80105bb5:	e9 b3 f9 ff ff       	jmp    8010556d <alltraps>

80105bba <vector6>:
.globl vector6
vector6:
  pushl $0
80105bba:	6a 00                	push   $0x0
  pushl $6
80105bbc:	6a 06                	push   $0x6
  jmp alltraps
80105bbe:	e9 aa f9 ff ff       	jmp    8010556d <alltraps>

80105bc3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $7
80105bc5:	6a 07                	push   $0x7
  jmp alltraps
80105bc7:	e9 a1 f9 ff ff       	jmp    8010556d <alltraps>

80105bcc <vector8>:
.globl vector8
vector8:
  pushl $8
80105bcc:	6a 08                	push   $0x8
  jmp alltraps
80105bce:	e9 9a f9 ff ff       	jmp    8010556d <alltraps>

80105bd3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $9
80105bd5:	6a 09                	push   $0x9
  jmp alltraps
80105bd7:	e9 91 f9 ff ff       	jmp    8010556d <alltraps>

80105bdc <vector10>:
.globl vector10
vector10:
  pushl $10
80105bdc:	6a 0a                	push   $0xa
  jmp alltraps
80105bde:	e9 8a f9 ff ff       	jmp    8010556d <alltraps>

80105be3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105be3:	6a 0b                	push   $0xb
  jmp alltraps
80105be5:	e9 83 f9 ff ff       	jmp    8010556d <alltraps>

80105bea <vector12>:
.globl vector12
vector12:
  pushl $12
80105bea:	6a 0c                	push   $0xc
  jmp alltraps
80105bec:	e9 7c f9 ff ff       	jmp    8010556d <alltraps>

80105bf1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105bf1:	6a 0d                	push   $0xd
  jmp alltraps
80105bf3:	e9 75 f9 ff ff       	jmp    8010556d <alltraps>

80105bf8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105bf8:	6a 0e                	push   $0xe
  jmp alltraps
80105bfa:	e9 6e f9 ff ff       	jmp    8010556d <alltraps>

80105bff <vector15>:
.globl vector15
vector15:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $15
80105c01:	6a 0f                	push   $0xf
  jmp alltraps
80105c03:	e9 65 f9 ff ff       	jmp    8010556d <alltraps>

80105c08 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $16
80105c0a:	6a 10                	push   $0x10
  jmp alltraps
80105c0c:	e9 5c f9 ff ff       	jmp    8010556d <alltraps>

80105c11 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c11:	6a 11                	push   $0x11
  jmp alltraps
80105c13:	e9 55 f9 ff ff       	jmp    8010556d <alltraps>

80105c18 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $18
80105c1a:	6a 12                	push   $0x12
  jmp alltraps
80105c1c:	e9 4c f9 ff ff       	jmp    8010556d <alltraps>

80105c21 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $19
80105c23:	6a 13                	push   $0x13
  jmp alltraps
80105c25:	e9 43 f9 ff ff       	jmp    8010556d <alltraps>

80105c2a <vector20>:
.globl vector20
vector20:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $20
80105c2c:	6a 14                	push   $0x14
  jmp alltraps
80105c2e:	e9 3a f9 ff ff       	jmp    8010556d <alltraps>

80105c33 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $21
80105c35:	6a 15                	push   $0x15
  jmp alltraps
80105c37:	e9 31 f9 ff ff       	jmp    8010556d <alltraps>

80105c3c <vector22>:
.globl vector22
vector22:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $22
80105c3e:	6a 16                	push   $0x16
  jmp alltraps
80105c40:	e9 28 f9 ff ff       	jmp    8010556d <alltraps>

80105c45 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $23
80105c47:	6a 17                	push   $0x17
  jmp alltraps
80105c49:	e9 1f f9 ff ff       	jmp    8010556d <alltraps>

80105c4e <vector24>:
.globl vector24
vector24:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $24
80105c50:	6a 18                	push   $0x18
  jmp alltraps
80105c52:	e9 16 f9 ff ff       	jmp    8010556d <alltraps>

80105c57 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $25
80105c59:	6a 19                	push   $0x19
  jmp alltraps
80105c5b:	e9 0d f9 ff ff       	jmp    8010556d <alltraps>

80105c60 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $26
80105c62:	6a 1a                	push   $0x1a
  jmp alltraps
80105c64:	e9 04 f9 ff ff       	jmp    8010556d <alltraps>

80105c69 <vector27>:
.globl vector27
vector27:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $27
80105c6b:	6a 1b                	push   $0x1b
  jmp alltraps
80105c6d:	e9 fb f8 ff ff       	jmp    8010556d <alltraps>

80105c72 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $28
80105c74:	6a 1c                	push   $0x1c
  jmp alltraps
80105c76:	e9 f2 f8 ff ff       	jmp    8010556d <alltraps>

80105c7b <vector29>:
.globl vector29
vector29:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $29
80105c7d:	6a 1d                	push   $0x1d
  jmp alltraps
80105c7f:	e9 e9 f8 ff ff       	jmp    8010556d <alltraps>

80105c84 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $30
80105c86:	6a 1e                	push   $0x1e
  jmp alltraps
80105c88:	e9 e0 f8 ff ff       	jmp    8010556d <alltraps>

80105c8d <vector31>:
.globl vector31
vector31:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $31
80105c8f:	6a 1f                	push   $0x1f
  jmp alltraps
80105c91:	e9 d7 f8 ff ff       	jmp    8010556d <alltraps>

80105c96 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $32
80105c98:	6a 20                	push   $0x20
  jmp alltraps
80105c9a:	e9 ce f8 ff ff       	jmp    8010556d <alltraps>

80105c9f <vector33>:
.globl vector33
vector33:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $33
80105ca1:	6a 21                	push   $0x21
  jmp alltraps
80105ca3:	e9 c5 f8 ff ff       	jmp    8010556d <alltraps>

80105ca8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $34
80105caa:	6a 22                	push   $0x22
  jmp alltraps
80105cac:	e9 bc f8 ff ff       	jmp    8010556d <alltraps>

80105cb1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $35
80105cb3:	6a 23                	push   $0x23
  jmp alltraps
80105cb5:	e9 b3 f8 ff ff       	jmp    8010556d <alltraps>

80105cba <vector36>:
.globl vector36
vector36:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $36
80105cbc:	6a 24                	push   $0x24
  jmp alltraps
80105cbe:	e9 aa f8 ff ff       	jmp    8010556d <alltraps>

80105cc3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $37
80105cc5:	6a 25                	push   $0x25
  jmp alltraps
80105cc7:	e9 a1 f8 ff ff       	jmp    8010556d <alltraps>

80105ccc <vector38>:
.globl vector38
vector38:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $38
80105cce:	6a 26                	push   $0x26
  jmp alltraps
80105cd0:	e9 98 f8 ff ff       	jmp    8010556d <alltraps>

80105cd5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $39
80105cd7:	6a 27                	push   $0x27
  jmp alltraps
80105cd9:	e9 8f f8 ff ff       	jmp    8010556d <alltraps>

80105cde <vector40>:
.globl vector40
vector40:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $40
80105ce0:	6a 28                	push   $0x28
  jmp alltraps
80105ce2:	e9 86 f8 ff ff       	jmp    8010556d <alltraps>

80105ce7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $41
80105ce9:	6a 29                	push   $0x29
  jmp alltraps
80105ceb:	e9 7d f8 ff ff       	jmp    8010556d <alltraps>

80105cf0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $42
80105cf2:	6a 2a                	push   $0x2a
  jmp alltraps
80105cf4:	e9 74 f8 ff ff       	jmp    8010556d <alltraps>

80105cf9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $43
80105cfb:	6a 2b                	push   $0x2b
  jmp alltraps
80105cfd:	e9 6b f8 ff ff       	jmp    8010556d <alltraps>

80105d02 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $44
80105d04:	6a 2c                	push   $0x2c
  jmp alltraps
80105d06:	e9 62 f8 ff ff       	jmp    8010556d <alltraps>

80105d0b <vector45>:
.globl vector45
vector45:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $45
80105d0d:	6a 2d                	push   $0x2d
  jmp alltraps
80105d0f:	e9 59 f8 ff ff       	jmp    8010556d <alltraps>

80105d14 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $46
80105d16:	6a 2e                	push   $0x2e
  jmp alltraps
80105d18:	e9 50 f8 ff ff       	jmp    8010556d <alltraps>

80105d1d <vector47>:
.globl vector47
vector47:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $47
80105d1f:	6a 2f                	push   $0x2f
  jmp alltraps
80105d21:	e9 47 f8 ff ff       	jmp    8010556d <alltraps>

80105d26 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $48
80105d28:	6a 30                	push   $0x30
  jmp alltraps
80105d2a:	e9 3e f8 ff ff       	jmp    8010556d <alltraps>

80105d2f <vector49>:
.globl vector49
vector49:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $49
80105d31:	6a 31                	push   $0x31
  jmp alltraps
80105d33:	e9 35 f8 ff ff       	jmp    8010556d <alltraps>

80105d38 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $50
80105d3a:	6a 32                	push   $0x32
  jmp alltraps
80105d3c:	e9 2c f8 ff ff       	jmp    8010556d <alltraps>

80105d41 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $51
80105d43:	6a 33                	push   $0x33
  jmp alltraps
80105d45:	e9 23 f8 ff ff       	jmp    8010556d <alltraps>

80105d4a <vector52>:
.globl vector52
vector52:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $52
80105d4c:	6a 34                	push   $0x34
  jmp alltraps
80105d4e:	e9 1a f8 ff ff       	jmp    8010556d <alltraps>

80105d53 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $53
80105d55:	6a 35                	push   $0x35
  jmp alltraps
80105d57:	e9 11 f8 ff ff       	jmp    8010556d <alltraps>

80105d5c <vector54>:
.globl vector54
vector54:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $54
80105d5e:	6a 36                	push   $0x36
  jmp alltraps
80105d60:	e9 08 f8 ff ff       	jmp    8010556d <alltraps>

80105d65 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $55
80105d67:	6a 37                	push   $0x37
  jmp alltraps
80105d69:	e9 ff f7 ff ff       	jmp    8010556d <alltraps>

80105d6e <vector56>:
.globl vector56
vector56:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $56
80105d70:	6a 38                	push   $0x38
  jmp alltraps
80105d72:	e9 f6 f7 ff ff       	jmp    8010556d <alltraps>

80105d77 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $57
80105d79:	6a 39                	push   $0x39
  jmp alltraps
80105d7b:	e9 ed f7 ff ff       	jmp    8010556d <alltraps>

80105d80 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $58
80105d82:	6a 3a                	push   $0x3a
  jmp alltraps
80105d84:	e9 e4 f7 ff ff       	jmp    8010556d <alltraps>

80105d89 <vector59>:
.globl vector59
vector59:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $59
80105d8b:	6a 3b                	push   $0x3b
  jmp alltraps
80105d8d:	e9 db f7 ff ff       	jmp    8010556d <alltraps>

80105d92 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $60
80105d94:	6a 3c                	push   $0x3c
  jmp alltraps
80105d96:	e9 d2 f7 ff ff       	jmp    8010556d <alltraps>

80105d9b <vector61>:
.globl vector61
vector61:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $61
80105d9d:	6a 3d                	push   $0x3d
  jmp alltraps
80105d9f:	e9 c9 f7 ff ff       	jmp    8010556d <alltraps>

80105da4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $62
80105da6:	6a 3e                	push   $0x3e
  jmp alltraps
80105da8:	e9 c0 f7 ff ff       	jmp    8010556d <alltraps>

80105dad <vector63>:
.globl vector63
vector63:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $63
80105daf:	6a 3f                	push   $0x3f
  jmp alltraps
80105db1:	e9 b7 f7 ff ff       	jmp    8010556d <alltraps>

80105db6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $64
80105db8:	6a 40                	push   $0x40
  jmp alltraps
80105dba:	e9 ae f7 ff ff       	jmp    8010556d <alltraps>

80105dbf <vector65>:
.globl vector65
vector65:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $65
80105dc1:	6a 41                	push   $0x41
  jmp alltraps
80105dc3:	e9 a5 f7 ff ff       	jmp    8010556d <alltraps>

80105dc8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $66
80105dca:	6a 42                	push   $0x42
  jmp alltraps
80105dcc:	e9 9c f7 ff ff       	jmp    8010556d <alltraps>

80105dd1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $67
80105dd3:	6a 43                	push   $0x43
  jmp alltraps
80105dd5:	e9 93 f7 ff ff       	jmp    8010556d <alltraps>

80105dda <vector68>:
.globl vector68
vector68:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $68
80105ddc:	6a 44                	push   $0x44
  jmp alltraps
80105dde:	e9 8a f7 ff ff       	jmp    8010556d <alltraps>

80105de3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $69
80105de5:	6a 45                	push   $0x45
  jmp alltraps
80105de7:	e9 81 f7 ff ff       	jmp    8010556d <alltraps>

80105dec <vector70>:
.globl vector70
vector70:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $70
80105dee:	6a 46                	push   $0x46
  jmp alltraps
80105df0:	e9 78 f7 ff ff       	jmp    8010556d <alltraps>

80105df5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $71
80105df7:	6a 47                	push   $0x47
  jmp alltraps
80105df9:	e9 6f f7 ff ff       	jmp    8010556d <alltraps>

80105dfe <vector72>:
.globl vector72
vector72:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $72
80105e00:	6a 48                	push   $0x48
  jmp alltraps
80105e02:	e9 66 f7 ff ff       	jmp    8010556d <alltraps>

80105e07 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $73
80105e09:	6a 49                	push   $0x49
  jmp alltraps
80105e0b:	e9 5d f7 ff ff       	jmp    8010556d <alltraps>

80105e10 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $74
80105e12:	6a 4a                	push   $0x4a
  jmp alltraps
80105e14:	e9 54 f7 ff ff       	jmp    8010556d <alltraps>

80105e19 <vector75>:
.globl vector75
vector75:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $75
80105e1b:	6a 4b                	push   $0x4b
  jmp alltraps
80105e1d:	e9 4b f7 ff ff       	jmp    8010556d <alltraps>

80105e22 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $76
80105e24:	6a 4c                	push   $0x4c
  jmp alltraps
80105e26:	e9 42 f7 ff ff       	jmp    8010556d <alltraps>

80105e2b <vector77>:
.globl vector77
vector77:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $77
80105e2d:	6a 4d                	push   $0x4d
  jmp alltraps
80105e2f:	e9 39 f7 ff ff       	jmp    8010556d <alltraps>

80105e34 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $78
80105e36:	6a 4e                	push   $0x4e
  jmp alltraps
80105e38:	e9 30 f7 ff ff       	jmp    8010556d <alltraps>

80105e3d <vector79>:
.globl vector79
vector79:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $79
80105e3f:	6a 4f                	push   $0x4f
  jmp alltraps
80105e41:	e9 27 f7 ff ff       	jmp    8010556d <alltraps>

80105e46 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $80
80105e48:	6a 50                	push   $0x50
  jmp alltraps
80105e4a:	e9 1e f7 ff ff       	jmp    8010556d <alltraps>

80105e4f <vector81>:
.globl vector81
vector81:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $81
80105e51:	6a 51                	push   $0x51
  jmp alltraps
80105e53:	e9 15 f7 ff ff       	jmp    8010556d <alltraps>

80105e58 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $82
80105e5a:	6a 52                	push   $0x52
  jmp alltraps
80105e5c:	e9 0c f7 ff ff       	jmp    8010556d <alltraps>

80105e61 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $83
80105e63:	6a 53                	push   $0x53
  jmp alltraps
80105e65:	e9 03 f7 ff ff       	jmp    8010556d <alltraps>

80105e6a <vector84>:
.globl vector84
vector84:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $84
80105e6c:	6a 54                	push   $0x54
  jmp alltraps
80105e6e:	e9 fa f6 ff ff       	jmp    8010556d <alltraps>

80105e73 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $85
80105e75:	6a 55                	push   $0x55
  jmp alltraps
80105e77:	e9 f1 f6 ff ff       	jmp    8010556d <alltraps>

80105e7c <vector86>:
.globl vector86
vector86:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $86
80105e7e:	6a 56                	push   $0x56
  jmp alltraps
80105e80:	e9 e8 f6 ff ff       	jmp    8010556d <alltraps>

80105e85 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $87
80105e87:	6a 57                	push   $0x57
  jmp alltraps
80105e89:	e9 df f6 ff ff       	jmp    8010556d <alltraps>

80105e8e <vector88>:
.globl vector88
vector88:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $88
80105e90:	6a 58                	push   $0x58
  jmp alltraps
80105e92:	e9 d6 f6 ff ff       	jmp    8010556d <alltraps>

80105e97 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $89
80105e99:	6a 59                	push   $0x59
  jmp alltraps
80105e9b:	e9 cd f6 ff ff       	jmp    8010556d <alltraps>

80105ea0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $90
80105ea2:	6a 5a                	push   $0x5a
  jmp alltraps
80105ea4:	e9 c4 f6 ff ff       	jmp    8010556d <alltraps>

80105ea9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $91
80105eab:	6a 5b                	push   $0x5b
  jmp alltraps
80105ead:	e9 bb f6 ff ff       	jmp    8010556d <alltraps>

80105eb2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $92
80105eb4:	6a 5c                	push   $0x5c
  jmp alltraps
80105eb6:	e9 b2 f6 ff ff       	jmp    8010556d <alltraps>

80105ebb <vector93>:
.globl vector93
vector93:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $93
80105ebd:	6a 5d                	push   $0x5d
  jmp alltraps
80105ebf:	e9 a9 f6 ff ff       	jmp    8010556d <alltraps>

80105ec4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $94
80105ec6:	6a 5e                	push   $0x5e
  jmp alltraps
80105ec8:	e9 a0 f6 ff ff       	jmp    8010556d <alltraps>

80105ecd <vector95>:
.globl vector95
vector95:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $95
80105ecf:	6a 5f                	push   $0x5f
  jmp alltraps
80105ed1:	e9 97 f6 ff ff       	jmp    8010556d <alltraps>

80105ed6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $96
80105ed8:	6a 60                	push   $0x60
  jmp alltraps
80105eda:	e9 8e f6 ff ff       	jmp    8010556d <alltraps>

80105edf <vector97>:
.globl vector97
vector97:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $97
80105ee1:	6a 61                	push   $0x61
  jmp alltraps
80105ee3:	e9 85 f6 ff ff       	jmp    8010556d <alltraps>

80105ee8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $98
80105eea:	6a 62                	push   $0x62
  jmp alltraps
80105eec:	e9 7c f6 ff ff       	jmp    8010556d <alltraps>

80105ef1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $99
80105ef3:	6a 63                	push   $0x63
  jmp alltraps
80105ef5:	e9 73 f6 ff ff       	jmp    8010556d <alltraps>

80105efa <vector100>:
.globl vector100
vector100:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $100
80105efc:	6a 64                	push   $0x64
  jmp alltraps
80105efe:	e9 6a f6 ff ff       	jmp    8010556d <alltraps>

80105f03 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $101
80105f05:	6a 65                	push   $0x65
  jmp alltraps
80105f07:	e9 61 f6 ff ff       	jmp    8010556d <alltraps>

80105f0c <vector102>:
.globl vector102
vector102:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $102
80105f0e:	6a 66                	push   $0x66
  jmp alltraps
80105f10:	e9 58 f6 ff ff       	jmp    8010556d <alltraps>

80105f15 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $103
80105f17:	6a 67                	push   $0x67
  jmp alltraps
80105f19:	e9 4f f6 ff ff       	jmp    8010556d <alltraps>

80105f1e <vector104>:
.globl vector104
vector104:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $104
80105f20:	6a 68                	push   $0x68
  jmp alltraps
80105f22:	e9 46 f6 ff ff       	jmp    8010556d <alltraps>

80105f27 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $105
80105f29:	6a 69                	push   $0x69
  jmp alltraps
80105f2b:	e9 3d f6 ff ff       	jmp    8010556d <alltraps>

80105f30 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $106
80105f32:	6a 6a                	push   $0x6a
  jmp alltraps
80105f34:	e9 34 f6 ff ff       	jmp    8010556d <alltraps>

80105f39 <vector107>:
.globl vector107
vector107:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $107
80105f3b:	6a 6b                	push   $0x6b
  jmp alltraps
80105f3d:	e9 2b f6 ff ff       	jmp    8010556d <alltraps>

80105f42 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $108
80105f44:	6a 6c                	push   $0x6c
  jmp alltraps
80105f46:	e9 22 f6 ff ff       	jmp    8010556d <alltraps>

80105f4b <vector109>:
.globl vector109
vector109:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $109
80105f4d:	6a 6d                	push   $0x6d
  jmp alltraps
80105f4f:	e9 19 f6 ff ff       	jmp    8010556d <alltraps>

80105f54 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $110
80105f56:	6a 6e                	push   $0x6e
  jmp alltraps
80105f58:	e9 10 f6 ff ff       	jmp    8010556d <alltraps>

80105f5d <vector111>:
.globl vector111
vector111:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $111
80105f5f:	6a 6f                	push   $0x6f
  jmp alltraps
80105f61:	e9 07 f6 ff ff       	jmp    8010556d <alltraps>

80105f66 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $112
80105f68:	6a 70                	push   $0x70
  jmp alltraps
80105f6a:	e9 fe f5 ff ff       	jmp    8010556d <alltraps>

80105f6f <vector113>:
.globl vector113
vector113:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $113
80105f71:	6a 71                	push   $0x71
  jmp alltraps
80105f73:	e9 f5 f5 ff ff       	jmp    8010556d <alltraps>

80105f78 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $114
80105f7a:	6a 72                	push   $0x72
  jmp alltraps
80105f7c:	e9 ec f5 ff ff       	jmp    8010556d <alltraps>

80105f81 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $115
80105f83:	6a 73                	push   $0x73
  jmp alltraps
80105f85:	e9 e3 f5 ff ff       	jmp    8010556d <alltraps>

80105f8a <vector116>:
.globl vector116
vector116:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $116
80105f8c:	6a 74                	push   $0x74
  jmp alltraps
80105f8e:	e9 da f5 ff ff       	jmp    8010556d <alltraps>

80105f93 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $117
80105f95:	6a 75                	push   $0x75
  jmp alltraps
80105f97:	e9 d1 f5 ff ff       	jmp    8010556d <alltraps>

80105f9c <vector118>:
.globl vector118
vector118:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $118
80105f9e:	6a 76                	push   $0x76
  jmp alltraps
80105fa0:	e9 c8 f5 ff ff       	jmp    8010556d <alltraps>

80105fa5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $119
80105fa7:	6a 77                	push   $0x77
  jmp alltraps
80105fa9:	e9 bf f5 ff ff       	jmp    8010556d <alltraps>

80105fae <vector120>:
.globl vector120
vector120:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $120
80105fb0:	6a 78                	push   $0x78
  jmp alltraps
80105fb2:	e9 b6 f5 ff ff       	jmp    8010556d <alltraps>

80105fb7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $121
80105fb9:	6a 79                	push   $0x79
  jmp alltraps
80105fbb:	e9 ad f5 ff ff       	jmp    8010556d <alltraps>

80105fc0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $122
80105fc2:	6a 7a                	push   $0x7a
  jmp alltraps
80105fc4:	e9 a4 f5 ff ff       	jmp    8010556d <alltraps>

80105fc9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $123
80105fcb:	6a 7b                	push   $0x7b
  jmp alltraps
80105fcd:	e9 9b f5 ff ff       	jmp    8010556d <alltraps>

80105fd2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $124
80105fd4:	6a 7c                	push   $0x7c
  jmp alltraps
80105fd6:	e9 92 f5 ff ff       	jmp    8010556d <alltraps>

80105fdb <vector125>:
.globl vector125
vector125:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $125
80105fdd:	6a 7d                	push   $0x7d
  jmp alltraps
80105fdf:	e9 89 f5 ff ff       	jmp    8010556d <alltraps>

80105fe4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $126
80105fe6:	6a 7e                	push   $0x7e
  jmp alltraps
80105fe8:	e9 80 f5 ff ff       	jmp    8010556d <alltraps>

80105fed <vector127>:
.globl vector127
vector127:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $127
80105fef:	6a 7f                	push   $0x7f
  jmp alltraps
80105ff1:	e9 77 f5 ff ff       	jmp    8010556d <alltraps>

80105ff6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $128
80105ff8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105ffd:	e9 6b f5 ff ff       	jmp    8010556d <alltraps>

80106002 <vector129>:
.globl vector129
vector129:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $129
80106004:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106009:	e9 5f f5 ff ff       	jmp    8010556d <alltraps>

8010600e <vector130>:
.globl vector130
vector130:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $130
80106010:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106015:	e9 53 f5 ff ff       	jmp    8010556d <alltraps>

8010601a <vector131>:
.globl vector131
vector131:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $131
8010601c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106021:	e9 47 f5 ff ff       	jmp    8010556d <alltraps>

80106026 <vector132>:
.globl vector132
vector132:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $132
80106028:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010602d:	e9 3b f5 ff ff       	jmp    8010556d <alltraps>

80106032 <vector133>:
.globl vector133
vector133:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $133
80106034:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106039:	e9 2f f5 ff ff       	jmp    8010556d <alltraps>

8010603e <vector134>:
.globl vector134
vector134:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $134
80106040:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106045:	e9 23 f5 ff ff       	jmp    8010556d <alltraps>

8010604a <vector135>:
.globl vector135
vector135:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $135
8010604c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106051:	e9 17 f5 ff ff       	jmp    8010556d <alltraps>

80106056 <vector136>:
.globl vector136
vector136:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $136
80106058:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010605d:	e9 0b f5 ff ff       	jmp    8010556d <alltraps>

80106062 <vector137>:
.globl vector137
vector137:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $137
80106064:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106069:	e9 ff f4 ff ff       	jmp    8010556d <alltraps>

8010606e <vector138>:
.globl vector138
vector138:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $138
80106070:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106075:	e9 f3 f4 ff ff       	jmp    8010556d <alltraps>

8010607a <vector139>:
.globl vector139
vector139:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $139
8010607c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106081:	e9 e7 f4 ff ff       	jmp    8010556d <alltraps>

80106086 <vector140>:
.globl vector140
vector140:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $140
80106088:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010608d:	e9 db f4 ff ff       	jmp    8010556d <alltraps>

80106092 <vector141>:
.globl vector141
vector141:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $141
80106094:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106099:	e9 cf f4 ff ff       	jmp    8010556d <alltraps>

8010609e <vector142>:
.globl vector142
vector142:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $142
801060a0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060a5:	e9 c3 f4 ff ff       	jmp    8010556d <alltraps>

801060aa <vector143>:
.globl vector143
vector143:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $143
801060ac:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060b1:	e9 b7 f4 ff ff       	jmp    8010556d <alltraps>

801060b6 <vector144>:
.globl vector144
vector144:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $144
801060b8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060bd:	e9 ab f4 ff ff       	jmp    8010556d <alltraps>

801060c2 <vector145>:
.globl vector145
vector145:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $145
801060c4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060c9:	e9 9f f4 ff ff       	jmp    8010556d <alltraps>

801060ce <vector146>:
.globl vector146
vector146:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $146
801060d0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060d5:	e9 93 f4 ff ff       	jmp    8010556d <alltraps>

801060da <vector147>:
.globl vector147
vector147:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $147
801060dc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060e1:	e9 87 f4 ff ff       	jmp    8010556d <alltraps>

801060e6 <vector148>:
.globl vector148
vector148:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $148
801060e8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060ed:	e9 7b f4 ff ff       	jmp    8010556d <alltraps>

801060f2 <vector149>:
.globl vector149
vector149:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $149
801060f4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060f9:	e9 6f f4 ff ff       	jmp    8010556d <alltraps>

801060fe <vector150>:
.globl vector150
vector150:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $150
80106100:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106105:	e9 63 f4 ff ff       	jmp    8010556d <alltraps>

8010610a <vector151>:
.globl vector151
vector151:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $151
8010610c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106111:	e9 57 f4 ff ff       	jmp    8010556d <alltraps>

80106116 <vector152>:
.globl vector152
vector152:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $152
80106118:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010611d:	e9 4b f4 ff ff       	jmp    8010556d <alltraps>

80106122 <vector153>:
.globl vector153
vector153:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $153
80106124:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106129:	e9 3f f4 ff ff       	jmp    8010556d <alltraps>

8010612e <vector154>:
.globl vector154
vector154:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $154
80106130:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106135:	e9 33 f4 ff ff       	jmp    8010556d <alltraps>

8010613a <vector155>:
.globl vector155
vector155:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $155
8010613c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106141:	e9 27 f4 ff ff       	jmp    8010556d <alltraps>

80106146 <vector156>:
.globl vector156
vector156:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $156
80106148:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010614d:	e9 1b f4 ff ff       	jmp    8010556d <alltraps>

80106152 <vector157>:
.globl vector157
vector157:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $157
80106154:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106159:	e9 0f f4 ff ff       	jmp    8010556d <alltraps>

8010615e <vector158>:
.globl vector158
vector158:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $158
80106160:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106165:	e9 03 f4 ff ff       	jmp    8010556d <alltraps>

8010616a <vector159>:
.globl vector159
vector159:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $159
8010616c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106171:	e9 f7 f3 ff ff       	jmp    8010556d <alltraps>

80106176 <vector160>:
.globl vector160
vector160:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $160
80106178:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010617d:	e9 eb f3 ff ff       	jmp    8010556d <alltraps>

80106182 <vector161>:
.globl vector161
vector161:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $161
80106184:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106189:	e9 df f3 ff ff       	jmp    8010556d <alltraps>

8010618e <vector162>:
.globl vector162
vector162:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $162
80106190:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106195:	e9 d3 f3 ff ff       	jmp    8010556d <alltraps>

8010619a <vector163>:
.globl vector163
vector163:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $163
8010619c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061a1:	e9 c7 f3 ff ff       	jmp    8010556d <alltraps>

801061a6 <vector164>:
.globl vector164
vector164:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $164
801061a8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061ad:	e9 bb f3 ff ff       	jmp    8010556d <alltraps>

801061b2 <vector165>:
.globl vector165
vector165:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $165
801061b4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061b9:	e9 af f3 ff ff       	jmp    8010556d <alltraps>

801061be <vector166>:
.globl vector166
vector166:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $166
801061c0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061c5:	e9 a3 f3 ff ff       	jmp    8010556d <alltraps>

801061ca <vector167>:
.globl vector167
vector167:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $167
801061cc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061d1:	e9 97 f3 ff ff       	jmp    8010556d <alltraps>

801061d6 <vector168>:
.globl vector168
vector168:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $168
801061d8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061dd:	e9 8b f3 ff ff       	jmp    8010556d <alltraps>

801061e2 <vector169>:
.globl vector169
vector169:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $169
801061e4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061e9:	e9 7f f3 ff ff       	jmp    8010556d <alltraps>

801061ee <vector170>:
.globl vector170
vector170:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $170
801061f0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061f5:	e9 73 f3 ff ff       	jmp    8010556d <alltraps>

801061fa <vector171>:
.globl vector171
vector171:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $171
801061fc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106201:	e9 67 f3 ff ff       	jmp    8010556d <alltraps>

80106206 <vector172>:
.globl vector172
vector172:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $172
80106208:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010620d:	e9 5b f3 ff ff       	jmp    8010556d <alltraps>

80106212 <vector173>:
.globl vector173
vector173:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $173
80106214:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106219:	e9 4f f3 ff ff       	jmp    8010556d <alltraps>

8010621e <vector174>:
.globl vector174
vector174:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $174
80106220:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106225:	e9 43 f3 ff ff       	jmp    8010556d <alltraps>

8010622a <vector175>:
.globl vector175
vector175:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $175
8010622c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106231:	e9 37 f3 ff ff       	jmp    8010556d <alltraps>

80106236 <vector176>:
.globl vector176
vector176:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $176
80106238:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010623d:	e9 2b f3 ff ff       	jmp    8010556d <alltraps>

80106242 <vector177>:
.globl vector177
vector177:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $177
80106244:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106249:	e9 1f f3 ff ff       	jmp    8010556d <alltraps>

8010624e <vector178>:
.globl vector178
vector178:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $178
80106250:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106255:	e9 13 f3 ff ff       	jmp    8010556d <alltraps>

8010625a <vector179>:
.globl vector179
vector179:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $179
8010625c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106261:	e9 07 f3 ff ff       	jmp    8010556d <alltraps>

80106266 <vector180>:
.globl vector180
vector180:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $180
80106268:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010626d:	e9 fb f2 ff ff       	jmp    8010556d <alltraps>

80106272 <vector181>:
.globl vector181
vector181:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $181
80106274:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106279:	e9 ef f2 ff ff       	jmp    8010556d <alltraps>

8010627e <vector182>:
.globl vector182
vector182:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $182
80106280:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106285:	e9 e3 f2 ff ff       	jmp    8010556d <alltraps>

8010628a <vector183>:
.globl vector183
vector183:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $183
8010628c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106291:	e9 d7 f2 ff ff       	jmp    8010556d <alltraps>

80106296 <vector184>:
.globl vector184
vector184:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $184
80106298:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010629d:	e9 cb f2 ff ff       	jmp    8010556d <alltraps>

801062a2 <vector185>:
.globl vector185
vector185:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $185
801062a4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062a9:	e9 bf f2 ff ff       	jmp    8010556d <alltraps>

801062ae <vector186>:
.globl vector186
vector186:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $186
801062b0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062b5:	e9 b3 f2 ff ff       	jmp    8010556d <alltraps>

801062ba <vector187>:
.globl vector187
vector187:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $187
801062bc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062c1:	e9 a7 f2 ff ff       	jmp    8010556d <alltraps>

801062c6 <vector188>:
.globl vector188
vector188:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $188
801062c8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062cd:	e9 9b f2 ff ff       	jmp    8010556d <alltraps>

801062d2 <vector189>:
.globl vector189
vector189:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $189
801062d4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062d9:	e9 8f f2 ff ff       	jmp    8010556d <alltraps>

801062de <vector190>:
.globl vector190
vector190:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $190
801062e0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062e5:	e9 83 f2 ff ff       	jmp    8010556d <alltraps>

801062ea <vector191>:
.globl vector191
vector191:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $191
801062ec:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062f1:	e9 77 f2 ff ff       	jmp    8010556d <alltraps>

801062f6 <vector192>:
.globl vector192
vector192:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $192
801062f8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062fd:	e9 6b f2 ff ff       	jmp    8010556d <alltraps>

80106302 <vector193>:
.globl vector193
vector193:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $193
80106304:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106309:	e9 5f f2 ff ff       	jmp    8010556d <alltraps>

8010630e <vector194>:
.globl vector194
vector194:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $194
80106310:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106315:	e9 53 f2 ff ff       	jmp    8010556d <alltraps>

8010631a <vector195>:
.globl vector195
vector195:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $195
8010631c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106321:	e9 47 f2 ff ff       	jmp    8010556d <alltraps>

80106326 <vector196>:
.globl vector196
vector196:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $196
80106328:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010632d:	e9 3b f2 ff ff       	jmp    8010556d <alltraps>

80106332 <vector197>:
.globl vector197
vector197:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $197
80106334:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106339:	e9 2f f2 ff ff       	jmp    8010556d <alltraps>

8010633e <vector198>:
.globl vector198
vector198:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $198
80106340:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106345:	e9 23 f2 ff ff       	jmp    8010556d <alltraps>

8010634a <vector199>:
.globl vector199
vector199:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $199
8010634c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106351:	e9 17 f2 ff ff       	jmp    8010556d <alltraps>

80106356 <vector200>:
.globl vector200
vector200:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $200
80106358:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010635d:	e9 0b f2 ff ff       	jmp    8010556d <alltraps>

80106362 <vector201>:
.globl vector201
vector201:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $201
80106364:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106369:	e9 ff f1 ff ff       	jmp    8010556d <alltraps>

8010636e <vector202>:
.globl vector202
vector202:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $202
80106370:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106375:	e9 f3 f1 ff ff       	jmp    8010556d <alltraps>

8010637a <vector203>:
.globl vector203
vector203:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $203
8010637c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106381:	e9 e7 f1 ff ff       	jmp    8010556d <alltraps>

80106386 <vector204>:
.globl vector204
vector204:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $204
80106388:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010638d:	e9 db f1 ff ff       	jmp    8010556d <alltraps>

80106392 <vector205>:
.globl vector205
vector205:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $205
80106394:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106399:	e9 cf f1 ff ff       	jmp    8010556d <alltraps>

8010639e <vector206>:
.globl vector206
vector206:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $206
801063a0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063a5:	e9 c3 f1 ff ff       	jmp    8010556d <alltraps>

801063aa <vector207>:
.globl vector207
vector207:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $207
801063ac:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063b1:	e9 b7 f1 ff ff       	jmp    8010556d <alltraps>

801063b6 <vector208>:
.globl vector208
vector208:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $208
801063b8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063bd:	e9 ab f1 ff ff       	jmp    8010556d <alltraps>

801063c2 <vector209>:
.globl vector209
vector209:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $209
801063c4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063c9:	e9 9f f1 ff ff       	jmp    8010556d <alltraps>

801063ce <vector210>:
.globl vector210
vector210:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $210
801063d0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063d5:	e9 93 f1 ff ff       	jmp    8010556d <alltraps>

801063da <vector211>:
.globl vector211
vector211:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $211
801063dc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063e1:	e9 87 f1 ff ff       	jmp    8010556d <alltraps>

801063e6 <vector212>:
.globl vector212
vector212:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $212
801063e8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063ed:	e9 7b f1 ff ff       	jmp    8010556d <alltraps>

801063f2 <vector213>:
.globl vector213
vector213:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $213
801063f4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063f9:	e9 6f f1 ff ff       	jmp    8010556d <alltraps>

801063fe <vector214>:
.globl vector214
vector214:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $214
80106400:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106405:	e9 63 f1 ff ff       	jmp    8010556d <alltraps>

8010640a <vector215>:
.globl vector215
vector215:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $215
8010640c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106411:	e9 57 f1 ff ff       	jmp    8010556d <alltraps>

80106416 <vector216>:
.globl vector216
vector216:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $216
80106418:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010641d:	e9 4b f1 ff ff       	jmp    8010556d <alltraps>

80106422 <vector217>:
.globl vector217
vector217:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $217
80106424:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106429:	e9 3f f1 ff ff       	jmp    8010556d <alltraps>

8010642e <vector218>:
.globl vector218
vector218:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $218
80106430:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106435:	e9 33 f1 ff ff       	jmp    8010556d <alltraps>

8010643a <vector219>:
.globl vector219
vector219:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $219
8010643c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106441:	e9 27 f1 ff ff       	jmp    8010556d <alltraps>

80106446 <vector220>:
.globl vector220
vector220:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $220
80106448:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010644d:	e9 1b f1 ff ff       	jmp    8010556d <alltraps>

80106452 <vector221>:
.globl vector221
vector221:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $221
80106454:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106459:	e9 0f f1 ff ff       	jmp    8010556d <alltraps>

8010645e <vector222>:
.globl vector222
vector222:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $222
80106460:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106465:	e9 03 f1 ff ff       	jmp    8010556d <alltraps>

8010646a <vector223>:
.globl vector223
vector223:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $223
8010646c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106471:	e9 f7 f0 ff ff       	jmp    8010556d <alltraps>

80106476 <vector224>:
.globl vector224
vector224:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $224
80106478:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010647d:	e9 eb f0 ff ff       	jmp    8010556d <alltraps>

80106482 <vector225>:
.globl vector225
vector225:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $225
80106484:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106489:	e9 df f0 ff ff       	jmp    8010556d <alltraps>

8010648e <vector226>:
.globl vector226
vector226:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $226
80106490:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106495:	e9 d3 f0 ff ff       	jmp    8010556d <alltraps>

8010649a <vector227>:
.globl vector227
vector227:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $227
8010649c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064a1:	e9 c7 f0 ff ff       	jmp    8010556d <alltraps>

801064a6 <vector228>:
.globl vector228
vector228:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $228
801064a8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064ad:	e9 bb f0 ff ff       	jmp    8010556d <alltraps>

801064b2 <vector229>:
.globl vector229
vector229:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $229
801064b4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064b9:	e9 af f0 ff ff       	jmp    8010556d <alltraps>

801064be <vector230>:
.globl vector230
vector230:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $230
801064c0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064c5:	e9 a3 f0 ff ff       	jmp    8010556d <alltraps>

801064ca <vector231>:
.globl vector231
vector231:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $231
801064cc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064d1:	e9 97 f0 ff ff       	jmp    8010556d <alltraps>

801064d6 <vector232>:
.globl vector232
vector232:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $232
801064d8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064dd:	e9 8b f0 ff ff       	jmp    8010556d <alltraps>

801064e2 <vector233>:
.globl vector233
vector233:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $233
801064e4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064e9:	e9 7f f0 ff ff       	jmp    8010556d <alltraps>

801064ee <vector234>:
.globl vector234
vector234:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $234
801064f0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064f5:	e9 73 f0 ff ff       	jmp    8010556d <alltraps>

801064fa <vector235>:
.globl vector235
vector235:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $235
801064fc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106501:	e9 67 f0 ff ff       	jmp    8010556d <alltraps>

80106506 <vector236>:
.globl vector236
vector236:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $236
80106508:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010650d:	e9 5b f0 ff ff       	jmp    8010556d <alltraps>

80106512 <vector237>:
.globl vector237
vector237:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $237
80106514:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106519:	e9 4f f0 ff ff       	jmp    8010556d <alltraps>

8010651e <vector238>:
.globl vector238
vector238:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $238
80106520:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106525:	e9 43 f0 ff ff       	jmp    8010556d <alltraps>

8010652a <vector239>:
.globl vector239
vector239:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $239
8010652c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106531:	e9 37 f0 ff ff       	jmp    8010556d <alltraps>

80106536 <vector240>:
.globl vector240
vector240:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $240
80106538:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010653d:	e9 2b f0 ff ff       	jmp    8010556d <alltraps>

80106542 <vector241>:
.globl vector241
vector241:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $241
80106544:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106549:	e9 1f f0 ff ff       	jmp    8010556d <alltraps>

8010654e <vector242>:
.globl vector242
vector242:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $242
80106550:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106555:	e9 13 f0 ff ff       	jmp    8010556d <alltraps>

8010655a <vector243>:
.globl vector243
vector243:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $243
8010655c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106561:	e9 07 f0 ff ff       	jmp    8010556d <alltraps>

80106566 <vector244>:
.globl vector244
vector244:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $244
80106568:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010656d:	e9 fb ef ff ff       	jmp    8010556d <alltraps>

80106572 <vector245>:
.globl vector245
vector245:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $245
80106574:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106579:	e9 ef ef ff ff       	jmp    8010556d <alltraps>

8010657e <vector246>:
.globl vector246
vector246:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $246
80106580:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106585:	e9 e3 ef ff ff       	jmp    8010556d <alltraps>

8010658a <vector247>:
.globl vector247
vector247:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $247
8010658c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106591:	e9 d7 ef ff ff       	jmp    8010556d <alltraps>

80106596 <vector248>:
.globl vector248
vector248:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $248
80106598:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010659d:	e9 cb ef ff ff       	jmp    8010556d <alltraps>

801065a2 <vector249>:
.globl vector249
vector249:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $249
801065a4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065a9:	e9 bf ef ff ff       	jmp    8010556d <alltraps>

801065ae <vector250>:
.globl vector250
vector250:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $250
801065b0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065b5:	e9 b3 ef ff ff       	jmp    8010556d <alltraps>

801065ba <vector251>:
.globl vector251
vector251:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $251
801065bc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065c1:	e9 a7 ef ff ff       	jmp    8010556d <alltraps>

801065c6 <vector252>:
.globl vector252
vector252:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $252
801065c8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065cd:	e9 9b ef ff ff       	jmp    8010556d <alltraps>

801065d2 <vector253>:
.globl vector253
vector253:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $253
801065d4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065d9:	e9 8f ef ff ff       	jmp    8010556d <alltraps>

801065de <vector254>:
.globl vector254
vector254:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $254
801065e0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065e5:	e9 83 ef ff ff       	jmp    8010556d <alltraps>

801065ea <vector255>:
.globl vector255
vector255:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $255
801065ec:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065f1:	e9 77 ef ff ff       	jmp    8010556d <alltraps>
801065f6:	66 90                	xchg   %ax,%ax
801065f8:	66 90                	xchg   %ax,%ax
801065fa:	66 90                	xchg   %ax,%ax
801065fc:	66 90                	xchg   %ax,%ax
801065fe:	66 90                	xchg   %ax,%ax

80106600 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106606:	e8 c5 d0 ff ff       	call   801036d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010660b:	31 c9                	xor    %ecx,%ecx
8010660d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106612:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106618:	05 80 37 11 80       	add    $0x80113780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010661d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106621:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106626:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106629:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010662d:	31 c9                	xor    %ecx,%ecx
8010662f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106633:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106638:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010663c:	31 c9                	xor    %ecx,%ecx
8010663e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106642:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106647:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010664b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010664d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106651:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106655:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106659:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010665d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106661:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106665:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106669:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010666d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106671:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106676:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010667a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010667e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106682:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106686:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010668a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010668e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106692:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106696:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010669a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010669e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801066a2:	c1 e8 10             	shr    $0x10,%eax
801066a5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801066a9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066ac:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801066af:	c9                   	leave  
801066b0:	c3                   	ret    
801066b1:	eb 0d                	jmp    801066c0 <walkpgdir>
801066b3:	90                   	nop
801066b4:	90                   	nop
801066b5:	90                   	nop
801066b6:	90                   	nop
801066b7:	90                   	nop
801066b8:	90                   	nop
801066b9:	90                   	nop
801066ba:	90                   	nop
801066bb:	90                   	nop
801066bc:	90                   	nop
801066bd:	90                   	nop
801066be:	90                   	nop
801066bf:	90                   	nop

801066c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	57                   	push   %edi
801066c4:	56                   	push   %esi
801066c5:	53                   	push   %ebx
801066c6:	83 ec 1c             	sub    $0x1c,%esp
801066c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066cc:	8b 55 08             	mov    0x8(%ebp),%edx
801066cf:	89 fb                	mov    %edi,%ebx
801066d1:	c1 eb 16             	shr    $0x16,%ebx
801066d4:	8d 1c 9a             	lea    (%edx,%ebx,4),%ebx
  if(*pde & PTE_P){
801066d7:	8b 33                	mov    (%ebx),%esi
801066d9:	f7 c6 01 00 00 00    	test   $0x1,%esi
801066df:	74 27                	je     80106708 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066e1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801066e7:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066ed:	89 fa                	mov    %edi,%edx
}
801066ef:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066f2:	c1 ea 0a             	shr    $0xa,%edx
801066f5:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
}
801066fb:	5b                   	pop    %ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066fc:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
801066ff:	5e                   	pop    %esi
80106700:	5f                   	pop    %edi
80106701:	5d                   	pop    %ebp
80106702:	c3                   	ret    
80106703:	90                   	nop
80106704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106708:	8b 45 10             	mov    0x10(%ebp),%eax
8010670b:	85 c0                	test   %eax,%eax
8010670d:	74 31                	je     80106740 <walkpgdir+0x80>
8010670f:	e8 8c bd ff ff       	call   801024a0 <kalloc>
80106714:	85 c0                	test   %eax,%eax
80106716:	89 c6                	mov    %eax,%esi
80106718:	74 26                	je     80106740 <walkpgdir+0x80>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010671a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106721:	00 
80106722:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106729:	00 
8010672a:	89 04 24             	mov    %eax,(%esp)
8010672d:	e8 4e dc ff ff       	call   80104380 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106732:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106738:	83 c8 07             	or     $0x7,%eax
8010673b:	89 03                	mov    %eax,(%ebx)
8010673d:	eb ae                	jmp    801066ed <walkpgdir+0x2d>
8010673f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106740:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106743:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
80106749:	c3                   	ret    
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106750 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106757:	8d b9 ff 0f 00 00    	lea    0xfff(%ecx),%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010675d:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010675e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106764:	83 ec 2c             	sub    $0x2c,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106767:	39 d7                	cmp    %edx,%edi
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106769:	89 d3                	mov    %edx,%ebx
8010676b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010676e:	72 3b                	jb     801067ab <deallocuvm.part.0+0x5b>
80106770:	eb 6e                	jmp    801067e0 <deallocuvm.part.0+0x90>
80106772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106778:	8b 08                	mov    (%eax),%ecx
8010677a:	f6 c1 01             	test   $0x1,%cl
8010677d:	74 22                	je     801067a1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010677f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106785:	74 64                	je     801067eb <deallocuvm.part.0+0x9b>
        panic("kfree");
      char *v = P2V(pa);
80106787:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
      kfree(v);
8010678d:	89 0c 24             	mov    %ecx,(%esp)
80106790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106793:	e8 58 bb ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010679b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067a7:	39 df                	cmp    %ebx,%edi
801067a9:	73 35                	jae    801067e0 <deallocuvm.part.0+0x90>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801067b2:	00 
801067b3:	89 7c 24 04          	mov    %edi,0x4(%esp)
801067b7:	89 34 24             	mov    %esi,(%esp)
801067ba:	e8 01 ff ff ff       	call   801066c0 <walkpgdir>
    if(!pte)
801067bf:	85 c0                	test   %eax,%eax
801067c1:	75 b5                	jne    80106778 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067c3:	89 fa                	mov    %edi,%edx
801067c5:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801067cb:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067d1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067d7:	39 df                	cmp    %ebx,%edi
801067d9:	72 d0                	jb     801067ab <deallocuvm.part.0+0x5b>
801067db:	90                   	nop
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067e3:	83 c4 2c             	add    $0x2c,%esp
801067e6:	5b                   	pop    %ebx
801067e7:	5e                   	pop    %esi
801067e8:	5f                   	pop    %edi
801067e9:	5d                   	pop    %ebp
801067ea:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067eb:	c7 04 24 de 79 10 80 	movl   $0x801079de,(%esp)
801067f2:	e8 69 9b ff ff       	call   80100360 <panic>
801067f7:	89 f6                	mov    %esi,%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106800 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	83 ec 1c             	sub    $0x1c,%esp
80106809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010680c:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010680f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106812:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106816:	89 c7                	mov    %eax,%edi
80106818:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010681e:	29 fe                	sub    %edi,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106820:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106824:	89 75 14             	mov    %esi,0x14(%ebp)
80106827:	89 fe                	mov    %edi,%esi
80106829:	8b 7d 14             	mov    0x14(%ebp),%edi
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010682c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010682f:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106836:	eb 15                	jmp    8010684d <mappages+0x4d>
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106838:	f6 00 01             	testb  $0x1,(%eax)
8010683b:	75 45                	jne    80106882 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010683d:	0b 5d 18             	or     0x18(%ebp),%ebx
    if(a == last)
80106840:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106843:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106845:	74 31                	je     80106878 <mappages+0x78>
      break;
    a += PGSIZE;
80106847:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010684d:	8b 45 08             	mov    0x8(%ebp),%eax
80106850:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106853:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010685a:	00 
8010685b:	89 74 24 04          	mov    %esi,0x4(%esp)
8010685f:	89 04 24             	mov    %eax,(%esp)
80106862:	e8 59 fe ff ff       	call   801066c0 <walkpgdir>
80106867:	85 c0                	test   %eax,%eax
80106869:	75 cd                	jne    80106838 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010686b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010686e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106873:	5b                   	pop    %ebx
80106874:	5e                   	pop    %esi
80106875:	5f                   	pop    %edi
80106876:	5d                   	pop    %ebp
80106877:	c3                   	ret    
80106878:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010687b:	31 c0                	xor    %eax,%eax
}
8010687d:	5b                   	pop    %ebx
8010687e:	5e                   	pop    %esi
8010687f:	5f                   	pop    %edi
80106880:	5d                   	pop    %ebp
80106881:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106882:	c7 04 24 d0 81 10 80 	movl   $0x801081d0,(%esp)
80106889:	e8 d2 9a ff ff       	call   80100360 <panic>
8010688e:	66 90                	xchg   %ax,%ax

80106890 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106890:	a1 a4 6d 11 80       	mov    0x80116da4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106898:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010689d:	0f 22 d8             	mov    %eax,%cr3
}
801068a0:	5d                   	pop    %ebp
801068a1:	c3                   	ret    
801068a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
801068b6:	83 ec 1c             	sub    $0x1c,%esp
801068b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068bc:	85 f6                	test   %esi,%esi
801068be:	0f 84 cd 00 00 00    	je     80106991 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068c4:	8b 46 08             	mov    0x8(%esi),%eax
801068c7:	85 c0                	test   %eax,%eax
801068c9:	0f 84 da 00 00 00    	je     801069a9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068cf:	8b 7e 04             	mov    0x4(%esi),%edi
801068d2:	85 ff                	test   %edi,%edi
801068d4:	0f 84 c3 00 00 00    	je     8010699d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801068da:	e8 21 d9 ff ff       	call   80104200 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068df:	e8 6c cd ff ff       	call   80103650 <mycpu>
801068e4:	89 c3                	mov    %eax,%ebx
801068e6:	e8 65 cd ff ff       	call   80103650 <mycpu>
801068eb:	89 c7                	mov    %eax,%edi
801068ed:	e8 5e cd ff ff       	call   80103650 <mycpu>
801068f2:	83 c7 08             	add    $0x8,%edi
801068f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068f8:	e8 53 cd ff ff       	call   80103650 <mycpu>
801068fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106900:	ba 67 00 00 00       	mov    $0x67,%edx
80106905:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010690c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106913:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010691a:	83 c1 08             	add    $0x8,%ecx
8010691d:	c1 e9 10             	shr    $0x10,%ecx
80106920:	83 c0 08             	add    $0x8,%eax
80106923:	c1 e8 18             	shr    $0x18,%eax
80106926:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010692c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106933:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106939:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010693e:	e8 0d cd ff ff       	call   80103650 <mycpu>
80106943:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010694a:	e8 01 cd ff ff       	call   80103650 <mycpu>
8010694f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106954:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106958:	e8 f3 cc ff ff       	call   80103650 <mycpu>
8010695d:	8b 56 08             	mov    0x8(%esi),%edx
80106960:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106966:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106969:	e8 e2 cc ff ff       	call   80103650 <mycpu>
8010696e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106972:	b8 28 00 00 00       	mov    $0x28,%eax
80106977:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010697a:	8b 46 04             	mov    0x4(%esi),%eax
8010697d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106982:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106985:	83 c4 1c             	add    $0x1c,%esp
80106988:	5b                   	pop    %ebx
80106989:	5e                   	pop    %esi
8010698a:	5f                   	pop    %edi
8010698b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010698c:	e9 2f d9 ff ff       	jmp    801042c0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106991:	c7 04 24 d6 81 10 80 	movl   $0x801081d6,(%esp)
80106998:	e8 c3 99 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010699d:	c7 04 24 01 82 10 80 	movl   $0x80108201,(%esp)
801069a4:	e8 b7 99 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069a9:	c7 04 24 ec 81 10 80 	movl   $0x801081ec,(%esp)
801069b0:	e8 ab 99 ff ff       	call   80100360 <panic>
801069b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 2c             	sub    $0x2c,%esp
801069c9:	8b 75 10             	mov    0x10(%ebp),%esi
801069cc:	8b 55 08             	mov    0x8(%ebp),%edx
801069cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069d8:	77 64                	ja     80106a3e <inituvm+0x7e>
801069da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801069dd:	e8 be ba ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
801069e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069e9:	00 
801069ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069f1:	00 
801069f2:	89 04 24             	mov    %eax,(%esp)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069f7:	e8 84 d9 ff ff       	call   80104380 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a05:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106a0c:	00 
80106a0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a11:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a18:	00 
80106a19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a20:	00 
80106a21:	89 14 24             	mov    %edx,(%esp)
80106a24:	e8 d7 fd ff ff       	call   80106800 <mappages>
  memmove(mem, init, sz);
80106a29:	89 75 10             	mov    %esi,0x10(%ebp)
80106a2c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a32:	83 c4 2c             	add    $0x2c,%esp
80106a35:	5b                   	pop    %ebx
80106a36:	5e                   	pop    %esi
80106a37:	5f                   	pop    %edi
80106a38:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a39:	e9 e2 d9 ff ff       	jmp    80104420 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a3e:	c7 04 24 15 82 10 80 	movl   $0x80108215,(%esp)
80106a45:	e8 16 99 ff ff       	call   80100360 <panic>
80106a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a60:	0f 85 a0 00 00 00    	jne    80106b06 <loaduvm+0xb6>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a66:	8b 75 18             	mov    0x18(%ebp),%esi
80106a69:	31 db                	xor    %ebx,%ebx
80106a6b:	85 f6                	test   %esi,%esi
80106a6d:	75 1a                	jne    80106a89 <loaduvm+0x39>
80106a6f:	eb 7f                	jmp    80106af0 <loaduvm+0xa0>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a87:	76 67                	jbe    80106af0 <loaduvm+0xa0>
80106a89:	8b 45 0c             	mov    0xc(%ebp),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106a93:	00 
80106a94:	01 d8                	add    %ebx,%eax
80106a96:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9d:	89 04 24             	mov    %eax,(%esp)
80106aa0:	e8 1b fc ff ff       	call   801066c0 <walkpgdir>
80106aa5:	85 c0                	test   %eax,%eax
80106aa7:	74 51                	je     80106afa <loaduvm+0xaa>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106aa9:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106aab:	bf 00 10 00 00       	mov    $0x1000,%edi
80106ab0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ab3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106ab8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106abe:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ac1:	05 00 00 00 80       	add    $0x80000000,%eax
80106ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aca:	8b 45 10             	mov    0x10(%ebp),%eax
80106acd:	01 d9                	add    %ebx,%ecx
80106acf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106ad3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106ad7:	89 04 24             	mov    %eax,(%esp)
80106ada:	e8 81 ae ff ff       	call   80101960 <readi>
80106adf:	39 f8                	cmp    %edi,%eax
80106ae1:	74 95                	je     80106a78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106ae3:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106aeb:	5b                   	pop    %ebx
80106aec:	5e                   	pop    %esi
80106aed:	5f                   	pop    %edi
80106aee:	5d                   	pop    %ebp
80106aef:	c3                   	ret    
80106af0:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106af3:	31 c0                	xor    %eax,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106afa:	c7 04 24 2f 82 10 80 	movl   $0x8010822f,(%esp)
80106b01:	e8 5a 98 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106b06:	c7 04 24 dc 82 10 80 	movl   $0x801082dc,(%esp)
80106b0d:	e8 4e 98 ff ff       	call   80100360 <panic>
80106b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 2c             	sub    $0x2c,%esp
80106b29:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz > USEREND)
80106b2c:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
80106b32:	0f 87 98 00 00 00    	ja     80106bd0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
80106b38:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz > USEREND)
    return 0;
  if(newsz < oldsz)
80106b3e:	0f 82 8e 00 00 00    	jb     80106bd2 <allocuvm+0xb2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b44:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b4a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b50:	39 df                	cmp    %ebx,%edi
80106b52:	77 5b                	ja     80106baf <allocuvm+0x8f>
80106b54:	e9 87 00 00 00       	jmp    80106be0 <allocuvm+0xc0>
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b67:	00 
80106b68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b6f:	00 
80106b70:	89 04 24             	mov    %eax,(%esp)
80106b73:	e8 08 d8 ff ff       	call   80104380 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b78:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b82:	8b 45 08             	mov    0x8(%ebp),%eax
80106b85:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106b8c:	00 
80106b8d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b94:	00 
80106b95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b99:	89 04 24             	mov    %eax,(%esp)
80106b9c:	e8 5f fc ff ff       	call   80106800 <mappages>
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	78 4b                	js     80106bf0 <allocuvm+0xd0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ba5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bab:	39 df                	cmp    %ebx,%edi
80106bad:	76 31                	jbe    80106be0 <allocuvm+0xc0>
    mem = kalloc();
80106baf:	e8 ec b8 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106bb4:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106bb6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bb8:	75 a6                	jne    80106b60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bba:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
80106bc1:	e8 8a 9a ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bc6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bc9:	77 55                	ja     80106c20 <allocuvm+0x100>
80106bcb:	90                   	nop
80106bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106bd0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106bd2:	83 c4 2c             	add    $0x2c,%esp
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret    
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106be0:	83 c4 2c             	add    $0x2c,%esp
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80106be3:	89 f8                	mov    %edi,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
80106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106bf0:	c7 04 24 65 82 10 80 	movl   $0x80108265,(%esp)
80106bf7:	e8 54 9a ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bfc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bff:	76 0d                	jbe    80106c0e <allocuvm+0xee>
80106c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c04:	89 fa                	mov    %edi,%edx
80106c06:	8b 45 08             	mov    0x8(%ebp),%eax
80106c09:	e8 42 fb ff ff       	call   80106750 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106c0e:	89 34 24             	mov    %esi,(%esp)
80106c11:	e8 da b6 ff ff       	call   801022f0 <kfree>
      return 0;
    }
  }
  return newsz;
}
80106c16:	83 c4 2c             	add    $0x2c,%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106c19:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106c1b:	5b                   	pop    %ebx
80106c1c:	5e                   	pop    %esi
80106c1d:	5f                   	pop    %edi
80106c1e:	5d                   	pop    %ebp
80106c1f:	c3                   	ret    
80106c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c23:	89 fa                	mov    %edi,%edx
80106c25:	8b 45 08             	mov    0x8(%ebp),%eax
80106c28:	e8 23 fb ff ff       	call   80106750 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c2d:	31 c0                	xor    %eax,%eax
80106c2f:	eb a1                	jmp    80106bd2 <allocuvm+0xb2>
80106c31:	eb 0d                	jmp    80106c40 <allocshm>
80106c33:	90                   	nop
80106c34:	90                   	nop
80106c35:	90                   	nop
80106c36:	90                   	nop
80106c37:	90                   	nop
80106c38:	90                   	nop
80106c39:	90                   	nop
80106c3a:	90                   	nop
80106c3b:	90                   	nop
80106c3c:	90                   	nop
80106c3d:	90                   	nop
80106c3e:	90                   	nop
80106c3f:	90                   	nop

80106c40 <allocshm>:
  return newsz;
}

int
allocshm(pde_t *pgdir, char *frame)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 2c             	sub    $0x2c,%esp
	struct proc *curproc = myproc();
80106c49:	e8 a2 ca ff ff       	call   801036f0 <myproc>
80106c4e:	89 c6                	mov    %eax,%esi
	uint sz = PGROUNDUP(curproc->sz);
80106c50:	8b 00                	mov    (%eax),%eax
80106c52:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106c5e:	8d 8b 00 20 00 00    	lea    0x2000(%ebx),%ecx
80106c64:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106c67:	0f 87 ab 00 00 00    	ja     80106d18 <allocshm+0xd8>
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
80106c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106c77:	00 
80106c78:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c7c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106c7f:	89 04 24             	mov    %eax,(%esp)
80106c82:	e8 39 fa ff ff       	call   801066c0 <walkpgdir>
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106c87:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c8a:	f6 00 01             	testb  $0x1,(%eax)
80106c8d:	0f 84 92 00 00 00    	je     80106d25 <allocshm+0xe5>
80106c93:	3b 4e 7c             	cmp    0x7c(%esi),%ecx
80106c96:	76 15                	jbe    80106cad <allocshm+0x6d>
80106c98:	eb 7e                	jmp    80106d18 <allocshm+0xd8>
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ca0:	81 c3 00 30 00 00    	add    $0x3000,%ebx
80106ca6:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
80106ca9:	72 6d                	jb     80106d18 <allocshm+0xd8>
		sz+=PGSIZE;
80106cab:	89 fb                	mov    %edi,%ebx
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106cad:	8b 45 08             	mov    0x8(%ebp),%eax
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
80106cb0:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
		pte = walkpgdir(pgdir, (void*) sz , 0);
80106cb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106cbd:	00 
80106cbe:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106cc2:	89 04 24             	mov    %eax,(%esp)
80106cc5:	e8 f6 f9 ff ff       	call   801066c0 <walkpgdir>
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
  if(sz + 2*PGSIZE > curproc->tstack) return -1;
	pte_t *pte;
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
80106cca:	f6 00 01             	testb  $0x1,(%eax)
80106ccd:	75 d1                	jne    80106ca0 <allocshm+0x60>
80106ccf:	8d 8b 00 30 00 00    	lea    0x3000(%ebx),%ecx
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106cd5:	39 4e 7c             	cmp    %ecx,0x7c(%esi)
80106cd8:	72 3e                	jb     80106d18 <allocshm+0xd8>
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
80106cda:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cdd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106ce4:	00 
80106ce5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cec:	00 
80106ced:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106cf1:	05 00 00 00 80       	add    $0x80000000,%eax
80106cf6:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80106cfd:	89 04 24             	mov    %eax,(%esp)
80106d00:	e8 fb fa ff ff       	call   80106800 <mappages>
80106d05:	85 c0                	test   %eax,%eax
80106d07:	78 20                	js     80106d29 <allocshm+0xe9>
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106d09:	83 c4 2c             	add    $0x2c,%esp
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
80106d0c:	89 f8                	mov    %edi,%eax
}
80106d0e:	5b                   	pop    %ebx
80106d0f:	5e                   	pop    %esi
80106d10:	5f                   	pop    %edi
80106d11:	5d                   	pop    %ebp
80106d12:	c3                   	ret    
80106d13:	90                   	nop
80106d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	pte = walkpgdir(pgdir, (void*) sz , 0);
	while((*pte & PTE_P) && (sz + 2*PGSIZE <= curproc->tstack)){
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
80106d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
		return -1;
	}
	return sz;
}
80106d1d:	83 c4 2c             	add    $0x2c,%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
80106d24:	c3                   	ret    

int
allocshm(pde_t *pgdir, char *frame)
{
	struct proc *curproc = myproc();
	uint sz = PGROUNDUP(curproc->sz);
80106d25:	89 df                	mov    %ebx,%edi
80106d27:	eb ac                	jmp    80106cd5 <allocshm+0x95>
		sz+=PGSIZE;
		pte = walkpgdir(pgdir, (void*) sz , 0);
	}
	if(sz + 2*PGSIZE > curproc->tstack) return -1;
	if(mappages(pgdir, (void*) sz , PGSIZE, V2P(frame), PTE_W|PTE_U) < 0){
		cprintf("allocuvm out of memory\n");
80106d29:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
80106d30:	e8 1b 99 ff ff       	call   80100650 <cprintf>
		return -1;
80106d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d3a:	eb e1                	jmp    80106d1d <allocshm+0xdd>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d49:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d4c:	39 d1                	cmp    %edx,%ecx
80106d4e:	73 08                	jae    80106d58 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d50:	5d                   	pop    %ebp
80106d51:	e9 fa f9 ff ff       	jmp    80106750 <deallocuvm.part.0>
80106d56:	66 90                	xchg   %ax,%ax
80106d58:	89 d0                	mov    %edx,%eax
80106d5a:	5d                   	pop    %ebp
80106d5b:	c3                   	ret    
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	56                   	push   %esi
80106d64:	53                   	push   %ebx
80106d65:	83 ec 10             	sub    $0x10,%esp
80106d68:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d6b:	85 f6                	test   %esi,%esi
80106d6d:	74 59                	je     80106dc8 <freevm+0x68>
80106d6f:	31 c9                	xor    %ecx,%ecx
80106d71:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d76:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d78:	31 db                	xor    %ebx,%ebx
80106d7a:	e8 d1 f9 ff ff       	call   80106750 <deallocuvm.part.0>
80106d7f:	eb 12                	jmp    80106d93 <freevm+0x33>
80106d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d88:	83 c3 01             	add    $0x1,%ebx
80106d8b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106d91:	74 27                	je     80106dba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d93:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106d96:	f6 c2 01             	test   $0x1,%dl
80106d99:	74 ed                	je     80106d88 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d9b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106da1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106da4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106daa:	89 14 24             	mov    %edx,(%esp)
80106dad:	e8 3e b5 ff ff       	call   801022f0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USEREND, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106db2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106db8:	75 d9                	jne    80106d93 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106dba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106dbd:	83 c4 10             	add    $0x10,%esp
80106dc0:	5b                   	pop    %ebx
80106dc1:	5e                   	pop    %esi
80106dc2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106dc3:	e9 28 b5 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106dc8:	c7 04 24 81 82 10 80 	movl   $0x80108281,(%esp)
80106dcf:	e8 8c 95 ff ff       	call   80100360 <panic>
80106dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106de0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	56                   	push   %esi
80106de4:	53                   	push   %ebx
80106de5:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106de8:	e8 b3 b6 ff ff       	call   801024a0 <kalloc>
80106ded:	85 c0                	test   %eax,%eax
80106def:	89 c6                	mov    %eax,%esi
80106df1:	74 75                	je     80106e68 <setupkvm+0x88>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106df3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106dfa:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dfb:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106e00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e07:	00 
80106e08:	89 04 24             	mov    %eax,(%esp)
80106e0b:	e8 70 d5 ff ff       	call   80104380 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e10:	8b 53 0c             	mov    0xc(%ebx),%edx
80106e13:	8b 43 04             	mov    0x4(%ebx),%eax
80106e16:	89 34 24             	mov    %esi,(%esp)
80106e19:	89 54 24 10          	mov    %edx,0x10(%esp)
80106e1d:	8b 53 08             	mov    0x8(%ebx),%edx
80106e20:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106e24:	29 c2                	sub    %eax,%edx
80106e26:	8b 03                	mov    (%ebx),%eax
80106e28:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e30:	e8 cb f9 ff ff       	call   80106800 <mappages>
80106e35:	85 c0                	test   %eax,%eax
80106e37:	78 17                	js     80106e50 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e39:	83 c3 10             	add    $0x10,%ebx
80106e3c:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106e42:	72 cc                	jb     80106e10 <setupkvm+0x30>
80106e44:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106e46:	83 c4 20             	add    $0x20,%esp
80106e49:	5b                   	pop    %ebx
80106e4a:	5e                   	pop    %esi
80106e4b:	5d                   	pop    %ebp
80106e4c:	c3                   	ret    
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e50:	89 34 24             	mov    %esi,(%esp)
80106e53:	e8 08 ff ff ff       	call   80106d60 <freevm>
      return 0;
    }
  return pgdir;
}
80106e58:	83 c4 20             	add    $0x20,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e5b:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106e5d:	5b                   	pop    %ebx
80106e5e:	5e                   	pop    %esi
80106e5f:	5d                   	pop    %ebp
80106e60:	c3                   	ret    
80106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106e68:	31 c0                	xor    %eax,%eax
80106e6a:	eb da                	jmp    80106e46 <setupkvm+0x66>
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e70 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e76:	e8 65 ff ff ff       	call   80106de0 <setupkvm>
80106e7b:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e80:	05 00 00 00 80       	add    $0x80000000,%eax
80106e85:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106e88:	c9                   	leave  
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ea0:	00 
80106ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea8:	89 04 24             	mov    %eax,(%esp)
80106eab:	e8 10 f8 ff ff       	call   801066c0 <walkpgdir>
  if(pte == 0)
80106eb0:	85 c0                	test   %eax,%eax
80106eb2:	74 05                	je     80106eb9 <clearpteu+0x29>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106eb4:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eb7:	c9                   	leave  
80106eb8:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106eb9:	c7 04 24 92 82 10 80 	movl   $0x80108292,(%esp)
80106ec0:	e8 9b 94 ff ff       	call   80100360 <panic>
80106ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <resetpteu>:
  *pte &= ~PTE_U;
}

void
resetpteu(pde_t *pgdir, char *uva)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80106ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ed9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ee0:	00 
80106ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee8:	89 04 24             	mov    %eax,(%esp)
80106eeb:	e8 d0 f7 ff ff       	call   801066c0 <walkpgdir>
  if(pte == 0)
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	74 05                	je     80106ef9 <resetpteu+0x29>
    panic("resetpteu");
  *pte &= PTE_U;
80106ef4:	83 20 04             	andl   $0x4,(%eax)
}
80106ef7:	c9                   	leave  
80106ef8:	c3                   	ret    
resetpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("resetpteu");
80106ef9:	c7 04 24 9c 82 10 80 	movl   $0x8010829c,(%esp)
80106f00:	e8 5b 94 ff ff       	call   80100360 <panic>
80106f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f10 <copyuvm>:
}
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint tstack)// FOR CS153 lab2 part1
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f19:	e8 c2 fe ff ff       	call   80106de0 <setupkvm>
80106f1e:	85 c0                	test   %eax,%eax
80106f20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f23:	0f 84 7a 01 00 00    	je     801070a3 <copyuvm+0x193>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f29:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2c:	85 d2                	test   %edx,%edx
80106f2e:	0f 84 bc 00 00 00    	je     80106ff0 <copyuvm+0xe0>
80106f34:	31 db                	xor    %ebx,%ebx
80106f36:	eb 51                	jmp    80106f89 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f38:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f45:	00 
80106f46:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106f4a:	89 04 24             	mov    %eax,(%esp)
80106f4d:	e8 ce d4 ff ff       	call   80104420 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f55:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106f5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106f5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f66:	00 
80106f67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106f6b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f72:	89 04 24             	mov    %eax,(%esp)
80106f75:	e8 86 f8 ff ff       	call   80106800 <mappages>
80106f7a:	85 c0                	test   %eax,%eax
80106f7c:	78 58                	js     80106fd6 <copyuvm+0xc6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f7e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f84:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106f87:	76 67                	jbe    80106ff0 <copyuvm+0xe0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f89:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106f93:	00 
80106f94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106f98:	89 04 24             	mov    %eax,(%esp)
80106f9b:	e8 20 f7 ff ff       	call   801066c0 <walkpgdir>
80106fa0:	85 c0                	test   %eax,%eax
80106fa2:	0f 84 0e 01 00 00    	je     801070b6 <copyuvm+0x1a6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106fa8:	8b 30                	mov    (%eax),%esi
80106faa:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106fb0:	0f 84 f4 00 00 00    	je     801070aa <copyuvm+0x19a>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fb6:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106fb8:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106fbe:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fc1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106fc7:	e8 d4 b4 ff ff       	call   801024a0 <kalloc>
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	89 c6                	mov    %eax,%esi
80106fd0:	0f 85 62 ff ff ff    	jne    80106f38 <copyuvm+0x28>
      goto bad;
		}
  return d;

bad:
  freevm(d);
80106fd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fd9:	89 04 24             	mov    %eax,(%esp)
80106fdc:	e8 7f fd ff ff       	call   80106d60 <freevm>
  return 0;
80106fe1:	31 c0                	xor    %eax,%eax
}
80106fe3:	83 c4 2c             	add    $0x2c,%esp
80106fe6:	5b                   	pop    %ebx
80106fe7:	5e                   	pop    %esi
80106fe8:	5f                   	pop    %edi
80106fe9:	5d                   	pop    %ebp
80106fea:	c3                   	ret    
80106feb:	90                   	nop
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (tstack == 0 || tstack >= USEREND) return d; // For CS153 lab2 part1
80106ff0:	8b 45 10             	mov    0x10(%ebp),%eax
80106ff3:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106ff6:	85 c0                	test   %eax,%eax
80106ff8:	7f 54                	jg     8010704e <copyuvm+0x13e>
80106ffa:	e9 99 00 00 00       	jmp    80107098 <copyuvm+0x188>
80106fff:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107000:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107006:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010700d:	00 
8010700e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80107012:	89 04 24             	mov    %eax,(%esp)
80107015:	e8 06 d4 ff ff       	call   80104420 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010701a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010701d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80107023:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107027:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010702e:	00 
8010702f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80107033:	89 44 24 10          	mov    %eax,0x10(%esp)
80107037:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010703a:	89 04 24             	mov    %eax,(%esp)
8010703d:	e8 be f7 ff ff       	call   80106800 <mappages>
80107042:	85 c0                	test   %eax,%eax
80107044:	78 90                	js     80106fd6 <copyuvm+0xc6>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
	//copy the stack
  if (tstack == 0 || tstack >= USEREND) return d; // For CS153 lab2 part1
  for(i = tstack; i < USEREND; i += PGSIZE){
80107046:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010704c:	78 4a                	js     80107098 <copyuvm+0x188>
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
8010704e:	8b 45 08             	mov    0x8(%ebp),%eax
80107051:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107058:	00 
80107059:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010705d:	89 04 24             	mov    %eax,(%esp)
80107060:	e8 5b f6 ff ff       	call   801066c0 <walkpgdir>
80107065:	85 c0                	test   %eax,%eax
80107067:	74 4d                	je     801070b6 <copyuvm+0x1a6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107069:	8b 30                	mov    (%eax),%esi
8010706b:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107071:	74 37                	je     801070aa <copyuvm+0x19a>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107073:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80107075:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
8010707b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = tstack; i < USEREND; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 1)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010707e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80107084:	e8 17 b4 ff ff       	call   801024a0 <kalloc>
80107089:	85 c0                	test   %eax,%eax
8010708b:	89 c6                	mov    %eax,%esi
8010708d:	0f 85 6d ff ff ff    	jne    80107000 <copyuvm+0xf0>
80107093:	e9 3e ff ff ff       	jmp    80106fd6 <copyuvm+0xc6>
80107098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
8010709b:	83 c4 2c             	add    $0x2c,%esp
8010709e:	5b                   	pop    %ebx
8010709f:	5e                   	pop    %esi
801070a0:	5f                   	pop    %edi
801070a1:	5d                   	pop    %ebp
801070a2:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801070a3:	31 c0                	xor    %eax,%eax
801070a5:	e9 39 ff ff ff       	jmp    80106fe3 <copyuvm+0xd3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801070aa:	c7 04 24 c0 82 10 80 	movl   $0x801082c0,(%esp)
801070b1:	e8 aa 92 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070b6:	c7 04 24 a6 82 10 80 	movl   $0x801082a6,(%esp)
801070bd:	e8 9e 92 ff ff       	call   80100360 <panic>
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801070d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801070e0:	00 
801070e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801070e5:	8b 45 08             	mov    0x8(%ebp),%eax
801070e8:	89 04 24             	mov    %eax,(%esp)
801070eb:	e8 d0 f5 ff ff       	call   801066c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801070f0:	8b 00                	mov    (%eax),%eax
801070f2:	89 c2                	mov    %eax,%edx
801070f4:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
801070f7:	83 fa 05             	cmp    $0x5,%edx
801070fa:	75 0c                	jne    80107108 <uva2ka+0x38>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801070fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107101:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107106:	c9                   	leave  
80107107:	c3                   	ret    

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107108:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
8010710a:	c9                   	leave  
8010710b:	c3                   	ret    
8010710c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107110 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 1c             	sub    $0x1c,%esp
80107119:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010711c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010711f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107122:	85 db                	test   %ebx,%ebx
80107124:	75 3a                	jne    80107160 <copyout+0x50>
80107126:	eb 68                	jmp    80107190 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107128:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010712b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010712d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107131:	29 ca                	sub    %ecx,%edx
80107133:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107139:	39 da                	cmp    %ebx,%edx
8010713b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010713e:	29 f1                	sub    %esi,%ecx
80107140:	01 c8                	add    %ecx,%eax
80107142:	89 54 24 08          	mov    %edx,0x8(%esp)
80107146:	89 04 24             	mov    %eax,(%esp)
80107149:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010714c:	e8 cf d2 ff ff       	call   80104420 <memmove>
    len -= n;
    buf += n;
80107151:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107154:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010715a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010715c:	29 d3                	sub    %edx,%ebx
8010715e:	74 30                	je     80107190 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107160:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107163:	89 ce                	mov    %ecx,%esi
80107165:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010716b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010716f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107172:	89 04 24             	mov    %eax,(%esp)
80107175:	e8 56 ff ff ff       	call   801070d0 <uva2ka>
    if(pa0 == 0)
8010717a:	85 c0                	test   %eax,%eax
8010717c:	75 aa                	jne    80107128 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010717e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107186:	5b                   	pop    %ebx
80107187:	5e                   	pop    %esi
80107188:	5f                   	pop    %edi
80107189:	5d                   	pop    %ebp
8010718a:	c3                   	ret    
8010718b:	90                   	nop
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107190:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <addstackpage>:
int // For CS153 lab2 part1 
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
801071ac:	e8 3f c5 ff ff       	call   801036f0 <myproc>
801071b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i=0;i<rep;i++){
801071b4:	8b 45 10             	mov    0x10(%ebp),%eax
801071b7:	85 c0                	test   %eax,%eax
801071b9:	74 56                	je     80107211 <addstackpage+0x71>
801071bb:	31 f6                	xor    %esi,%esi
801071bd:	eb 27                	jmp    801071e6 <addstackpage+0x46>
801071bf:	90                   	nop
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
801071c0:	f6 00 01             	testb  $0x1,(%eax)
801071c3:	75 42                	jne    80107207 <addstackpage+0x67>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
801071c5:	8b 45 08             	mov    0x8(%ebp),%eax
801071c8:	89 7c 24 08          	mov    %edi,0x8(%esp)
801071cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801071d0:	89 04 24             	mov    %eax,(%esp)
801071d3:	e8 48 f9 ff ff       	call   80106b20 <allocuvm>
801071d8:	85 c0                	test   %eax,%eax
801071da:	74 2b                	je     80107207 <addstackpage+0x67>
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
801071dc:	83 c6 01             	add    $0x1,%esi
801071df:	3b 75 10             	cmp    0x10(%ebp),%esi
801071e2:	74 34                	je     80107218 <addstackpage+0x78>
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
801071e4:	89 df                	mov    %ebx,%edi
801071e6:	8b 45 08             	mov    0x8(%ebp),%eax
801071e9:	8d 9f 00 f0 ff ff    	lea    -0x1000(%edi),%ebx
801071ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801071f6:	00 
801071f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801071fb:	89 04 24             	mov    %eax,(%esp)
801071fe:	e8 bd f4 ff ff       	call   801066c0 <walkpgdir>
80107203:	85 c0                	test   %eax,%eax
80107205:	75 b9                	jne    801071c0 <addstackpage+0x20>
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
80107207:	83 c4 1c             	add    $0x1c,%esp
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
8010720a:	31 c0                	xor    %eax,%eax
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
}
8010720c:	5b                   	pop    %ebx
8010720d:	5e                   	pop    %esi
8010720e:	5f                   	pop    %edi
8010720f:	5d                   	pop    %ebp
80107210:	c3                   	ret    
addstackpage(pde_t *pgdir, uint tstack, uint rep)
{
  pte_t *pte;
	int i;
	struct proc *curproc = myproc();
  for(i=0;i<rep;i++){
80107211:	89 fb                	mov    %edi,%ebx
80107213:	90                   	nop
80107214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
80107218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010721b:	89 58 7c             	mov    %ebx,0x7c(%eax)
  return 1;
}
8010721e:	83 c4 1c             	add    $0x1c,%esp
  	if((pte = walkpgdir(pgdir, (void *) (tstack-PGSIZE), 1)) == 0 || *pte & PTE_P) return 0;
  	if(allocuvm(pgdir, tstack-PGSIZE, tstack) == 0) return 0;
		tstack-=PGSIZE;
	}
  curproc->tstack = tstack;
  return 1;
80107221:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107226:	5b                   	pop    %ebx
80107227:	5e                   	pop    %esi
80107228:	5f                   	pop    %edi
80107229:	5d                   	pop    %ebp
8010722a:	c3                   	ret    
8010722b:	66 90                	xchg   %ax,%ax
8010722d:	66 90                	xchg   %ax,%ax
8010722f:	90                   	nop

80107230 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107236:	c7 44 24 04 ff 82 10 	movl   $0x801082ff,0x4(%esp)
8010723d:	80 
8010723e:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107245:	e8 06 cf ff ff       	call   80104150 <initlock>
  acquire(&(shm_table.lock));
8010724a:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107251:	e8 ea cf ff ff       	call   80104240 <acquire>
80107256:	b8 f4 6d 11 80       	mov    $0x80116df4,%eax
8010725b:	90                   	nop
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80107260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107266:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80107269:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80107270:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80107277:	3d f4 70 11 80       	cmp    $0x801170f4,%eax
8010727c:	75 e2                	jne    80107260 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
8010727e:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107285:	e8 a6 d0 ff ff       	call   80104330 <release>
}
8010728a:	c9                   	leave  
8010728b:	c3                   	ret    
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <shm_create>:

int shm_create(int table_id) {
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 2c             	sub    $0x2c,%esp
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
80107299:	e8 52 c4 ff ff       	call   801036f0 <myproc>
	if(table_id < 0 || table_id >= 64){
8010729e:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
}

int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
801072a2:	89 c7                	mov    %eax,%edi
	if(table_id < 0 || table_id >= 64){
801072a4:	0f 87 f1 00 00 00    	ja     8010739b <shm_create+0x10b>
801072aa:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
801072ac:	8b b4 df 80 00 00 00 	mov    0x80(%edi,%ebx,8),%esi
801072b3:	83 fe ff             	cmp    $0xffffffff,%esi
801072b6:	74 30                	je     801072e8 <shm_create+0x58>
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
801072b8:	83 c3 01             	add    $0x1,%ebx
801072bb:	83 fb 04             	cmp    $0x4,%ebx
801072be:	75 ec                	jne    801072ac <shm_create+0x1c>
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
801072c0:	8b 47 10             	mov    0x10(%edi),%eax
		return -1;
801072c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
801072c8:	c7 04 24 3a 83 10 80 	movl   $0x8010833a,(%esp)
801072cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801072d3:	e8 78 93 ff ff       	call   80100650 <cprintf>
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
801072d8:	83 c4 2c             	add    $0x2c,%esp
801072db:	89 f0                	mov    %esi,%eax
801072dd:	5b                   	pop    %ebx
801072de:	5e                   	pop    %esi
801072df:	5f                   	pop    %edi
801072e0:	5d                   	pop    %ebp
801072e1:	c3                   	ret    
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
801072e8:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801072ef:	e8 4c cf ff ff       	call   80104240 <acquire>
	if(shm_table.shm_pages[table_id].refcnt != 0){
801072f4:	8b 45 08             	mov    0x8(%ebp),%eax
801072f7:	8d 04 40             	lea    (%eax,%eax,2),%eax
801072fa:	8d 14 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edx
80107301:	8b 42 0c             	mov    0xc(%edx),%eax
80107304:	85 c0                	test   %eax,%eax
80107306:	75 68                	jne    80107370 <shm_create+0xe0>
80107308:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
8010730b:	e8 90 b1 ff ff       	call   801024a0 <kalloc>
80107310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107313:	85 c0                	test   %eax,%eax
80107315:	89 c1                	mov    %eax,%ecx
80107317:	0f 84 9b 00 00 00    	je     801073b8 <shm_create+0x128>
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
8010731d:	8b 45 08             	mov    0x8(%ebp),%eax
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
80107320:	89 de                	mov    %ebx,%esi
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
	shm_table.shm_pages[table_id].refcnt++;
80107322:	83 42 0c 01          	addl   $0x1,0xc(%edx)
80107326:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
80107329:	89 42 04             	mov    %eax,0x4(%edx)
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
8010732c:	89 0c 24             	mov    %ecx,(%esp)
8010732f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107336:	00 
80107337:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010733e:	00 
8010733f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107342:	e8 39 d0 ff ff       	call   80104380 <memset>
	shm_table.shm_pages[table_id].frame = memory;
80107347:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010734a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010734d:	89 4a 08             	mov    %ecx,0x8(%edx)
	release(&(shm_table.lock));
80107350:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107357:	e8 d4 cf ff ff       	call   80104330 <release>
	curproc->pages[page_id].id = table_id;
8010735c:	8b 45 08             	mov    0x8(%ebp),%eax
8010735f:	89 84 df 80 00 00 00 	mov    %eax,0x80(%edi,%ebx,8)
	return page_id;
}
80107366:	83 c4 2c             	add    $0x2c,%esp
80107369:	89 f0                	mov    %esi,%eax
8010736b:	5b                   	pop    %ebx
8010736c:	5e                   	pop    %esi
8010736d:	5f                   	pop    %edi
8010736e:	5d                   	pop    %ebp
8010736f:	c3                   	ret    
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[table_id].refcnt != 0){
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
80107370:	8b 45 08             	mov    0x8(%ebp),%eax
80107373:	89 44 24 08          	mov    %eax,0x8(%esp)
80107377:	8b 47 10             	mov    0x10(%edi),%eax
8010737a:	c7 04 24 80 83 10 80 	movl   $0x80108380,(%esp)
80107381:	89 44 24 04          	mov    %eax,0x4(%esp)
80107385:	e8 c6 92 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010738a:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107391:	e8 9a cf ff ff       	call   80104330 <release>
		return -1;
80107396:	e9 3d ff ff ff       	jmp    801072d8 <shm_create+0x48>
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
8010739b:	8b 40 10             	mov    0x10(%eax),%eax
		return -1;
8010739e:	be ff ff ff ff       	mov    $0xffffffff,%esi
int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
801073a3:	c7 04 24 08 83 10 80 	movl   $0x80108308,(%esp)
801073aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801073ae:	e8 9d 92 ff ff       	call   80100650 <cprintf>
		return -1;
801073b3:	e9 20 ff ff ff       	jmp    801072d8 <shm_create+0x48>
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
801073b8:	8b 47 10             	mov    0x10(%edi),%eax
801073bb:	c7 04 24 1e 83 10 80 	movl   $0x8010831e,(%esp)
801073c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801073c6:	e8 85 92 ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
801073cb:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801073d2:	e8 59 cf ff ff       	call   80104330 <release>
		return -1;
801073d7:	e9 fc fe ff ff       	jmp    801072d8 <shm_create+0x48>
801073dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073e0 <shm_open>:
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
int shm_open(int id, char **pointer) {
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
801073e9:	8b 75 08             	mov    0x8(%ebp),%esi
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
801073ec:	e8 ff c2 ff ff       	call   801036f0 <myproc>
	if(id < 0 || id >= 64){
801073f1:	83 fe 3f             	cmp    $0x3f,%esi
	return page_id;
}
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
801073f4:	89 c7                	mov    %eax,%edi
	if(id < 0 || id >= 64){
801073f6:	0f 87 0c 01 00 00    	ja     80107508 <shm_open+0x128>
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
801073fc:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
	if (shm_table.shm_pages[id].refcnt == 0){
80107403:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
80107405:	e8 36 ce ff ff       	call   80104240 <acquire>
	if (shm_table.shm_pages[id].refcnt == 0){
8010740a:	8d 04 76             	lea    (%esi,%esi,2),%eax
8010740d:	8b 14 85 fc 6d 11 80 	mov    -0x7fee9204(,%eax,4),%edx
80107414:	85 d2                	test   %edx,%edx
80107416:	74 58                	je     80107470 <shm_open+0x90>
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
80107418:	39 b4 df 80 00 00 00 	cmp    %esi,0x80(%edi,%ebx,8)
8010741f:	0f 84 8d 00 00 00    	je     801074b2 <shm_open+0xd2>
			return -1;
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
80107425:	83 c3 01             	add    $0x1,%ebx
80107428:	83 fb 04             	cmp    $0x4,%ebx
8010742b:	75 eb                	jne    80107418 <shm_open+0x38>
8010742d:	30 db                	xor    %bl,%bl
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
				if(curproc->pages[page_id].id == -1) break;
8010742f:	83 bc df 80 00 00 00 	cmpl   $0xffffffff,0x80(%edi,%ebx,8)
80107436:	ff 
80107437:	0f 84 e5 00 00 00    	je     80107522 <shm_open+0x142>
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
8010743d:	83 c3 01             	add    $0x1,%ebx
80107440:	83 fb 04             	cmp    $0x4,%ebx
80107443:	75 ea                	jne    8010742f <shm_open+0x4f>
				if(curproc->pages[page_id].id == -1) break;
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
80107445:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010744c:	e8 df ce ff ff       	call   80104330 <release>
      	cprintf("Proc: %d, process is full\n",curproc->pid);
80107451:	8b 47 10             	mov    0x10(%edi),%eax
80107454:	c7 04 24 3a 83 10 80 	movl   $0x8010833a,(%esp)
8010745b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010745f:	e8 ec 91 ff ff       	call   80100650 <cprintf>
				return -1; 
80107464:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107469:	eb 6d                	jmp    801074d8 <shm_open+0xf8>
8010746b:	90                   	nop
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
80107470:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107477:	e8 b4 ce ff ff       	call   80104330 <release>
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
8010747c:	89 74 24 08          	mov    %esi,0x8(%esp)
80107480:	8b 47 10             	mov    0x10(%edi),%eax
80107483:	c7 04 24 a0 83 10 80 	movl   $0x801083a0,(%esp)
8010748a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010748e:	e8 bd 91 ff ff       	call   80100650 <cprintf>
		if((page_id = shm_create(id))==-1){
80107493:	89 34 24             	mov    %esi,(%esp)
80107496:	e8 f5 fd ff ff       	call   80107290 <shm_create>
8010749b:	83 f8 ff             	cmp    $0xffffffff,%eax
8010749e:	89 c3                	mov    %eax,%ebx
801074a0:	0f 84 9f 00 00 00    	je     80107545 <shm_open+0x165>
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
			return -1;
		}
		acquire(&(shm_table.lock));
801074a6:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801074ad:	e8 8e cd ff ff       	call   80104240 <acquire>
801074b2:	8d 1c df             	lea    (%edi,%ebx,8),%ebx
			curproc->pages[page_id].id = id;
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
801074b5:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801074bb:	85 c0                	test   %eax,%eax
801074bd:	74 21                	je     801074e0 <shm_open+0x100>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
  }
	release(&(shm_table.lock));
801074bf:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801074c6:	e8 65 ce ff ff       	call   80104330 <release>
	*pointer = curproc->pages[page_id].vaddr;
801074cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801074ce:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801074d4:	89 10                	mov    %edx,(%eax)
	return 0;
801074d6:	31 c0                	xor    %eax,%eax
}
801074d8:	83 c4 1c             	add    $0x1c,%esp
801074db:	5b                   	pop    %ebx
801074dc:	5e                   	pop    %esi
801074dd:	5f                   	pop    %edi
801074de:	5d                   	pop    %ebp
801074df:	c3                   	ret    
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
801074e0:	8d 04 76             	lea    (%esi,%esi,2),%eax
801074e3:	8b 04 85 f8 6d 11 80 	mov    -0x7fee9208(,%eax,4),%eax
801074ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801074ee:	8b 47 04             	mov    0x4(%edi),%eax
801074f1:	89 04 24             	mov    %eax,(%esp)
801074f4:	e8 47 f7 ff ff       	call   80106c40 <allocshm>
801074f9:	83 f8 ff             	cmp    $0xffffffff,%eax
801074fc:	74 68                	je     80107566 <shm_open+0x186>
			release(&(shm_table.lock));
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
801074fe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80107504:	eb b9                	jmp    801074bf <shm_open+0xdf>
80107506:	66 90                	xchg   %ax,%ax
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
80107508:	8b 40 10             	mov    0x10(%eax),%eax
8010750b:	c7 04 24 08 83 10 80 	movl   $0x80108308,(%esp)
80107512:	89 44 24 04          	mov    %eax,0x4(%esp)
80107516:	e8 35 91 ff ff       	call   80100650 <cprintf>
		return -1;
8010751b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107520:	eb b6                	jmp    801074d8 <shm_open+0xf8>
80107522:	8d 04 df             	lea    (%edi,%ebx,8),%eax
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
      	cprintf("Proc: %d, process is full\n",curproc->pid);
				return -1; 
    	}
			curproc->pages[page_id].id = id;
80107525:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
			curproc->pages[page_id].vaddr = 0;
8010752b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80107532:	00 00 00 
			shm_table.shm_pages[id].refcnt++;
80107535:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107538:	83 04 85 fc 6d 11 80 	addl   $0x1,-0x7fee9204(,%eax,4)
8010753f:	01 
80107540:	e9 6d ff ff ff       	jmp    801074b2 <shm_open+0xd2>
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
		if((page_id = shm_create(id))==-1){
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
80107545:	89 74 24 08          	mov    %esi,0x8(%esp)
80107549:	8b 47 10             	mov    0x10(%edi),%eax
8010754c:	c7 04 24 c0 83 10 80 	movl   $0x801083c0,(%esp)
80107553:	89 44 24 04          	mov    %eax,0x4(%esp)
80107557:	e8 f4 90 ff ff       	call   80100650 <cprintf>
			return -1;
8010755c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107561:	e9 72 ff ff ff       	jmp    801074d8 <shm_open+0xf8>
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
			release(&(shm_table.lock));
80107566:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010756d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107570:	e8 bb cd ff ff       	call   80104330 <release>
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
80107575:	8b 57 10             	mov    0x10(%edi),%edx
80107578:	c7 04 24 55 83 10 80 	movl   $0x80108355,(%esp)
8010757f:	89 54 24 04          	mov    %edx,0x4(%esp)
80107583:	e8 c8 90 ff ff       	call   80100650 <cprintf>
			return -1;
80107588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010758b:	e9 48 ff ff ff       	jmp    801074d8 <shm_open+0xf8>

80107590 <shm_close>:
	*pointer = curproc->pages[page_id].vaddr;
	return 0;
}


int shm_close(int id) {
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	53                   	push   %ebx
80107596:	83 ec 1c             	sub    $0x1c,%esp
80107599:	8b 7d 08             	mov    0x8(%ebp),%edi
	cprintf("****************");
8010759c:	c7 04 24 6f 83 10 80 	movl   $0x8010836f,(%esp)
801075a3:	e8 a8 90 ff ff       	call   80100650 <cprintf>
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801075a8:	e8 43 c1 ff ff       	call   801036f0 <myproc>
	if(id < 0 || id >= 64){
801075ad:	83 ff 3f             	cmp    $0x3f,%edi

int shm_close(int id) {
	cprintf("****************");
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
801075b0:	89 c6                	mov    %eax,%esi
	if(id < 0 || id >= 64){
801075b2:	0f 87 76 01 00 00    	ja     8010772e <shm_close+0x19e>
801075b8:	31 db                	xor    %ebx,%ebx
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == id) break;
801075ba:	39 bc de 80 00 00 00 	cmp    %edi,0x80(%esi,%ebx,8)
801075c1:	74 2d                	je     801075f0 <shm_close+0x60>
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
801075c3:	83 c3 01             	add    $0x1,%ebx
801075c6:	83 fb 04             	cmp    $0x4,%ebx
801075c9:	75 ef                	jne    801075ba <shm_close+0x2a>
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
801075cb:	8b 46 10             	mov    0x10(%esi),%eax
801075ce:	c7 04 24 44 84 10 80 	movl   $0x80108444,(%esp)
801075d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801075d9:	e8 72 90 ff ff       	call   80100650 <cprintf>
		return -1;
801075de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	*pte = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 0;
}
801075e3:	83 c4 1c             	add    $0x1c,%esp
801075e6:	5b                   	pop    %ebx
801075e7:	5e                   	pop    %esi
801075e8:	5f                   	pop    %edi
801075e9:	5d                   	pop    %ebp
801075ea:	c3                   	ret    
801075eb:	90                   	nop
801075ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
801075f0:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801075f7:	e8 44 cc ff ff       	call   80104240 <acquire>
	if(shm_table.shm_pages[id].refcnt <= 0){
801075fc:	8d 04 7f             	lea    (%edi,%edi,2),%eax
801075ff:	8d 3c 85 f0 6d 11 80 	lea    -0x7fee9210(,%eax,4),%edi
80107606:	8b 47 0c             	mov    0xc(%edi),%eax
80107609:	85 c0                	test   %eax,%eax
8010760b:	0f 8e cb 00 00 00    	jle    801076dc <shm_close+0x14c>
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
8010762c:	e8 8f f0 ff ff       	call   801066c0 <walkpgdir>
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
80107635:	0f 84 cd 00 00 00    	je     80107708 <shm_close+0x178>
		cprintf("Proc: %d, free memory error 1\n",curproc->pid);
		release(&(shm_table.lock));
		return 0;
	}
	if(shm_table.shm_pages[id].refcnt == 0){
8010763b:	8b 47 0c             	mov    0xc(%edi),%eax
8010763e:	85 c0                	test   %eax,%eax
80107640:	75 2f                	jne    80107671 <shm_close+0xe1>
		shm_table.shm_pages[id].id =0;
80107642:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
		if((*pte & PTE_P) == 0){
80107649:	8b 0a                	mov    (%edx),%ecx
8010764b:	f6 c1 01             	test   $0x1,%cl
8010764e:	74 58                	je     801076a8 <shm_close+0x118>
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
80107662:	e8 89 ac ff ff       	call   801022f0 <kfree>
		shm_table.shm_pages[id].frame =0;
80107667:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010766a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
	}
	*pte = 0;
80107671:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	release(&(shm_table.lock));
80107677:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
8010767e:	e8 ad cc ff ff       	call   80104330 <release>
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
801076ab:	c7 04 24 24 84 10 80 	movl   $0x80108424,(%esp)
801076b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801076b9:	e8 92 8f ff ff       	call   80100650 <cprintf>
			shm_table.shm_pages[id].frame =0;
801076be:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
			release(&(shm_table.lock));
801076c5:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
801076cc:	e8 5f cc ff ff       	call   80104330 <release>
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
801076e3:	e8 48 cc ff ff       	call   80104330 <release>
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
801076e8:	8b 46 10             	mov    0x10(%esi),%eax
801076eb:	c7 04 24 e4 83 10 80 	movl   $0x801083e4,(%esp)
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
8010770b:	c7 04 24 04 84 10 80 	movl   $0x80108404,(%esp)
80107712:	89 44 24 04          	mov    %eax,0x4(%esp)
80107716:	e8 35 8f ff ff       	call   80100650 <cprintf>
		release(&(shm_table.lock));
8010771b:	c7 04 24 c0 6d 11 80 	movl   $0x80116dc0,(%esp)
80107722:	e8 09 cc ff ff       	call   80104330 <release>
		return 0;
80107727:	31 c0                	xor    %eax,%eax
80107729:	e9 b5 fe ff ff       	jmp    801075e3 <shm_close+0x53>
	cprintf("****************");
	int page_id;
	pte_t *pte;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
8010772e:	8b 40 10             	mov    0x10(%eax),%eax
80107731:	c7 04 24 08 83 10 80 	movl   $0x80108308,(%esp)
80107738:	89 44 24 04          	mov    %eax,0x4(%esp)
8010773c:	e8 0f 8f ff ff       	call   80100650 <cprintf>
		return -1;
80107741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107746:	e9 98 fe ff ff       	jmp    801075e3 <shm_close+0x53>
