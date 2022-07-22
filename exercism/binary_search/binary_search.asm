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


    ;;mov rcx, rdi
    ;;mov rdi, rsi
    ;;mov r12, rdx 
    ;; check to see if the pointer to the array is NULL, meaning that the array is empty
    ;; in NASM, NULL is defined as zero
    cmp byte [rdi], 0
    je binary_search_empty
    cmp rsi, 0
    je binary_search_empty
    ;; args will get pushed in reverse order
    ;; so push in reverse order of (array, sizeof(array), key) = (rdi, rsi, rdx)
    sub rsp, 32
    push rbp
    ;;mov [rsp-32], rbp
    push rdx
    push rsi
    push rdi
    ;;jmp binary_search_non_empty
    call binary_search_non_empty 
    pop rdi
    pop rsi
    pop rdx
    pop rbp
    add rsp, 32
    ret

binary_search_empty:
    xor rax, rax
    dec rax
    ret

binary_search_non_empty:
  ;; index of key
  xor rax, rax
  
  ;; high
  ;;xor r9, r9
  ;; low
  xor rbx, rbx
  mov qword[rsp-24], rbx
  mov rbx, qword[rsp-24]
 
  ;;so [rsp-8*i] where i is some integer, are addresses of local variables within the function
  ;; so we can use [rsp -8] and [rsp - 16] etc etc, to store the values of our variables low, high and mid, rather than try to use the intermediaries of the registers, only some which are callee-save registers and won't preserve their values between diff calls i.e. within the loop body etc. (yeah that's a long-winded explanation of what a local variable is; I don't care. I find tangential explanations in code comments useful. Also it's my code, my rules. Why are you even in this comment in the first place? This is for my own notes. ugh!!)
  
  ;;set rcx to value of ARRAY_SIZE, which is on the stack at rsp+16
  mov rcx, qword[rsp+16]
  mov qword[rsp-8], rcx
  ;; subtract 1 from rcx, so that rcx is at the index of last element in array
  dec qword[rsp-8]
  ;;dec rcx
  
;;if (low > high), then array is invalid, break out of this function, return -1
  ;;cmp rbx, rdx
  ;;cmp rbx, qword[rsp-8]
  jmp bin_search_loop 
  
bin_search_loop:
  cmp rbx, qword[rsp-8]
  ;;cmp rbx, rcx
  jg binary_search_empty
;;bin_search_loop:

  ;;mid = (low + high) // 2
  ;;eax:edx / ecx
  ;; div ecx (result goes in ecx) 
  ;;
  ;;mov rax, 0
  ;;mov rdx, [rsp+16]
  ;;mov rcx, 2
  ;;div rcx
  ;;mov r12, [rsp+16]
  mov r12, qword[rsp-8]
  add r12, [rsp-24]
  mov qword[rsp-16], r12
  dec qword[rsp-16]
  sar r12, 1
  ;;dec r12
  sar qword[rsp-16], 1

  ;;xor r14, r14
  ;;lea r14, [r12]
  ;;imul r14, 8
  ;;imul r12, 8
  ;;jmp bin_search_loop 

  
  xor r13, r13
  ;; r13 = arr[mid]
  ;; since [rsp+24] is *array
  ;; and mid is our index 
  ;; so *(array + mid)
  mov r13, qword[rsp+24+r12]
  ;;mov qword[rsp+32], r13
  ;;mov r13, [rsp+24]
  cmp r13, qword[rsp+8]
  ;;push rcx
  ;;push rbx
  ;;push r12
  je mid_key
  jl right_recurse
  jg left_recurse
  ;;jl right_recurse
  ;;add logic here for incrementing/decrementing high/low within loop
  ;;jne binary_search_non_empty
  ;;mov rax, qword[rsp+32]
mid_key:
  mov rax, r12
  ret

left_recurse:
  mov qword[rsp-8], r12
  dec qword[rsp-8]
  jmp bin_search_loop
  ;;ret 
    
right_recurse:
  ;;shl r12, 1
  mov qword[rsp-24], r12
  inc qword[rsp-24]
  jmp bin_search_loop
