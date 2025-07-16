# Fortify修复办法汇总

| 错误                                                  | 修复方法                         |
|-----------------------------------------------------|------------------------------|
| Key Management: Hardcoded Encryption Key            | 将关键字“key”修改为其他单词             |
| Privacy Violation                                   | 注释代码或者删除代码                   |
| Privacy Violation: Autocomplete                     | input 增加autocomplete="off"   |
| Password Management: Password in Configuration File | 将关键字“password”修改为其他单词        |
| SQL Injection: MyBatis Mapper                       | $改成#                         |
| SQL Injection                                       | Statement改成PreparedStatement |
| Log Forging                                         |                              |
| .                                                   | .                            |
| .                                                   | .                            |