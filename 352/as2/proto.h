/* argugment parsing */
int arg_parse(char *line, char ***argvp);

/* builtin commands */
void (*get_builtin(char *name))(char **argv);
