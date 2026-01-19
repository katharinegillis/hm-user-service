using Server.Types;

namespace Server.Tests.Unit.Types;

[Parallelizable]
[Category("Unit")]
public class QueryTests
{
    [Test]
    public void GetBook_Returns_Book()
    {
        // Arrange
        // Act
        var result = Query.GetBook();
        
        // Assert
        using (Assert.EnterMultipleScope())
        {
            Assert.That(result.Title, Is.EqualTo("C# in depth."));
            Assert.That(result.Author.Name, Is.EqualTo("John Skeet"));
        }
    }
}