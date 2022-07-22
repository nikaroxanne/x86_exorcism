section .text
global find
find:
;; find takes three parameters (rdi, rsi, rdx)
;; rdi = pointer to array of integers
;; rdi = *array
;; rsi = sizeof(array), as in, number of elements in array (not sizeof pointer to array)
;; rdx = key that we are searching for in the array
;; 


    ;; check to see if the pointer to the array is NULL, meaning that the array is empty
    ;; in NASM, NULL is defined as zero
    cmp rdi, 0
    je binary_search_empty
    cmp esi, 0
    je binary_search_empty
    ;; args will get pushed in reverse order
    ;; so push in reverse order of (array, sizeof(array), key) = (rdi, rsi, rdx)
    ;; push rbp, mov rbp to rsp
    ;; then push args rdi, rsi, rdx in reverse order
    ;; finally subtract size of stack frame from rsp (8 * 3 = 24), so rsp=rsp-24
    ;; size of stack frame is 24 because we are pushing 3 8-byte registers onto the stack
    ;; could we make do with a smaller stack frame, assuming 32bit integer values? 
    ;; yeah probably, but then I would have to rewrite a good portion of this to specify that it's 32bit
    ;; also the problem spec didn't specify word size of int values, so I'm **playing it safe** lmao w 64bit
    push rbp
    mov rsp, rbp
    push rdx
    push rsi
    push rdi
    sub rsp, 24
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
  
  ;; ebx = low
  xor ebx, ebx
  mov dword[rbp-12], ebx
  mov ebx, dword[rbp-12]
 
  ;;  so [rbp-8*i], where i is some integer, are addresses of local variables within the function
  ;; so we can use [rbp -8] and [rbp - 16] etc etc, to store the values of our variables low, high and mid, rather than try to use the intermediaries of the registers, 
  ;; only some of which are callee-save registers and won't preserve their values between diff calls i.e. within the loop body etc. 
  
  
  ;; ecx = high
  ;;set ecx to value of ARRAY_SIZE, which is on the stack at rbp+16
  mov ecx, dword[rbp+16]
  mov dword[rbp-4], ecx
  ;; subtract 1 from rcx, so that rcx is at the index of last element in array
  dec dword[rbp-4]
  mov ecx, dword[rbp-4]
  
  jmp bin_search_loop 
  
bin_search_loop:
  cmp ebx, dword[rbp-4]
  jnl binary_search_empty
  ;;  if (low > high), then array is invalid, break out of this function, return -1

  ;;mid = (low + high) // 2
  ;; 
  ;; 
  ;;
  mov r12d, dword[rbp-8]
  add r12d, dword[rbp-12]
  mov dword[rbp-8], r12d
  dec dword[rbp-8]
  sar r12d, 1
  sar dword[rbp-8], 1

  ;; r13 = arr[mid]
  ;; since [rbp+24] is *array
  ;; and mid is our index 
  ;; so *(array + mid)
  
  xor r13d, r13d
  lea r14, [rbp+24]
  mov r13d, dword[r14+r12]
  test r13d, [rbp+16]

  jz mid_key
  jl right_recurse
  jg left_recurse

mid_key:
  mov eax, r12d
  ret

left_recurse:
  mov dword[rbp-4], r12d
  dec dword[rbp-4]
  mov ecx, dword[rbp-4]
  jmp bin_search_loop
  ;;
  ;; originally, when initializing value of high:
  ;; mov ecx, dword[rbp+16]
  ;; mov word[rbp-4], cx
  ;; Now:
  ;; high = mid -1
  ;; ecx = dword[rbp-8]
  ;;
    
right_recurse:
  mov dword[rbp-12], r12d
  inc dword[rbp-12]
  mov ebx, dword[rbp-12]
  jmp bin_search_loop
  ;;
  ;; originally, when initializing value of low:
  ;; mov dword[rsp-12], ebx
  ;; mov ebx, word[rsp-12]
  ;; Now:
  ;; low = mid + 1
  ;; ebx = dword[rsp - 12] 


