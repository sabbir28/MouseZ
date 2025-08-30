	.file	"MouseZR.c"
	.text
	.globl	keep_running
	.data
	.align 4
	.type	keep_running, @object
	.size	keep_running, 4
keep_running:
	.long	1
	.text
	.globl	signal_handler
	.type	signal_handler, @function
signal_handler:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	$0, keep_running(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	signal_handler, .-signal_handler
	.globl	set_non_blocking
	.type	set_non_blocking, @function
set_non_blocking:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	$0, %edx
	movl	$3, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	fcntl@PLT
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	jne	.L3
	movl	$-1, %eax
	jmp	.L4
.L3:
	movl	-4(%rbp), %eax
	orb	$8, %ah
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	movl	$4, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	fcntl@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	set_non_blocking, .-set_non_blocking
	.section	.rodata
.LC0:
	.string	"Starting MouseZR Server..."
	.align 8
.LC1:
	.string	"[TEST] Virtual mouse device created successfully."
	.align 8
.LC2:
	.string	"[TEST] Mouse self-test completed."
	.align 8
.LC3:
	.string	"[TEST] Failed to create virtual mouse device!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	leaq	signal_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	signal@PLT
	leaq	signal_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	call	mouse_init_uinput
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jle	.L6
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	$0, %edx
	movl	$10, %esi
	movl	%eax, %edi
	call	mouse_move_uinput
	movl	-4(%rbp), %eax
	movl	$272, %esi
	movl	%eax, %edi
	call	mouse_click_uinput
	movl	-4(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	mouse_scroll_uinput
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	mouse_close_uinput
	movl	$0, %eax
	call	run_server
	movl	$0, %eax
	jmp	.L8
.L6:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %eax
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC4:
	.string	"%15s %15s %15s"
.LC5:
	.string	"MOVE"
.LC6:
	.string	"OK: MOVED X=%d Y=%d\n"
.LC7:
	.string	"CLICK"
.LC8:
	.string	"RIGHT"
.LC9:
	.string	"OK: CLICK %s\n"
.LC10:
	.string	"SCROLL"
.LC11:
	.string	"OK: SCROLLED %d\n"
.LC12:
	.string	"ERR: UNKNOWN COMMAND\n"
	.text
	.globl	process_command
	.type	process_command, @function
process_command:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movl	%edi, -100(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movq	%rcx, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -92(%rbp)
	movl	$0, -88(%rbp)
	movl	$0, -84(%rbp)
	leaq	-64(%rbp), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-48(%rbp), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-32(%rbp), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-32(%rbp), %rsi
	leaq	-48(%rbp), %rcx
	leaq	-64(%rbp), %rdx
	movq	-112(%rbp), %rax
	movq	%rsi, %r8
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, -80(%rbp)
	jmp	.L10
.L11:
	movq	-80(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	toupper@PLT
	movl	%eax, %edx
	movq	-80(%rbp), %rax
	movb	%dl, (%rax)
	addq	$1, -80(%rbp)
.L10:
	movq	-80(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L11
	leaq	-64(%rbp), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L12
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -92(%rbp)
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -88(%rbp)
	movl	-88(%rbp), %edx
	movl	-92(%rbp), %ecx
	movl	-100(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	mouse_move_uinput
	movl	-88(%rbp), %ecx
	movl	-92(%rbp), %edx
	movq	-120(%rbp), %rax
	movl	%ecx, %r8d
	movl	%edx, %ecx
	leaq	.LC6(%rip), %rdx
	movl	$128, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	-128(%rbp), %rdx
	movq	%rax, (%rdx)
	jmp	.L20
.L12:
	leaq	-64(%rbp), %rax
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L14
	movl	$272, -96(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, -72(%rbp)
	jmp	.L15
.L16:
	movq	-72(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	toupper@PLT
	movl	%eax, %edx
	movq	-72(%rbp), %rax
	movb	%dl, (%rax)
	addq	$1, -72(%rbp)
.L15:
	movq	-72(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L16
	leaq	-48(%rbp), %rax
	leaq	.LC8(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L17
	movl	$273, -96(%rbp)
.L17:
	movl	-96(%rbp), %edx
	movl	-100(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	mouse_click_uinput
	leaq	-48(%rbp), %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rcx
	leaq	.LC9(%rip), %rdx
	movl	$128, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	-128(%rbp), %rdx
	movq	%rax, (%rdx)
	jmp	.L20
.L14:
	leaq	-64(%rbp), %rax
	leaq	.LC10(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L18
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -84(%rbp)
	movl	-84(%rbp), %edx
	movl	-100(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	mouse_scroll_uinput
	movl	-84(%rbp), %edx
	movq	-120(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC11(%rip), %rdx
	movl	$128, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	-128(%rbp), %rdx
	movq	%rax, (%rdx)
	jmp	.L20
.L18:
	movq	-120(%rbp), %rax
	leaq	.LC12(%rip), %rdx
	movl	$128, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	-128(%rbp), %rdx
	movq	%rax, (%rdx)
.L20:
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L19
	call	__stack_chk_fail@PLT
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	process_command, .-process_command
	.section	.rodata
.LC13:
	.string	"Error creating socket"
.LC14:
	.string	"Error setting socket options"
.LC15:
	.string	"Error binding socket"
.LC16:
	.string	"Error listening on socket"
	.align 8
.LC17:
	.string	"Error setting non-blocking mode"
	.align 8
.LC18:
	.string	"MouseZR Server is running on port %d...\n"
	.align 8
.LC19:
	.string	"Failed to initialize uinput device"
.LC20:
	.string	"Select error"
	.align 8
.LC21:
	.string	"Error accepting client connection"
.LC22:
	.string	"Client connected: %s:%d\n"
	.align 8
.LC23:
	.string	"Error setting client non-blocking mode"
.LC24:
	.string	"Client disconnected: %s\n"
	.align 8
.LC25:
	.string	"Client disconnected gracefully."
.LC26:
	.string	"Received: %s"
.LC27:
	.string	"Error sending response: %s\n"
	.align 8
.LC28:
	.string	"MouseZR Server shutting down..."
	.text
	.globl	run_server
	.type	run_server, @function
run_server:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$1416, %rsp
	.cfi_offset 3, -24
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$-1, -1408(%rbp)
	movl	$-1, -1404(%rbp)
	movl	$16, -1424(%rbp)
	movl	$-1, -1400(%rbp)
	movl	$1, -1420(%rbp)
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket@PLT
	movl	%eax, -1408(%rbp)
	cmpl	$0, -1408(%rbp)
	jns	.L22
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	leaq	-1420(%rbp), %rdx
	movl	-1408(%rbp), %eax
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$2, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	je	.L23
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	leaq	-1344(%rbp), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movw	$2, -1344(%rbp)
	movl	$0, -1340(%rbp)
	movl	$8080, %edi
	call	htons@PLT
	movw	%ax, -1342(%rbp)
	leaq	-1344(%rbp), %rcx
	movl	-1408(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind@PLT
	testl	%eax, %eax
	jns	.L24
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %edi
	call	exit@PLT
.L24:
	movl	-1408(%rbp), %eax
	movl	$5, %esi
	movl	%eax, %edi
	call	listen@PLT
	testl	%eax, %eax
	jns	.L25
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %edi
	call	exit@PLT
.L25:
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	set_non_blocking
	testl	%eax, %eax
	jns	.L26
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	movl	$8080, %esi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	call	mouse_init_uinput
	movl	%eax, -1400(%rbp)
	cmpl	$0, -1400(%rbp)
	jns	.L28
	leaq	.LC19(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %edi
	call	exit@PLT
.L53:
	movq	$1, -1360(%rbp)
	movq	$0, -1352(%rbp)
	leaq	-1312(%rbp), %rax
	movq	%rax, -1384(%rbp)
	movl	$0, -1416(%rbp)
	jmp	.L29
.L30:
	movq	-1384(%rbp), %rax
	movl	-1416(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -1416(%rbp)
.L29:
	cmpl	$15, -1416(%rbp)
	jbe	.L30
	movl	-1408(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-1312(%rbp,%rax,8), %rdx
	movl	-1408(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -1312(%rbp,%rax,8)
	movl	-1408(%rbp), %eax
	leal	1(%rax), %edi
	leaq	-1360(%rbp), %rdx
	leaq	-1312(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movl	%eax, -1396(%rbp)
	cmpl	$0, -1396(%rbp)
	jns	.L31
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L31
	leaq	.LC20(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L28
.L31:
	cmpl	$0, -1396(%rbp)
	je	.L57
	leaq	-1424(%rbp), %rdx
	leaq	-1328(%rbp), %rcx
	movl	-1408(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept@PLT
	movl	%eax, -1404(%rbp)
	cmpl	$0, -1404(%rbp)
	jns	.L34
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L58
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L58
	leaq	.LC21(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L58
.L34:
	movzwl	-1326(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	ntohs@PLT
	movzwl	%ax, %ebx
	movl	-1324(%rbp), %eax
	movl	%eax, %edi
	call	inet_ntoa@PLT
	movl	%ebx, %edx
	movq	%rax, %rsi
	leaq	.LC22(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-1404(%rbp), %eax
	movl	%eax, %edi
	call	set_non_blocking
	testl	%eax, %eax
	jns	.L36
	leaq	.LC23(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1404(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L28
.L36:
	movl	$0, -1412(%rbp)
	jmp	.L37
.L51:
	leaq	-1056(%rbp), %rax
	movl	$1024, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-1056(%rbp), %rsi
	movl	-1404(%rbp), %eax
	movl	$0, %ecx
	movl	$1023, %edx
	movl	%eax, %edi
	call	recv@PLT
	movq	%rax, -1376(%rbp)
	cmpq	$0, -1376(%rbp)
	jns	.L38
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L39
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	jne	.L40
.L39:
	movl	$100000, %edi
	call	usleep@PLT
	jmp	.L37
.L40:
	call	__errno_location@PLT
	movl	(%rax), %eax
	movl	%eax, %edi
	call	strerror@PLT
	movq	%rax, %rsi
	leaq	.LC24(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L50
.L38:
	cmpq	$0, -1376(%rbp)
	jne	.L42
	leaq	.LC25(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L50
.L42:
	leaq	-1056(%rbp), %rdx
	movq	-1376(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	leaq	-1056(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC26(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	$0, -1392(%rbp)
	leaq	-1184(%rbp), %rax
	movl	$128, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-1392(%rbp), %rcx
	leaq	-1184(%rbp), %rdx
	leaq	-1056(%rbp), %rsi
	movl	-1400(%rbp), %eax
	movl	%eax, %edi
	call	process_command
	movl	$0, -1412(%rbp)
	jmp	.L43
.L49:
	movq	-1392(%rbp), %rdx
	leaq	-1184(%rbp), %rsi
	movl	-1404(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send@PLT
	movq	%rax, -1368(%rbp)
	cmpq	$0, -1368(%rbp)
	jns	.L44
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L45
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	jne	.L46
.L45:
	movl	-1412(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -1412(%rbp)
	cmpl	$2, %eax
	jg	.L46
	movl	$1, %edi
	call	sleep@PLT
	jmp	.L43
.L46:
	call	__errno_location@PLT
	movl	(%rax), %eax
	movl	%eax, %edi
	call	strerror@PLT
	movq	%rax, %rsi
	leaq	.LC27(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L37
.L44:
	movq	-1392(%rbp), %rax
	movq	-1368(%rbp), %rdx
	subq	%rdx, %rax
	movq	%rax, -1392(%rbp)
	movq	-1392(%rbp), %rax
	testq	%rax, %rax
	je	.L59
	movq	-1392(%rbp), %rdx
	movq	-1368(%rbp), %rax
	leaq	-1184(%rbp), %rcx
	addq	%rax, %rcx
	leaq	-1184(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movl	$0, -1412(%rbp)
.L43:
	movq	-1392(%rbp), %rax
	testq	%rax, %rax
	jne	.L49
	jmp	.L37
.L59:
	nop
.L37:
	movl	keep_running(%rip), %eax
	testl	%eax, %eax
	jne	.L51
.L50:
	cmpl	$0, -1404(%rbp)
	js	.L28
	movl	-1404(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$-1, -1404(%rbp)
	jmp	.L28
.L57:
	nop
	jmp	.L28
.L58:
	nop
.L28:
	movl	keep_running(%rip), %eax
	testl	%eax, %eax
	jne	.L53
	cmpl	$0, -1400(%rbp)
	js	.L54
	movl	-1400(%rbp), %eax
	movl	%eax, %edi
	call	mouse_close_uinput
.L54:
	cmpl	$0, -1408(%rbp)
	js	.L55
	movl	-1408(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L55:
	leaq	.LC28(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L56
	call	__stack_chk_fail@PLT
.L56:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	run_server, .-run_server
	.section	.rodata
.LC29:
	.string	"/dev/uinput"
.LC30:
	.string	"Error opening /dev/uinput"
.LC31:
	.string	"Error setting uinput events"
	.align 8
.LC32:
	.string	"Error setting up uinput device"
	.text
	.globl	mouse_init_uinput
	.type	mouse_init_uinput, @function
mouse_init_uinput:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$2049, %esi
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -116(%rbp)
	cmpl	$0, -116(%rbp)
	jns	.L61
	leaq	.LC30(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L67
.L61:
	movl	-116(%rbp), %eax
	movl	$1, %edx
	movl	$1074025828, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$272, %edx
	movl	$1074025829, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$273, %edx
	movl	$1074025829, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$2, %edx
	movl	$1074025828, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$0, %edx
	movl	$1074025830, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$1, %edx
	movl	$1074025830, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L63
	movl	-116(%rbp), %eax
	movl	$8, %edx
	movl	$1074025830, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	jns	.L64
.L63:
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-116(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$-1, %eax
	jmp	.L67
.L64:
	leaq	-112(%rbp), %rax
	movl	$92, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movw	$3, -112(%rbp)
	movw	$4660, -110(%rbp)
	movw	$22136, -108(%rbp)
	leaq	-112(%rbp), %rax
	addq	$8, %rax
	movabsq	$2329023349079240525, %rsi
	movabsq	$2336349463791167830, %rdi
	movq	%rsi, (%rax)
	movq	%rdi, 8(%rax)
	movl	$1937076045, 16(%rax)
	movw	$101, 20(%rax)
	leaq	-112(%rbp), %rdx
	movl	-116(%rbp), %eax
	movl	$1079792899, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	js	.L65
	movl	-116(%rbp), %eax
	movl	$21761, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	jns	.L66
.L65:
	leaq	.LC32(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-116(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$-1, %eax
	jmp	.L67
.L66:
	movl	$1, %edi
	call	sleep@PLT
	movl	-116(%rbp), %eax
.L67:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L68
	call	__stack_chk_fail@PLT
.L68:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	mouse_init_uinput, .-mouse_init_uinput
	.section	.rodata
.LC33:
	.string	"Error writing REL_X"
.LC34:
	.string	"Error writing REL_Y"
.LC35:
	.string	"Error syncing move"
	.text
	.globl	mouse_move_uinput
	.type	mouse_move_uinput, @function
mouse_move_uinput:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$0, -36(%rbp)
	js	.L76
	leaq	-32(%rbp), %rax
	movl	$24, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	cmpl	$0, -40(%rbp)
	je	.L72
	movw	$2, -16(%rbp)
	movw	$0, -14(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L72
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L72:
	cmpl	$0, -44(%rbp)
	je	.L73
	movw	$2, -16(%rbp)
	movw	$1, -14(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L73
	leaq	.LC34(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L73:
	movw	$0, -16(%rbp)
	movw	$0, -14(%rbp)
	movl	$0, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L69
	leaq	.LC35(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L69
.L76:
	nop
.L69:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L75
	call	__stack_chk_fail@PLT
.L75:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	mouse_move_uinput, .-mouse_move_uinput
	.section	.rodata
.LC36:
	.string	"Error pressing button"
.LC37:
	.string	"Error syncing press"
.LC38:
	.string	"Error releasing button"
.LC39:
	.string	"Error syncing release"
	.text
	.globl	mouse_click_uinput
	.type	mouse_click_uinput, @function
mouse_click_uinput:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$0, -36(%rbp)
	js	.L85
	leaq	-32(%rbp), %rax
	movl	$24, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	movw	$1, -16(%rbp)
	movl	-40(%rbp), %eax
	movw	%ax, -14(%rbp)
	movl	$1, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L80
	leaq	.LC36(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L80:
	movw	$0, -16(%rbp)
	movw	$0, -14(%rbp)
	movl	$0, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L81
	leaq	.LC37(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L81:
	movw	$1, -16(%rbp)
	movl	-40(%rbp), %eax
	movw	%ax, -14(%rbp)
	movl	$0, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L82
	leaq	.LC38(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L82:
	movw	$0, -16(%rbp)
	movw	$0, -14(%rbp)
	movl	$0, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L77
	leaq	.LC39(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L77
.L85:
	nop
.L77:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L84
	call	__stack_chk_fail@PLT
.L84:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	mouse_click_uinput, .-mouse_click_uinput
	.section	.rodata
.LC40:
	.string	"Error writing REL_WHEEL"
.LC41:
	.string	"Error syncing scroll"
	.text
	.globl	mouse_scroll_uinput
	.type	mouse_scroll_uinput, @function
mouse_scroll_uinput:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$0, -36(%rbp)
	js	.L92
	leaq	-32(%rbp), %rax
	movl	$24, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	cmpl	$0, -40(%rbp)
	je	.L89
	movw	$2, -16(%rbp)
	movw	$8, -14(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L89
	leaq	.LC40(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L89:
	movw	$0, -16(%rbp)
	movw	$0, -14(%rbp)
	movl	$0, -12(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$24, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	testq	%rax, %rax
	jns	.L86
	leaq	.LC41(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L86
.L92:
	nop
.L86:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L91
	call	__stack_chk_fail@PLT
.L91:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	mouse_scroll_uinput, .-mouse_scroll_uinput
	.section	.rodata
	.align 8
.LC42:
	.string	"Error destroying uinput device"
	.text
	.globl	mouse_close_uinput
	.type	mouse_close_uinput, @function
mouse_close_uinput:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	js	.L96
	movl	-4(%rbp), %eax
	movl	$21762, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	testl	%eax, %eax
	jns	.L95
	leaq	.LC42(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L95:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L96:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	mouse_close_uinput, .-mouse_close_uinput
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
