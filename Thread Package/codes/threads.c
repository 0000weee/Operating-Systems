#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0
 
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){

        current_thread = t;
        current_thread -> next = t;
        current_thread -> previous = t;
    }
    else{
        current_thread-> previous -> next = t;
        t->previous = current_thread-> previous; 
        t->next  = current_thread;    
        current_thread-> previous = t;      
    }
}
void thread_yield(void){
    if(current_thread->task==NULL){//no task, thread calls yield() as Part 1
        if (setjmp(current_thread->env) == 0) {
            current_thread->buf_set = 1;
            schedule();
            dispatch(); 
        }
    }
    else{//task exists
        //thread call yield
        unsigned long cur_sp = (unsigned long )current_thread->stack_p;
        if(current_thread->env -> sp == cur_sp){
            if (setjmp(current_thread->env) == 0) {
                current_thread->buf_set = 1;
                schedule();
                dispatch();     
            }
        }
        else{                //task calls yield()
            if (setjmp(current_thread->task->env) == 0) {
                current_thread->task->buf_set = 1;
                schedule();
                dispatch(); 
            }
        }
        
    }
}
void dispatch(void){
    //Part 1
    if(current_thread->task==NULL){
        if (current_thread->buf_set == 0) {    
            if (setjmp(current_thread->env) == 0) {
                current_thread->env -> sp = (unsigned long )current_thread->stack_p;
                longjmp(current_thread->env,1);
            }
            else{
                current_thread->fp(current_thread->arg);
                thread_exit();
            }
        } 
        else{
            longjmp(current_thread->env, 1); 
        }
    }
    //Part 2
    else{
        if (current_thread->task->buf_set == 0) {
            if (setjmp(current_thread->task->env) == 0) {
                current_thread->task->env -> sp = (unsigned long )current_thread->task->stack_p;
                longjmp(current_thread->task->env,1);
            }
            else{
                
                current_thread->task->fp(current_thread->task->arg);//finish this task
                
                if(current_thread->task->previous_task != NULL){
                    struct task_node* tmp = current_thread->task;
                    
                    current_thread->task = tmp->previous_task;
                    free(tmp->stack);
                    free(tmp);
                    dispatch();
                }
                else{//no other tasks
                
                    free(current_thread->task->stack);
                    free(current_thread->task);
                    current_thread->task = NULL;
                    dispatch();
                }
            }
        }
        else{
            longjmp(current_thread->task->env, 1); 
        }
    }
}

void schedule(void){
    current_thread = current_thread->next;
}
void thread_exit(void){
    if(current_thread->next != current_thread){
        
        current_thread-> previous->next = current_thread-> next;
        current_thread->next->previous = current_thread->previous;
    
        free(current_thread->stack);
        //free(current_thread->stack_p);
        struct thread* tmp = current_thread;
        current_thread = current_thread->next;
        free(tmp);
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        free(current_thread->stack);
        //free(current_thread->stack_p);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st,1);
    }

}
void thread_start_threading(void){
    if(current_thread!=NULL){
        if(setjmp(env_st)==0){
            dispatch();
            
        }    
        else{

        }
    }
    
}

// part 2
struct task_node *task_create(void (*f)(void *), void *arg){
    struct task_node *t = (struct task_node*) malloc(sizeof(struct task_node));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    //t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    //id++;
    t->previous_task = NULL;
    //t->executed = 0;
    return t;
}

void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
    // TODO
    //creat a new task
    struct task_node* new_task = task_create(f,arg);
    
    //add to the task list
    new_task->previous_task = t->task;
    t->task = new_task;
}
