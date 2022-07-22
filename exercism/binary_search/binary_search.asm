section .text
global find
find:
    ; Provide your implementation here
    ;;push rbp
;; find takes three parameters (rdi, rsi, rdx)
;; rdi = pointer to array of integers
;; rdi = *array
;; rsi = sizeof(array), as in, number of elements in array (not sizeof pointer to array)
;; rdx = key that we are searching for in the array
;; 
;; esi, because this is a 32bit integer value, so it will only need register of size word (32bits)
;; same for rdx, 32bit integer value, only necessitates 32bit reg



    ;;mov rcx, rdi
    ;;mov rdx, rsi
    ;;mov r12, rdx 
    ;; check to see if the pointer to the array is NULL, meaning that the array is empty
    ;; in NASM, NULL is defined as zero
    cmp rdi, 0
    je binary_search_empty
    cmp esi, 0
    je binary_search_empty
    ;; args will get pushed in reverse order
    ;; so push in reverse order of (array, sizeof(array), key) = (rdi, rsi, rdx)
    push rbp
    ;;mov rbp, rsp
    ;;mov [rsp-32], rbp
    mov rsp, rbp
    push rdx
    push rsi
    push rdi
    sub rsp, 24
    ;;jmp binary_search_non_empty
    call binary_search_non_empty 
    pop rdi
    pop rsi
    pop rdx
    add rsp, 24
    mov rbp, rsp
    pop rbp
    ret

binary_search_empty:
    xor rax, rax
    dec rax
    ret

binary_search_non_empty:
  ;; index of key
  xor eax, eax
  
  ;; high
  ;;xor r9, r9
  ;; low
  xor ebx, ebx
  mov dword[rbp-12], ebx
  mov ebx, dword[rbp-12]
 
  ;;so [rbp-8*i] where i is some integer, are addresses of local variables within the function
  ;; so we can use [rbp -8] and [rbp - 16] etc etc, to store the values of our variables low, high and mid, rather than try to use the intermediaries of the registers, only some which are callee-save registers and won't preserve their values between diff calls i.e. within the loop body etc. (yeah that's a long-winded explanation of what a local variable is; I don't care. I find tangential explanations in code comments useful. Also it's my code, my rules. Why are you even in this comment in the first place? This is for my own notes. ugh!!)
  
  ;;set rcx to value of ARRAY_SIZE, which is on the stack at rbp+16
  mov ecx, dword[rbp+16]
  mov dword[rbp-4], ecx
  ;; subtract 1 from rcx, so that rcx is at the index of last element in array
  dec dword[rbp-4]
  mov ecx, dword[rbp-4]
  ;;dec rcx
  
;;if (low > high), then array is invalid, break out of this function, return -1
  ;;cmp rbx, rdx
  ;;cmp rbx, qword[rbp-8]
  jmp bin_search_loop 
  
bin_search_loop:
  ;;cmp bx, word[rbp-8]
  cmp ebx, dword[rbp-4]
  jnl binary_search_empty
;;bin_search_loop:

  ;;mid = (low + high) // 2
  ;;eax:edx / ecx
  ;; div ecx (result goes in ecx) 
  ;;
  ;;mov rax, 0
  ;;mov rdx, [rbp+16]
  ;;mov rcx, 2
  ;;div rcx
  ;;mov r12, [rbp+16]
  mov r12d, dword[rbp-8]
  add r12d, dword[rbp-12]
  mov dword[rbp-8], r12d
  dec dword[rbp-8]
  sar r12d, 1
  ;;dec r12
  sar dword[rbp-8], 1

  ;;xor r14, r14
  ;;lea r14, [r12]
  ;;imul r14, 8
  ;;imul r12, 8
  ;;jmp bin_search_loop 

  
  xor r13d, r13d
  ;; r13 = arr[mid]
  ;; since [rbp+24] is *array
  ;; and mid is our index 
  ;; so *(array + mid)
  ;;mov r13d, [rbp+24+r12d]
  lea r14, [rbp+24]
  mov r13d, dword[r14+r12]
  ;;mov r13d, dword[rbp+24+r12d]
  ;;add r13d, r12d
  ;;mov r14d, [r13d]
  ;;mov qword[rbp+32], r13
  ;;mov r13, [rbp+24]
  test r13d, [rbp+16]
  ;;cmp r14d, [r13d]
  ;;push rcx
  ;;push rbx
  ;;push r12
  jz mid_key
  jl right_recurse
  jg left_recurse
  ;;jl right_recurse
  ;;add logic here for incrementing/decrementing high/low within loop
  ;;jne binary_search_non_empty
  ;;mov rax, qword[rbp+32]
mid_key:
  mov eax, r12d
  ret

left_recurse:
  mov dword[rbp-4], r12d
  dec dword[rbp-4]
  mov ecx, dword[rbp-4]
  jmp bin_search_loop
  ;; originally, when initializing value of high:
  ;;mov cx, word[rbp+16]
  ;;mov word[rbp-4], cx
  ;; Now:
  ;; high = mid -1
  ;; cx = word[rbp-8]
  ;;
    
right_recurse:
  mov dword[rbp-12], r12d
  inc dword[rbp-12]
  mov ebx, dword[rbp-12]
  jmp bin_search_loop
  ;; originally, when initializing value of low:
  ;;mov word[rsp-12], bx
  ;;mov bx, word[rsp-12]
  ;; Now:
  ;;low = mid + 1
  ;; rbx = word[rsp - 12] 
;;shl r12, 1


